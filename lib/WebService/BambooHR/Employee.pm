package WebService::BambooHR::Employee;

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

