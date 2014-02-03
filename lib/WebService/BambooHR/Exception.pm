package WebService::BambooHR::Exception;

use 5.006;
use Moo;
with 'Throwable';

use overload
    q{""}    => 'as_string',
    fallback => 1;

has message     => (is => 'ro');
has method      => (is => 'ro');
has code        => (is => 'ro');
has reason      => (is => 'ro');
has filename    => (is => 'ro');
has line_number => (is => 'ro');

sub as_string
{
    my $self = shift;
    return $self->method.'(): '
           .$self->message.' ('.$self->code.' '.$self->reason.') '
           .'file '.$self->filename.' on line '.$self->line_number."\n";
           ;
}

1;
