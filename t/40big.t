use strict;
use Test::More tests => 19;
use WWW::Gazetteer::HeavensAbove;

my @cities;
my $g = WWW::Gazetteer::HeavensAbove->new;

diag("Be patient... this test suite is very long (49 web requests)");

# star at the beginning (9 web requests)
@cities = $g->fetch( UY => '*s' );
ok( @cities == 231, "231 cities named '*s' in Uruguay" )
  or diag( "Fetched " . @cities . " cities" );

# star in the middle (16 web requests)
my @counts = ( 103, 117, 17, 45, 0, 4, 5, 106, 9, 5, 6, 4, 0, 0, 1, 2 );
my $cb = sub {
    my $c = shift @counts;

    # check each request is okay
    ok( @_ == $c, "$c town(s) fetched" ) or diag( "got " . @_ . "/$c" );
    push @cities, @_;
};
@cities = ();
$g->fetch( CO => 'A*A', $cb );
ok( @cities == 424, "424 cities named 'A*A' in Colombia" )
  or diag( "Fetched " . @cities . " cities" );

# star at the end (24 web requests)
@cities = $g->fetch( MX => 'Agua *' );
ok( @cities == 444, "444 cities named 'Agua *' in Mexico" )
  or diag( "Fetched " . @cities . " cities" );
