use strict;
use Test::More tests => 10;
use WWW::Gazetteer::HeavensAbove;

my $g = WWW::Gazetteer::HeavensAbove->new;
my @cities;

# simple query
@cities = $g->query( 'UK', 'London' );

ok( @cities == 1, 'Number of cities named London in UK' );
my $london = {
    'latitude'   => '51.517',
    'regionname' => 'county',
    'region'     => 'Greater London',
    'alias'      => '',
    'elevation'  => '18',
    'longitude'  => '-0.105',
    'name'       => 'London'
};

is_deeply( $cities[0], $london, "London, UK" );

# case doesn't matter
@cities = $g->query( 'uk', 'London' );
ok( @cities == 1, 'Number of cities named london in uk' );
is_deeply( $cities[0], $london, "london, uk" );

# complicated queries
@cities = $g->query( 'AF', 'Mazar*i*f' );
my @tests = (
    {
        'latitude'   => '36.700',
        'regionname' => 'region',
        'region'     => 'Balkh',
        'alias'      => '',
        'elevation'  => '363',
        'longitude'  => '67.100',
        'name'       => 'Mazar-e Sharif'
    },
    {
        'latitude'   => '36.700',
        'regionname' => 'region',
        'region'     => 'Balkh',
        'alias'      => 'Mazar-e Sharif',
        'elevation'  => '363',
        'longitude'  => '67.100',
        'name'       => 'Mazar-i-Sharif'
    },
    {
        'latitude'   => '36.700',
        'regionname' => 'region',
        'region'     => 'Balkh',
        'alias'      => 'Mazar-e Sharif',
        'elevation'  => '363',
        'longitude'  => '67.100',
        'name'       => 'Mazare Srif'
    }
);

is_deeply( $cities[$_], $tests[$_], $tests[$_]{name} ) for 0 .. 2;

# a HA country code that doesn't exist
eval { @cities = $g->query( 'RU', 'Brest' ); };
like( $@, qr/No HA code RU/, 'Invalid code' );

# a country without regions
@cities = $g->query( 'FP' => 'Fitii' );
ok( @cities == 1, "Fitii, French Polynesia" );
is_deeply(
    $cities[0],
    {
        latitude   => -16.733,
        longitude  => -151.033,
        elevation  => 77,
        alias      => '',
        region     => '',
        regionname => '',
        name       => 'Fitii'
    },
    "French Polynesia has no region"
);
