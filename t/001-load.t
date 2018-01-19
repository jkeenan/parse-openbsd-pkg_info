# -*- perl -*-

# t/001-load.t - check module loading and create testing directory

use Test::More;
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

done_testing;


