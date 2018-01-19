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
my ($datafile, $found);

{ #1
    @valid = qw( p5-Algorithm-Diff p5-Cairo );
    @phony = qw( p5-My-Foo-Bar );
    @requests = (@valid, @phony);

    SKIP: {
        skip "Set PERL_ALLOW_NETWORK_TESTING to conduct live tests", 4
            unless $ENV{PERL_ALLOW_NETWORK_TESTING};

        $results = L(@requests);
        is(keys %{$results}, 3, "Results reported for 3 requests");
        for my $req (@valid) {
            ok(defined $results->{$req}->{installed},
                "$req found, as expected");
        }
        ok(! defined $results->{$phony[0]},
            "$phony[0] not found, as expected");
    }

    {
        $datafile = 'one-installed-one-not-pkg.txt';
        $found = parse_sample_file($datafile);
        for my $req (@valid) {
            ok(defined $found->{$req}->{installed},
                "$req found, as expected");
        }
        ok($found->{$valid[0]}->{installed},
            "In sample file, $valid[0] is installed, as expected");
        is(scalar @{$found->{$valid[0]}->{files}}, 8,
            "$valid[0] port has 8 files, as expected");
        ok(! $found->{$valid[1]}->{installed},
            "In sample file, $valid[1] is available but not installed, as expected");
        is(scalar @{$found->{$valid[1]}->{files}}, 9,
            "$valid[1] port has 9 files, as expected");
    }
}

{ #2
    @valid = qw( p5-Algorithm-Diff );
    @phony = qw( );
    @requests = (@valid, @phony);

    SKIP: {
        skip "Set PERL_ALLOW_NETWORK_TESTING to conduct live tests", 2
            unless $ENV{PERL_ALLOW_NETWORK_TESTING};

        $results = L(@requests);
        is(keys %{$results}, 1, "Results reported for 1 request");
        for my $req (@valid) {
            ok(defined $results->{$req}->{installed},
                "$req found, as expected");
        }
    }

    {
        $datafile = 'one-installed-pkg.txt';
        $found = parse_sample_file($datafile);
        for my $req (@valid) {
            ok(defined $found->{$req}->{installed},
                "$req found, as expected");
        }
        ok($found->{$valid[0]}->{installed},
            "In sample file, $valid[0] is installed, as expected");
        is(scalar @{$found->{$valid[0]}->{files}}, 8,
            "$valid[0] port has 8 files, as expected");
    }
}

{ # 3
    @valid = qw( p5-Path-Tiny p5-Devel-CheckOS );
    @phony = qw( p5-My-Foo-Bar );
    @requests = (@valid, @phony);

    SKIP: {
        skip "Set PERL_ALLOW_NETWORK_TESTING to conduct live tests", 4
            unless $ENV{PERL_ALLOW_NETWORK_TESTING};

        $results = L(@requests);
        is(keys %{$results}, 3, "Results reported for 3 requests");
        for my $req (@valid) {
            ok(defined $results->{$req}->{installed},
                "$req found, as expected");
        }
        ok(! defined $results->{$phony[0]},
            "$phony[0] not found, as expected");
    }

    {

        $datafile = 'two-installed-one-nonexistent-pkg.txt';
        $found = parse_sample_file($datafile);
        for my $req (@valid) {
            ok(defined $found->{$req}->{installed},
                "$req found, as expected");
        }
        ok($found->{$valid[0]}->{installed},
            "In sample file, $valid[0] is installed, as expected");
        is(scalar @{$found->{$valid[0]}->{files}}, 2,
            "$valid[0] port has 2 files, as expected");
        ok($found->{$valid[1]}->{installed},
            "In sample file, $valid[1] is installed, as expected");
        is(scalar @{$found->{$valid[1]}->{files}}, 155,
            "$valid[1] port has 155 files, as expected");
    }
}

{ # 4
    @valid = qw( p5-IO-Capture p5-IO-CaptureOutput );
    @phony = qw( );
    @requests = (@valid, @phony);

    SKIP: {
        skip "Set PERL_ALLOW_NETWORK_TESTING to conduct live tests", 2
            unless $ENV{PERL_ALLOW_NETWORK_TESTING};

        $results = L(@requests);
        is(keys %{$results}, 2, "Results reported for 2 requests");
        for my $req (@valid) {
            ok(defined $results->{$req}->{installed},
                "$req found, as expected");
        }
    }

    {

        $datafile = 'two-installed-pkg.txt';
        $found = parse_sample_file($datafile);
        for my $req (@valid) {
            ok(defined $found->{$req}->{installed},
                "$req found, as expected");
        }
        ok($found->{$valid[0]}->{installed},
            "In sample file, $valid[0] is installed, as expected");
        is(scalar @{$found->{$valid[0]}->{files}}, 10,
            "$valid[0] port has 10 files, as expected");
        ok($found->{$valid[1]}->{installed},
            "In sample file, $valid[1] is installed, as expected");
        is(scalar @{$found->{$valid[1]}->{files}}, 2,
            "$valid[1] port has 2 files, as expected");
    }
}

{ # 5
    @valid = qw( p5-Cairo p5-Class-Date );
    @phony = qw( );
    @requests = (@valid, @phony);

    SKIP: {
        skip "Set PERL_ALLOW_NETWORK_TESTING to conduct live tests", 2
            unless $ENV{PERL_ALLOW_NETWORK_TESTING};

        $results = L(@requests);
        is(keys %{$results}, 2, "Results reported for 2 requests");
        for my $req (@valid) {
            ok(defined $results->{$req}->{installed},
                "$req found, as expected");
        }
    }

    {

        $datafile = 'two-not-installed-pkg.txt';
        $found = parse_sample_file($datafile);
        for my $req (@valid) {
            ok(defined $found->{$req}->{installed},
                "$req found, as expected");
        }
        ok(! $found->{$valid[0]}->{installed},
            "In sample file, $valid[0] is available but not installed, as expected");
        is(scalar @{$found->{$valid[0]}->{files}}, 9,
            "$valid[0] port has 9 files, as expected");
        ok(! $found->{$valid[1]}->{installed},
            "In sample file, $valid[1] is available but not installed, as expected");
        is(scalar @{$found->{$valid[1]}->{files}}, 6,
            "$valid[1] port has 6 files, as expected");
    }
}

sub parse_sample_file {
    my $datafile = shift;
    my ($cwd, $file, $filestr, $results, $found);
    $cwd = cwd();
    $file = File::Spec->catfile($cwd, 't', 'data', $datafile);
    ok(-f $file, "Located $file for testing");
    $filestr = slurp_in_file($file);
    $results = [ split(/\n{3,}/, $filestr) ];
    $found = Parse::OpenBSD::pkg_info::_parse($results);
    return $found;
}

sub slurp_in_file {
    my $file = shift;
    local $/;
    open my $IN, '<', $file or croak "Unable to open $file for reading";
    my $filestr = <$IN>;
    close $IN or croak "Unable to close $file after reading";
    return $filestr;
}

done_testing;


