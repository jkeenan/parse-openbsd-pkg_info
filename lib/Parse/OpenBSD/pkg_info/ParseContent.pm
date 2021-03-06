package Parse::OpenBSD::pkg_info::ParseContent;
use 5.14.0;
use warnings;
our $VERSION = '0.01';
use parent qw( Exporter );
our @EXPORT_OK= qw( L_parse );
use Carp;
use Data::Dump qw( dd pp );

sub L_parse {
    my $results = shift;
    my %found = ();
    for my $p (@{$results}) {
        my @lines = split(/\n+/, $p);
        if ($lines[0] =~ m/^Information for inst:((.*?)-([^\-]+))$/) {
            my ($versioned_package, $package, $version) = ($1,$2,$3);
            $found{$package}{installed} = 1;
            $found{$package}{versioned_package} = $versioned_package;
            $found{$package}{version} = $version;
            $found{$package}{files} = _parse_result_for_files(@lines);
        }
        elsif ($lines[0] =~ m{^
            Information\sfor\s
            (
                (?:http.*)/(
                    (
                        .*?
                    )               # package
                    -
                    (
                        [^\-]+
                    )               # version
                )                   # versioned_package
                \.tgz
            )                       # url
        $}x) {
            my ($url, $versioned_package, $package, $version) = ($1,$2,$3,$4);
            $found{$package}{installed} = 0;
            $found{$package}{url} = $url;
            $found{$package}{versioned_package} = $versioned_package;
            $found{$package}{version} = $version;
            $found{$package}{files} = _parse_result_for_files(@lines);
        }
    }
    return \%found;
}

sub _parse_result_for_files {
    my @lines = @_;
    my @files;
    for my $l (@lines[1..$#lines]) {
        next if $l =~ m/^(\s*|Files:)$/;
        push @files, $l;
    }
    return \@files;
}

1;

