package Net::Gandi::Types;

# ABSTRACT: Net::Gandi types

use MooseX::Types::Moose qw/Str ArrayRef HashRef/;
use MooseX::Types -declare => [qw(Client Apikey)];

class_type Client, { class => 'Net::Gandi::Client' };

subtype Apikey,
    as Str,
    where   { length($_) == 24 },
    message { "Apikey must be larger 24" };

1;
