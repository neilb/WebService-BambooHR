#!perl

use strict;
use warnings;
use utf8;

use LWP::Online ':skip_all';
use Test::More 0.88 tests => 4;
use WebService::BambooHR;
my $domain  = 'testperl';
my $api_key = 'bfb359256c9d9e26b37309420f478f03ec74599b';
my $bamboo;
my @employees;
my $employee;

SKIP: {

    my $bamboo = WebService::BambooHR->new(
                        company => $domain,
                        api_key => $api_key);
    ok(defined($bamboo), "create BambooHR class");

    eval {
        @employees = $bamboo->employee_list();
    };
    ok(!$@ && @employees > 0, 'get employee list');

    ok(@employees == 122, 'expected number of employees');

    my $employee_string = render_employees(\@employees);
    my $expected_employee_string = read_data();
    is($employee_string, $expected_employee_string, "compare employee fields");

};

sub render_employees
{
    my $employee_ref = shift;
    my $result = "firstName|lastName|status|location|jobTitle\n";

    foreach my $employee (sort by_employee_name @$employee_ref) {
        $result .= $employee->firstName
                   .'|'
                   .$employee->lastName
                   .'|'
                   .$employee->status
                   .'|'
                   .($employee->location || '')
                   .'|'
                   .($employee->jobTitle || '')
                   ."\n";
    }

    return $result;
}

sub by_employee_name
{
    if ($a->lastName ne $b->lastName) {
        return $a->lastName cmp $b->lastName;
    } else {
        return $a->firstName cmp $a->firstName;
    }
}

sub read_data
{
    local $/;
    return scalar <DATA>;
}

