# -*- perl -*-

# t/001-load.t - check module loading and create testing directory

use Test::More tests =>  4;
use Parse::OpenBSD::pkg_info qw( L );
#use Data::Dump qw ( dd pp );

my (@requests, $results);
my (@valid, @phony);

@valid = qw( p5-Algorithm-Diff p5-Cairo );
@phony = qw( p5-My-Foo-Bar );
@requests = (@valid, @phony);

$results = L(@requests);
#pp($results);
is(keys %{$results}, 3, "Results reported for three requests");
for my $req (@valid) {
    ok(defined $results->{$req}, "'$req' found, as expected");
}
ok(! defined $results->{$phony[0]}, "'$phony[0]' not found, as expected");


