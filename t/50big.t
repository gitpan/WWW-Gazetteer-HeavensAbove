use strict;
use Test::More tests => 31;
use WWW::Gazetteer::HeavensAbove;

my @cities;
my $g = WWW::Gazetteer::HeavensAbove->new;

diag("Be patient... this test suite is very long (61 web requests)");

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
