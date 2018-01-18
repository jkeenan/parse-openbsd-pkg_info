package Parse::OpenBSD::pkg_info;
use 5.14.0;
use warnings;
our $VERSION = '0.01';
use Carp;


sub new {
    my ($class, $params) = @_;
    $params //= {};
    croak "new(): Incorrect argument; must supply hash ref"
        unless ref($params) eq 'HASH';

    my $self = bless $params, $class;
    return $self;
}

1;

