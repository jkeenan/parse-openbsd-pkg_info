# -*- perl -*-

# t/001-load.t - check module loading and create testing directory

use Test::More tests =>  3;

BEGIN { use_ok( 'Parse::OpenBSD::pkg_info' ); }

my $self;

$self = Parse::OpenBSD::pkg_info->new ();
isa_ok ($self, 'Parse::OpenBSD::pkg_info');

{
    local $@;
    eval { $self = Parse::OpenBSD::pkg_info->new([]); };
    like $@, qr/new\(\): Incorrect argument; must supply hash ref/,
        "new(): Got expected error message: wrong argument type";
}

