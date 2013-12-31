use strict;
use warnings;
use t::Util;
use Test::More;
use WWW::Gazetteer::HeavensAbove;

plan 'skip_all' => 'Internet connection required to run this test'
   if ! web_ok();

plan tests => 9;

my $g = WWW::Gazetteer::HeavensAbove->new( retry => 10 );
my @cities;

# simple query
@cities = $g->find( 'London', 'GB' );

ok( @cities == 1, 'Number of cities named London in GB' );
is_deeply(
    $cities[0],
    {
        iso        => 'GB',
        latitude   => '51.517',
        regionname => 'county',
        region     => 'Greater London',
        elevation  => '18',
        longitude  => '-0.105',
        name       => 'London'
    },
    "London, GB"
);

# non-existant code
eval { $g->find( 'foo', 'ZZ' ); };
like( $@, qr/No HA code for ZZ ISO code/, 'Invalid code' );

# more cities
@cities = $g->find( 'Paris', 'FR' );

ok( @cities == 2, 'Number of cities named Paris' );

is_deeply(
    $cities[0],
    {
        iso        => 'FR',
        latitude   => '45.633',
        regionname => 'region',
        region     => 'Rhône-Alpes',
        elevation  => '508',
        longitude  => '5.733',
        name       => 'Paris'
    },
    'Les Paris'
);

is_deeply(
    $cities[1],
    {
        iso        => 'FR',
        latitude   => '48.867',
        regionname => 'region',
        region     => 'Île-de-France',
        elevation  => '34',
        longitude  => '2.333',
        name       => 'Paris'
    },
    'Paris'
);

# the US are special
@cities = $g->find( 'New york', 'US' );
ok( @cities == 7, 'New York, US' );

is_deeply(
    $cities[6],
    {
        iso        => 'US',
        latitude   => '39.685',
        regionname => 'state',
        region     => 'Missouri',
        county     => 'Caldwell',
        elevation  => '244',
        longitude  => '-93.927',
        name       => 'New York'
    },
    'New York, Missouri'
);

# find returns an arrayref in scalar context
my $cities = $g->find( 'Paris', 'FR' );
ok( $cities->[1]{longitude} == 2.333, "find() in scalar context" );
