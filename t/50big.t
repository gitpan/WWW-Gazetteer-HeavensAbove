use strict;
use Test::More tests => 35;
use WWW::Gazetteer::HeavensAbove;

my @cities;
my $g = WWW::Gazetteer::HeavensAbove->new;

diag("Be patient... this test suite is very long (113 web requests)");

# star at the beginning (9 web requests)
@cities = $g->find( '*s', 'UY' );
ok( @cities == 231, "231 cities named '*s' in Uruguay" )
  or diag( "Fetched " . @cities . " cities" );

# star in the middle (16 web requests)
my @counts = ( 103, 117, 17, 45, 0, 4, 5, 106, 9, 5, 6, 4, 0, 0, 1, 2 );
my $cb = sub {
    my $c = shift @counts;

    # check each request is okay
    ok( @_ == $c, "$c town(s) found" ) or diag( "got " . @_ . "/$c" );
    push @cities, @_;
};
@cities = ();
$g->find( 'A*A', 'CO', $cb );
ok( @cities == 424, "424 cities named 'A*A' in Colombia" )
  or diag( "Fetched " . @cities . " cities" );

# star at the end (24 web requests)
@cities = $g->find( 'Agua *', 'MX' );
ok( @cities == 444, "444 cities named 'Agua *' in Mexico" )
  or diag( "Fetched " . @cities . " cities" );

# test for the biggest possible request on a country (12 web requests)
@counts = ( 189, 57, 0, 11, 2, 78, 6, 23, 0, 0, 0, 0 );
$g->find( '*', 'PF', $cb );

# test the buenavista*, MX case: 200+ cities with the same name
@counts = ( 200, 14 );
$g->find( 'buenavista*', 'MX', $cb );

# Make sure the search string stays ok
@cities = $g->find( 'u*', 'PE' );
ok( @cities == 439, "439 cities named 'U*' in Peru" )
  or diag( "Fetched " . @cities . " cities" );

# check the 
@cities = $g->find( 'San Antonio*', 'MX' );
ok( @cities == 419, "419 cities named 'San Antonio*' in Mexico" )
  or diag( "Fetched " . @cities . " cities" );
