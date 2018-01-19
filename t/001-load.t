# t/001-load.t - check module loading and create testing directory
use strict;
use warnings;

use Test::More;
use Carp;
use Cwd;
use File::Spec;
use Parse::OpenBSD::pkg_info qw( L );
use Test::RequiresInternet ('ftp4.usa.openbsd.org' => 80);

my (@requests, $results);
my (@valid, @phony);

@valid = qw( p5-Algorithm-Diff p5-Cairo );
@phony = qw( p5-My-Foo-Bar );
@requests = (@valid, @phony);

SKIP: {
    skip "Set PERL_ALLOW_NETWORK_TESTING to conduct live tests", 4
        unless $ENV{PERL_ALLOW_NETWORK_TESTING};

    $results = L(@requests);
    is(keys %{$results}, 3, "Results reported for three requests");
    for my $req (@valid) {
        ok(defined $results->{$req}->{installed}, "'$req' found, as expected");
    }
    ok(! defined $results->{$phony[0]}, "'$phony[0]' not found, as expected");
}

{
    my $datafile = 'one-installed-one-not-pkg.txt';
    my $cwd = cwd();
    my $file = File::Spec->catfile($cwd, 't', 'data', $datafile);
    ok(-f $file, "Located '$file' for testing");
    my $filestr;
    {
        local $/;
        open my $IN, '<', $file or croak "Unable to open $file for reading";
        $filestr = <$IN>;
        close $IN or croak "Unable to close $file after reading";
    }
    my $results = [ split(/\n{3,}/, $filestr) ];
    my $found = Parse::OpenBSD::pkg_info::_parse($results);
    for my $req (@valid) {
        ok(defined $found->{$req}->{installed}, "'$req' found, as expected");
    }
}

done_testing;


