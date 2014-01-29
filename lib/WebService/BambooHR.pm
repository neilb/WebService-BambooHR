package WebService::BambooHR;

use Moo;
use HTTP::Tiny;
use Try::Tiny;
use JSON qw(decode_json);

with 'WebService::BambooHR::UserAgent';
use WebService::BambooHR::Employee;
use WebService::BambooHR::Exception;
use WebService::BambooHR::EmployeeChange;

my $DEFAULT_PHOTO_SIZE = 'small';
my $COMMA = ',';

sub employee_list
{
    my $self     = shift;
    my @fields   = @_ > 0 ? @_ : $self->_field_list();

    $self->_check_fields(@fields);

    my $body     = qq{<report output="xml">\n<title>test</title>\n<fields>\n}
                   .join("\n", map { qq[<field id="$_" />] } @fields)
                   .qq{\n</fields>\n</report>\n};
    my $response = $self->_post('reports/custom?format=json', $body);
    my $json     = $response->{content};

    # Workaround for a bug in BambooHR: if you ask for 'status' you get back 'employeeStatus'
    $json =~ s/"employmentStatus":/"status":/g;

    my $report   = decode_json($json);
    return map { WebService::BambooHR::Employee->new($_); } @{ $report->{employees} };
}

sub employee_directory
{
    my $self      = shift;
    my $response  = $self->_get('employees/directory');
    my $directory = decode_json($response->{content});

    return map { WebService::BambooHR::Employee->new($_); } @{ $directory->{employees} };
}

sub employee_photo
{
    my $self        = shift;
    my $employee_id = shift;
    my $photo_size  = @_ > 0 ? shift : $DEFAULT_PHOTO_SIZE;
    my $response;

    eval {
        $response = $self->_get("employees/$employee_id/photo/$photo_size");
    };
    if ($@) {
        return undef if ($@->code == 404);
        $@->throw();
    };

    return $response->{content};
}

sub employee
{
    my $self        = shift;
    my $employee_id = shift;
    my @fields      = @_ > 0 ? @_ : $self->_field_list();

    $self->_check_fields(@fields);

    my $url      = "employees/$employee_id?fields=".join($COMMA, @fields);
    my $response = $self->_get($url);
    my $json     = $response->{content};

    # Workaround for a bug in BambooHR: if you ask for 'status' you get back 'employeeStatus'
    $json =~ s/"employmentStatus":/"status":/g;

    return WebService::BambooHR::Employee->new(decode_json($json));
}

sub changed_employees
{
    my $self    = shift;
    my $since   = shift;
    my $url     = "employees/changed/?since=$since";
    my @changes;

    if (@_ > 0) {
        my $type = shift;
        $url .= "&type=$type";
    }
    my $response = $self->_get($url);

    require XML::Simple;

    # The ForceArray and KeyAttr options make it produce more JSON like data structure
    # see the XML::Simple doc for more
    my $changed_data = XML::Simple::XMLin($response->{content}, ForceArray => 1, KeyAttr => []);

    return map { WebService::BambooHR::EmployeeChange->new($_) } @{ $changed_data->{employee} };
}

sub add_employee
{
    my $self      = shift;
    my $field_ref = shift;

    $self->_check_fields(keys %$field_ref);

    my $body     = $self->_employee_record($field_ref);
    my $response = $self->_post('employees/', $body);

    my $location = $response->{headers}->{location};
    if ($location =~ m!/v1/employees/(\d+)$!) {
        return $1;
    } else {
        my @caller = caller(0);

        # The API call appeared to work, but the response headers
        # didn't contain the expected employee id.
        # Is 500 really the right status code here?
        WebService::BambooHR::Exception->throw({
            method      => __PACKAGE__.'::add_employee',
            message     => "API didn't return new employee id",
            code        => 500,
            reason      => 'Internal server error',
            filename    => $caller[1],
            line_number => $caller[2],
        });
    }
}

sub update_employee
{
    my $self      = shift;
    my $id        = shift;
    my $field_ref = shift;

    $self->_check_fields(keys %$field_ref);

    my $body     = $self->_employee_record($field_ref);
    my $response = $self->_post("employees/$id", $body);
}

sub _employee_record
{
    my $self      = shift;
    my $field_ref = shift;
    local $_;

    return "<employee>\n  "
                   .join("\n  ",
                         map { qq[<field id="$_">$field_ref->{$_}</field>] }
                         keys(%$field_ref)
                        )
                    ."\n"
          ."</employee>\n";
}


1;

=head1 NAME

WebService::BambooHR - interface to the API for BambooHR.com

=head1 SYNOPSIS

 use WebService::BambooHR;

 my $bamboo = WebService::BambooHR->new(
                  company => 'foobar',
                  api_key => '...'
              );
 
 $id        = $bamboo->add_employee({
                  firstName => 'Bilbo',
                  lastName  => 'Baggins',
              });

 $employee  = $bamboo->employee($id);
 
 $bamboo->update_employee($employee->id, {
     dateOfBirth => '1953-11-22',
     gender      => 'Male',
  });

=head1 DESCRIPTION

B<NOTE:> this is very much an alpha release. The interface is likely to change
from release to release. Suggestions for improving the interface are welcome.

B<WebService::BambooHR> provides an interface to a subset of the functionality
in the API for BambooHR (a commercial online HR system: lets a company manage
employee information, handle time off, etc).

To talk to BambooHR you must first create an instance of this module:

 my $bamboo = WebService::BambooHR->new(
                  company => 'mycompany',
                  api_key => $api_key,
              );
 
