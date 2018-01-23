package Parse::OpenBSD::pkg_info;
use 5.14.0;
use warnings;
our $VERSION = '0.01';
use parent qw( Exporter );
our @EXPORT_OK= qw( L );
use Carp;
use Data::Dump qw( dd pp );
use Parse::OpenBSD::pkg_info::ParseContent qw( L_parse );

=head1 NAME

Parse::OpenBSD::pkg_info - Access F<pkg_info> output from Perl

=head1 SYNOPSIS

    use Parse::OpenBSD::pkg_info qw( L );

    my @packages = qw( p5-Algorithm-Diff p5-Cairo );
    my $results = L(@packages);

=head1 DESCRIPTION

This package exports, on request only, functions which permit the user to
simulate various formulations of the OpenBSD F<pkg_info> utility.  From F<man
1 pkg_info>:  "The B<pkg_info> command is used to dump out information for
packages...."

Each function corresponds to a particular command-line option normally used
with F<pkg_info>.

Currently, only one variant of F<pkg_info> is supported:  F<pkg_info -L
E<lt>some_packageE<gt>>.

=head1 FUNCTIONS

=head2 C<L()>

=over 4

=item * Purpose

Simulate F<pkg_info -L>.  The F<-L> option "[s]hows the files within each
package."

=item * Arguments

    my @packages = qw( p5-Algorithm-Diff p5-Cairo );
    my $results = L(@packages);

=item * Return Value

=item * Comment

=back

=cut

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

=head1 BUGS AND LIMITATIONS

=head1 AUTHOR

James E Keenan.  CPAN ID: JKEENAN.  Email: jkeenan@cpan.org

=head1 LICENSE AND COPYRIGHT

This library is free software.  You can use and distribute it under the same terms as Perl itself.

Copyright 2018 James E Keenan

=cut

1;

