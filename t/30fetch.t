use strict;
use Test::More tests => 6;
use WWW::Gazetteer::HeavensAbove;

my $g = WWW::Gazetteer::HeavensAbove->new;
my @cities;

# simple query
@cities = $g->fetch( 'GB', 'London' );

ok( @cities == 1, 'Number of cities named London in GB' );
is_deeply(
    $cities[0],
    {
        'latitude'   => '51.517',
        'regionname' => 'County',
        'region'     => 'Greater London',
        'alias'      => '',
        'elevation'  => '18 m',
        'longitude'  => '-0.105',
        'name'       => 'London'
    },
    "London, GB"
);

# non-existant code
eval {
    $g->fetch( 'ZZ', 'foo' );
};
like( $@, qr/No HA code for ZZ ISO code/, 'Invalid code' );

# more cities
@cities = $g->fetch( 'FR', 'Paris' );

ok( @cities == 2, 'Number of cities named Paris' );

is_deeply( $cities[0], 
          {
            'latitude' => '45.633',
            'regionname' => 'Region',
            'region' => 'Rhône-Alpes',
            'alias' => 'Les Paris',
            'elevation' => '508 m',
            'longitude' => '5.733',
            'name' => 'Paris'
          },
          'Les Paris');

is_deeply( $cities[1],
          {
            'latitude' => '48.867',
            'regionname' => 'Region',
            'region' => 'Île-de-France',
            'alias' => '',
            'elevation' => '34 m',
            'longitude' => '2.333',
            'name' => 'Paris'
          },
          'Paris');