The B<company> field is the domain name that you use to access BambooHR.
For example, the above company would be accessed via C<mycompany.bamboohr.com>.
You also need an API key. See the section below on how to create one.

Having created an instance, you can use the public methods that are described below.
For example, to display a list of all employees:

 @employees = $bamboo->employee_list();
 foreach my $employee (@employees) {
     printf "Hi %s %s\n", $employee->firstName,
                          $employee->lastName;
 }

Note that the C<print> statement could more succinctly have been written as:

 print "Hi $employee\n";

The employee class overloads string-context rendering to display
the employee's name.

=head2 Generating an API key

To get an API key you need to be an I<admin user> of BambooHR.
Ask the owner of your BambooHR account to make you an admin user.
Once you are, login to Bamboo and generate an API key:
Look for the entry "API Keys" in the drop-menu under your name.

=head1 METHODS

=head2 employee_list

Returns a list of all employees in BambooHR for your company:

 @employees = $bamboo->employee_list();

Each employee is an instance of L<WebService::BambooHR::Employee>.
See the documentation for that module to see what information is
available for each employee. You can find out more information
from the L<BambooHR documentation|http://www.bamboohr.com/api/documentation/employees.php>.

This will return both active and inactive employees:
check the C<status> field if you only want to handle active employees:

 foreach my $employee ($bamboo->employee_list) {
    next if $employee->status eq 'Inactive';
    ...
 }

If you're only interested in specific employee fields, you can just ask for those:

 @fields    = qw(firstName lastName workEmail);
 @employees = $bamboo->employee_list(@fields);

All other fields will then return C<undef>,
regardless of whether they're set in BambooHR.

=head2 employee

Used to request a single employee using the employee's internal id,
optionally specifying what fields should be populated from BambooHR:

 $employee = $bamboo->employee($id);

This returns an instance of L<WebService::BambooHR::Employee>.
If no fields are specified in the request, then all fields will be available
via attributes on the employee object.

As for C<employee_list()> above, you can specify just the fields you're interested in:

 @fields   = qw(firstName lastName workEmail);
 $employee = $bamboo->employee($id, @fields);

=head2 add_employee

Add a new employee to your company, specifying initial values
for as many employee fields as you want to specify.
You must provide B<firstName> and B<lastName>:

 $id = $bamboo->add_employee({
           firstName => 'Bilbo',
           lastName  => 'Baggins',
           jobTitle  => 'Thief',
       });

This returns the internal id of the employee.

=head2 update_employee

This is used to update one or more fields for an employee:

 $bamboo->update_employee($employee_id, {
     workEmail => 'bilbo@hobbiton.org',
     bestEmail => 'bilbo@bag.end',
 });

=head2 employee_photo

Request an employee's photo, if one has been provided:

 $photo = $bamboo->employee_photo($employee_id);

This returns a JPEG image of size 150x150, or C<undef>
if the employee doesn't have a photo.

=head2 changed_employees

Returns a list of objects that identifies employees whose BambooHR accounts
have been changed since a particular date and time.
You must pass a date/time string in ISO 8601 format:

 @changes = $bamboo->changed_employees('2014-01-20T00:00:01Z');

The list contains instances of class L<WebService::BambooHR::EmployeeChange>,
which has three methods:

=over 4

=item * id

The internal id for the employee, which you would pass to the C<employee()> method,
for example.

=item * action

A string that identifies the most recent change to the employee.
It will be one of 'Inserted', 'Updated', or 'Deleted'.

=item * lastChanged

A date and time string in ISO 8601 format that gives the time of the last change.

=back

In place of the 'action' method, you could use one of the three convenience methods
(C<inserted>, C<updated>, and C<deleted>),
which are named after the legal values for action:

 print "employee was deleted\n" if $change->deleted;

=head1 Employee objects

A number of methods return one or more employee objects.
These are instances of L<WebService::BambooHR::Employee>.
You can find out what fields are supported
from the L<BambooHR documentation|http://www.bamboohr.com/api/documentation/employees.php>.
The methods are all named after the fields, exactly as they're given in the doc.
So for example:

 print "first name = ", $employee->firstName, "\n";
 print "work email = ", $employee->workEmail, "\n";

If you use an object in a string context, you'll get the person's full name.
So the following lines produce identical output:

 print "name = $employee\n";
 print "name = ", $employee->firstName, " ", $employee->lastName, "\n";

=head1 Exceptions

This module throws exceptions on failure. If you don't catch these,
it will effectively die with an error message that identifies the
method being called, the line in your code, and the error that occurred.

You can catch the exceptions using the C<eval> built-in, but you might
also choose to use L<Try::Tiny>.
For example, you must have permission to get a list of employees:

 try {
     $employee = $bamboo->employee($id);
 } catch {
     if ($_->code == 403) {
         print "You don't have permission to get that employee\n";
     } else {
         ...
     }
 };

The exceptions are instances of L<WebService::BambooHR::Exception>.
Look at the documentation for that module to see what information
is available with each exception.

=head1 LIMITATIONS

The full BambooHR API is not yet supported.
I'll gradually fill it in as I need it, or the whim takes me.
Pull requests are welcome: see the github repo below.

=head1 SEE ALSO

L<BambooHR API documentation|http://www.bamboohr.com/api/documentation/>

=head1 REPOSITORY

L<https://github.com/neilbowers/WebService-BambooHR>

=head1 AUTHOR

Neil Bowers E<lt>neilb@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Neil Bowers <neilb@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

