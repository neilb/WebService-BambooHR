package WebService::BambooHR::Employee;

use 5.006;
use Moo;
use overload
    q{""}    => 'as_string',
    fallback => 1;

sub as_string
{
    my $self = shift;

    return $self->firstName.' '.$self->lastName;
}

has 'address1' => (is => 'ro');
has 'address2' => (is => 'ro');
has 'age' => (is => 'ro');
has 'bestEmail' => (is => 'ro');
has 'birthday' => (is => 'ro');
has 'city' => (is => 'ro');
has 'country' => (is => 'ro');
has 'dateOfBirth' => (is => 'ro');
has 'department' => (is => 'ro');
has 'division' => (is => 'ro');
has 'eeo' => (is => 'ro');
has 'employeeNumber' => (is => 'ro');
has 'employmentStatus' => (is => 'ro');
has 'employmentHistoryStatus' => (is => 'ro');
has 'ethnicity' => (is => 'ro');
has 'exempt' => (is => 'ro');
has 'firstName' => (is => 'ro');
has 'flsaCode' => (is => 'ro');
has 'fullName1' => (is => 'ro');
has 'fullName2' => (is => 'ro');
has 'fullName3' => (is => 'ro');
has 'fullName4' => (is => 'ro');
has 'fullName5' => (is => 'ro');
has 'displayName' => (is => 'ro');
has 'gender' => (is => 'ro');
has 'hireDate' => (is => 'ro');
has 'homeEmail' => (is => 'ro');
has 'homePhone' => (is => 'ro');
has 'id' => (is => 'ro');
has 'jobTitle' => (is => 'ro');
has 'lastChanged' => (is => 'ro');
has 'lastName' => (is => 'ro');
has 'location' => (is => 'ro');
has 'maritalStatus' => (is => 'ro');
has 'middleName' => (is => 'ro');
has 'mobilePhone' => (is => 'ro');
has 'nickname' => (is => 'ro');
has 'payChangeReason' => (is => 'ro');
has 'payGroup' => (is => 'ro');
has 'payGroupId' => (is => 'ro');
has 'payRate' => (is => 'ro');
has 'payRateEffectiveDate' => (is => 'ro');
has 'payType' => (is => 'ro');
has 'ssn' => (is => 'ro');
has 'sin' => (is => 'ro');
has 'state' => (is => 'ro');
has 'stateCode' => (is => 'ro');
has 'status' => (is => 'ro');
has 'supervisor' => (is => 'ro');
has 'supervisorId' => (is => 'ro');
has 'supervisorEId' => (is => 'ro');
has 'terminationDate' => (is => 'ro');
has 'workEmail' => (is => 'ro');
has 'workPhone' => (is => 'ro');
has 'workPhonePlusExtension' => (is => 'ro');
has 'workPhoneExtension' => (is => 'ro');
has 'zipcode' => (is => 'ro');
has 'photoUploaded' => (is => 'ro');
has 'rehireDate' => (is => 'ro');
has 'standardHoursPerWeek' => (is => 'ro');
has 'bonusDate' => (is => 'ro');
has 'bonusAmount' => (is => 'ro');
has 'bonusReason' => (is => 'ro');
has 'bonusComment' => (is => 'ro');
has 'commissionDate' => (is => 'ro');
has 'commisionDate' => (is => 'ro');
has 'commissionAmount' => (is => 'ro');
has 'commissionComment' => (is => 'ro');

1;

=head1 NAME

WebService::BambooHR::Employee - data class for holding details of one employee

=head1 SYNOPSIS

 $employee = WebService::BambooHR::Employee->new(
                 firstName => 'Ford',
                 lastName  => 'Prefect',
                 workEmail => 'ford@betelgeuse.org',
             );

=head1 DESCRIPTION

WebService::BambooHR::Employee is a class for data objects that are used
by L<WebService::BambooHR>.

It supports attributes for all of the employee fields supported by BambooHR. 
You can get a list of these from the BambooHR documentation. The attributes
are named exactly the same as the fields.

At some point this documentation may contain at least a list of all
the attributes, and possibly descriptions, but I'm not sure it makes
sense to duplicate information that is better read at the source.

=head1 SEE ALSO

L<WebService::BambooHR>

L<Employee documentation|http://www.bamboohr.com/api/documentation/employees.php>
on BambooHR's website.

=head1 AUTHOR

Neil Bowers E<lt>neilb@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Neil Bowers <neilb@cpan.org>.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
