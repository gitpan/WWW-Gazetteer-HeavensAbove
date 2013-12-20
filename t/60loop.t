use strict;
use warnings;
use t::Util;
use Test::More;
use WWW::Gazetteer::HeavensAbove;

plan 'skip_all' => 'Internet connection required to run this test'
   if ! web_ok();

plan tests => 1;

diag "Warning: this test may be a little long";

# Test script adapted from example by Henry Ayoola
# See CPAN RT ticket #42709
# https://rt.cpan.org/Ticket/Display.html?id=42709

my $atlas = WWW::Gazetteer::HeavensAbove->new;
my %seen;
my $cb = sub {
    for my $city (@_) {
        my $line = join( ':', @$city{qw(name latitude longitude)} );
        $seen{$line}++;

        # in case of duplicate, fail and exit
        if ( $seen{$line} > 1 ) {
            ok( 0, "$line seen twice" );
            diag '(exiting to avoid infinite loop)';
            exit;
        }
    }
};

# will not ok and exit if the same line is returned twice
$atlas->find( 'Gro*', 'DE', $cb );

# did not exit early because of duplicates
ok( 1, 'No infinite loop when looking for "Gro*"' );

