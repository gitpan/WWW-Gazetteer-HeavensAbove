#!/usr/bin/perl -w

use strict;
use WWW::Gazetteer::HeavensAbove;

my $g = WWW::Gazetteer::HeavensAbove->new;

my $cb = sub {
    for (@_) {
        print join (
            "\t", @$_{
            qw( name alias region latitude longitude elevation )
            }
          ),
          "\n";
    }
};

print "# name\talias\tregion\tlatitude\tlongitude\televation\n";
$g->fetch( shift, shift, $cb );

