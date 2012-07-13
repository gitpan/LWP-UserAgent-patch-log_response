package LWP::UserAgent::patch::log_response;

use 5.010001;
use strict;
no warnings;

use parent qw(Module::Patch);

our $VERSION = '0.01'; # VERSION

our %config;

my $p_simple_request = sub {
    require Log::Any;

    my $orig = shift;
    my $resp = $orig->(@_);

    my $log = Log::Any->get_logger;
    $log->tracef("HTTP response header:\n%s",
                 $resp->status_line . "\r\n" . $resp->headers->as_string);
    $resp;
};

sub patch_data {
    return {
        config => {
        },
        versions => {
            '6.04' => {
                subs => {
                    simple_request => $p_simple_request,
                },
            },
        },
    };
}

1;
# ABSTRACT: Patch module for LWP::UserAgent


__END__
=pod

=head1 NAME

LWP::UserAgent::patch::log_response - Patch module for LWP::UserAgent

=head1 VERSION

version 0.01

=head1 SYNOPSIS

 use LWP::UserAgent::patch::log_response;

 # now all your LWP HTTP responses are logged

Sample script and output:

 % TRACE=1 perl -MLog::Any::App -MLWP::UserAgent::patch::log_response \
   -MLWP::Simple -e'getprint "http://www.google.com/"'

=head1 DESCRIPTION

This module patches LWP::UserAgent (which is used by LWP::Simple,
WWW::Mechanize, among others) so that HTTP responses are logged using
L<Log::Any>.

=head1 FAQ

=head2 Why not subclass?

By patching, you do not need to replace all the client code which uses LWP (or
WWW::Mechanize, etc).

=head1 SEE ALSO

Use L<Net::HTTP::Methods::patch::log_request> to log raw HTTP requests being
sent to servers.

=head1 AUTHOR

Steven Haryanto <stevenharyanto@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2012 by Steven Haryanto.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut

