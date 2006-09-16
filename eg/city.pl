#!/usr/bin/perl -w

use strict;
use WWW::Gazetteer::HeavensAbove;
$|++;

my $g = WWW::Gazetteer::HeavensAbove->new();

#
# usage: city.pl <glob> <iso>
#
# for example, run: city.pl 'l*' fr
# to get all French cities starting with l*
#
my $city = shift;
my $code = uc shift;
my $cb   = sub {
    local $, = "\t";
    local $\ = $/;
    my @fields = qw(iso name alias region latitude longitude elevation);
    splice @fields, 4, 0, "county" if $code eq 'US';
    print @$_{@fields} for @_;
};

print "# iso\tname\talias\tregion\t"
  . ( $code eq 'US' ? "county\t" : "" )
  . "latitude\tlongitude\televation\n";

$g->find( $city, $code, $cb );

