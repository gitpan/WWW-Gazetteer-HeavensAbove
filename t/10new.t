use strict;
use Test::More tests => 1;
use WWW::Gazetteer::HeavensAbove;

my $g = WWW::Gazetteer::HeavensAbove->new;

isa_ok( $g, "WWW::Gazetteer::HeavensAbove" );
