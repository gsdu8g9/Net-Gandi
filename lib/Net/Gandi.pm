package Net::Gandi;

# ABSTRACT: A Perl interface for gandi api

use Moose;
use MooseX::Params::Validate;
use namespace::autoclean;

use Net::Gandi::Client;
use Net::Gandi::Types Client => { -as => 'Client_T' };

use Net::Gandi::Hosting;
use Net::Gandi::Domain;
use Net::Gandi::Operation;

use 5.010;

has client => (
    is       => 'rw',
    isa      => Client_T,
    required => 1,
);

sub BUILDARGS {
    my ( $class, %args ) = @_;

    my $transport = 'XMLRPC';
    my $trait     = "Net::Gandi::Transport::" . $transport;

    my $client = Net::Gandi::Client->with_traits($trait)->new(%args);
    $args{client} = $client;

    \%args;
}

=method hosting

  my $client  = Net::Gandi->new(apikey => 'api_key');
  my $hosting = $client->hosting;

Initialize the hosting environnement, and return an object representing it.

  input: none
  output: A Net::Gandi::Hosting object

=cut

sub hosting {
    my ( $self ) = @_;

    my $hosting = Net::Gandi::Hosting->new( client => $self->client );
    $hosting;
}

=method domain

  my $client  = Net::Gandi->new(apikey => 'api_key');
  my $cdomain = $client->domain;

Initialize the domain environnement, and return an object representing it.

  input: id (Str) : optional, domain name
  output: Net::Gandi::Domain

=cut

sub domain {
    my ( $self, $id ) = validated_list(
        \@_,
        domain => { isa => 'Str', optional => 1 }
    );

    my %args  = ( client => $self->client );
    $args{domain} = $id if $id;

    my $domain = Net::Gandi::Domain->new(%args);

    return $domain;
}

=method operation

  my $client  = Net::Gandi->new(apikey => 'api_key');
  my $operation = $client->operation;

Initialize the operation environnement, and return an object representing it.

  input: id (Int) : optional, id of operation
  output: A Net::Gandi::Hosting::Operation object

=cut

sub operation {
    my ( $self, $id ) = validated_list(
        \@_,
        id => { isa => 'Int', optional => 1 }
    );

    my %args  = ( client => $self->client );
    $args{id} = $id if $id;

    my $operation = Net::Gandi::Operation->new(%args);

    return $operation;
}

no Moose;
__PACKAGE__->meta->make_immutable;

1;

=encoding UTF-8

=head1 SYNOPSIS

    use Net::Gandi;

    my $client  = Net::Gandi->new( apikey => 'myapikey', date_to_datetime => 1 );
    my $hosting = $client->hosting;
    my $vm      = $hosting->vm( id => 42 );
    my $vm_info = $vm->info;

=head1 DESCRIPTION

This module provides a Perl interface to the Gandi API. See L<http://rpc.gandi.net>

=head1 CONTRIBUTING

This module is developed on Github at:

L<http://github.com/hobbestigrou/Net-Gandi>

Feel free to fork the repo and submit pull requests

=head1 ACKNOWLEDGEMENTS

Gandi for this api.

=head1 BUGS

Please report any bugs or feature requests in github.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc Net::Gandi

=head1 SEE ALSO

L<Moose>
L<XMLRPC::Lite>
L<http://rpc.gandi.net>