__DATA__
firstName|lastName|status|location|jobTitle
Charlotte|Abbott|Active|Corporate Office|HR Specialist
Diane|Adams|Inactive||
Melissa|Allen|Active|Chicago|Marketing Facilitator
Kristina|Allen|Inactive||HR Specialist
JD|Allphin|Active|Chicago|Marketing Facilitator
Richard|Anderson|Active|St. Louis|Development Supervisor
Carmello|Anthony|Inactive|St. Louis|
Tyler|Arnold|Active||
David|Bagley|Active|St. Louis|Marketing Facilitator
Spencer|Baird|Inactive||VP
Jonathan|Baker|Active|St. Louis|Client Service Representative
Amber|Baldwin|Inactive||Marketing Facilitator
Greg|Banks|Active|St. Louis|Site Supervisor
Tammy|Barker|Inactive||
Trina|Barnes|Inactive||
Jill|Barnes|Inactive||VP
Julie|Barnes|Inactive||
Jonathan|Barringer|Active|St. Louis|Client Service Representative
Laura|Barry|Active||
Marc|Bean|Active|Chicago|Site Supervisor
Sherry|Brewer|Active||
Kobe|Bryant|Inactive||
George|Butler|Inactive||
Edwin|Caldwell|Active||
Mark|Cannon|Active|Chicago|Marketing Facilitator
Lynsey|Card|Inactive|Franklin|Marketing Facilitator
Marcus|Cardwell|Active|Chicago|VP
Gary|Cerny|Inactive|Chicago|Site Supervisor
Ralph|Charles|Inactive||
Amy|Clark|Active||
Matt|Clarke|Active|St. Louis|VP
Marissa|Clemmons|Active||
George|Clooney|Active||
Jonathan|Cole|Inactive|Chicago|Site Supervisor
David|Collings|Active|Chicago|Client Service Representative
Clint|Connelly|Inactive||Marketing Facilitator
Andrew|Davidson|Inactive||
Samantha|Davis|Active||
Michael|Dobson|Inactive||
Stephanie|Dornes|Inactive||Site Supervisor
Laurie|Durfey|Active|Chicago|Site Supervisor
Kurt|Durkee|Active|Chicago|Developer
Edward|Dylan|Inactive|Chicago|Site Supervisor
Gavan|Errold|Active|St. Louis|Marketing Facilitator
Coy|Escobedo|Active|Chicago|Developer
Emily|Ethridge|Active|Chicago|Office Administration
Bradly|Eyre|Active|St. Louis|Client Service Representative
Jasmine|Farrer|Active|Chicago|Marketing Facilitator
Robert|Fordham|Active|Corporate Office|Office Administration
Fredré|Francisco|Inactive||
Jaclyn|Francom|Active|Chicago|Account Representative
Jonathan|Goodrich|Inactive|Chicago|VP
Jessica|Hansen|Active|Chicago|Account Representative
Veronica|Hanson|Inactive||
Devin|Hartwell|Active|Chicago|Account Representative
Michael|Harvey|Active|St. Louis|Account Representative
Luke|Haslem|Inactive|Chicago|Account Representative
Jeff|Hawkes|Active|St. Louis|Account Representative
Jimi|Hendrix|Inactive||
Avalon|Higginbotham|Inactive|St. Louis|Account Representative
Katherine|Hill|Active||
Sophie|Hollister|Inactive|St. Louis|Account Representative
Chris|Hunter|Active|Chicago|Client Service Representative
Maryanne|Jacobson|Active||
Perry|Jasper|Inactive||
James|John|Active||
Nicholas|Johns|Inactive||
Bob|Johnson|Inactive||
David|Johnson|Active||
Simon|Johnson|Active||
Corinne|Kent|Inactive||
Shelly|Konold|Active|Chicago|Client Service Representative
Archie|Krammer|Active||
Betty|Larsen|Active||
John|LeSueur|Active||
Lydia|Learner|Inactive||
Mason|Marsh|Active||
Kelly|Mayberry|Active||
Jacob|Miller|Inactive|Chicago|Site Supervisor
Jennifer|Miller|Inactive|Chicago|Site Supervisor
Larry|Millner|Active||
Erin|Monroe|Inactive|Corporate Office|VP
Allison|Muaina|Inactive|St. Louis|Payroll Administrator
Joshua|Ninow|Active|Chicago|Account Representative
Samuel|Nunez|Inactive|St. Louis|Account Representative
William|Nye|Active|St. Louis|Account Representative
Gabe|Ogden|Active|Chicago|Account Representative
Terrie|Orullian|Active|Chicago|Account Representative
Chris|Parker|Inactive||
Brooke|Petersen|Active||
Lacey|Peterson|Active||
Nathan|Pyper|Active|Chicago|Account Representative
David|Quallman|Inactive||Development Supervisor
Brian|Quick|Active|Chicago|Client Service Representative
Rachel|Ray|Active||
Jordan|Reeves|Active|St. Louis|Account Representative
Matt|Reid|Inactive||
Melvin|Reynolds|Active||
Kodie|Romrell|Active|St. Louis|Client Service Representative
Melanie|Sanderson|Active|St. Louis|Marketing Facilitator
Betsy|Schow|Active|Chicago|Office Administration
Andy|Shaw|Active|Chicago|Office Administration
Peter|Showalter|Inactive||
Andreas|Silva|Active|St. Louis|Office Administration
William|Smith|Inactive||Account Representative
Kevin|Smith|Inactive||
Kevin|Smith|Inactive|Chicago|Site Supervisor
Steven|Smith|Inactive|Franklin|Office Administration
Kristi|Smith|Active||
Sarah|Smith|Active||
Kay|Stoddard|Active||
Hayley|Thayn|Active|St. Louis|Office Administration
George|Thomp|Inactive|St. Louis|
Jayne|Thompson|Inactive||Marketing Facilitator
Jeff|Thompson|Inactive||
Silvia|Turner|Inactive||
Kirk|Wensink|Inactive||
Kirk|Wensink|Inactive|Chicago|Site Supervisor
Dylan|Wright|Active|St. Louis|Development Supervisor
Brian|Yack|Inactive||Client Service Representative
Tammy|Zabcdef|Inactive||
Eric|Zincke|Active|Chicago|Payroll Administrator
