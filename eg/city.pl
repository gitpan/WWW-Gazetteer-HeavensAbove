#!/usr/bin/perl -w

use strict;
use WWW::Gazetteer::HeavensAbove;

my $g = WWW::Gazetteer::HeavensAbove->new;

my $code = uc shift;
my $cb = sub {
    local $, = "\t";
    local $\ = $/;
    my @fields = qw(name alias region latitude longitude elevation);
    splice @fields, 3, 0, "county" if $code eq 'US';
    print @$_{@fields} for @_;
};

print "# name\talias\tregion\t"
  . ( $code eq 'US' ? "county\t" : "" )
  . "latitude\tlongitude\televation\n";

$g->fetch( $code, shift, $cb );

