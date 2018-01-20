package Parse::OpenBSD::pkg_info;
use 5.14.0;
use warnings;
our $VERSION = '0.01';
use parent qw( Exporter );
our @EXPORT_OK= qw( L );
use Carp;
use Data::Dump qw( dd pp );
use Parse::OpenBSD::pkg_info::ParseContent qw( L_parse );

sub L {
    my @pkgs = @_;
    my $pkg_info_L_output = `pkg_info -L @pkgs`;
    my $results = [ split(/\n{3,}/, $pkg_info_L_output) ];
    my $found = L_parse($results);
    my %requests = map { $_ => 1 } @pkgs;
    for my $req (keys %requests) {
        $found->{$req} = undef unless exists $found->{$req};
    }
    return $found;
}

1;

