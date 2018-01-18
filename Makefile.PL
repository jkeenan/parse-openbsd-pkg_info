use strict;
use warnings;
use ExtUtils::MakeMaker;
use Devel::CheckOS qw(os_is);
die "Parse::OpenBSD::pkg_info only runs on OpenBSD"
    unless os_is('OpenBSD');

my $mm_ver = ExtUtils::MakeMaker->VERSION;
$mm_ver =~ s/_//g;

my %configure_req = (   # 6.52++
    'Devel::CheckOS' => 0,
    'ExtUtils::MakeMaker' => 0,
);
my %build_req = (       # 6.5503++
);
my %test_req = (        # 6.64++
    'Test::RequiresInternet' => 0,
    'Test::Simple' => 0.44,
);

my %Makefile_args = (
    NAME         => 'Parse::OpenBSD::pkg_info',
    VERSION_FROM => 'lib/Parse/OpenBSD/pkg_info.pm', # finds \$VERSION
    AUTHOR       => 'James E Keenan (jkeenan@cpan.org)',
    ABSTRACT     => 'Access pkg_info output from Perl',
    MIN_PERL_VERSION => '5.14.0',
    ($mm_ver < 6.31 ? () : (LICENSE => 'perl_5')),
    ($mm_ver < 6.46 ? () : (META_MERGE => {
        'meta-spec' => { version => 2 },
        dynamic_config => 1,
        resources => {
            homepage => 'http://thenceforward.net/perl/modules/Parse-OpenBSD-pkg_info/',
            repository => {
                url => 'https://github.com/jkeenan/parse-openbsd-pkg_info.git',
                web => 'https://github.com/jkeenan/parse-openbsd-pkg_info',
                type => 'git',
            },
            bugtracker => {
                web => 'https://rt.cpan.org/Public/Dist/Display.html?Name=Parse-OpenBSD-pkg_info',
            },
        },
    })),
);
my %prereqs = ();
if ($mm_ver < 6.52) {
    $prereqs{$_} = $configure_req{$_}   for keys %configure_req;
}
else {
    $Makefile_args{CONFIGURE_REQUIRES}  = \%configure_req;
}
if ($mm_ver < 6.55503)  {
    $prereqs{$_} = $build_req{$_}       for keys %build_req;
    $prereqs{$_} = $test_req{$_}        for keys %test_req;
}
else {
    my %inter = ();
    $inter{$_} = $build_req{$_}         for keys %build_req;
    if ($mm_ver < 6.64) {
        $inter{$_} = $test_req{$_}      for keys %test_req;
    }
    else {
        $Makefile_args{TEST_REQUIRES}   = \%test_req;
    }
    $Makefile_args{BUILD_REQUIRES}      = \%inter;
}
$Makefile_args{PREREQ_PM} = \%prereqs if scalar keys %prereqs;

WriteMakefile( %Makefile_args );
