#!/usr/bin/perl -w

use strict;
use WWW::Gazetteer::HeavensAbove;

my $g = WWW::Gazetteer::HeavensAbove->new;

my $cb = sub {
    local $, = "\t";
    local $\ = $/;
    print @$_{qw(name alias region latitude longitude elevation)} for @_;
};

print "# name\talias\tregion\tlatitude\tlongitude\televation\n";
$g->fetch( shift, shift, $cb );

