use strict;
use Test::More tests => 3;
use WWW::Gazetteer::HeavensAbove;

my $g = WWW::Gazetteer::HeavensAbove->new;

my @cities;
my @towns;
my $callback = sub {
    for(@_) {
        $_->{latitude} += 1;
        push @towns, $_;
    }
};

# move both Paris!
@cities = $g->fetch( 'FR', 'Paris', $callback );

ok( @cities == 0, 'Data processed: nothing remains' );
my @tests = (
    {
        'latitude'   => '46.633',
        'regionname' => 'Region',
        'region'     => 'Rhône-Alpes',
        'alias'      => 'Les Paris',
        'elevation'  => '508 m',
        'longitude'  => '5.733',
        'name'       => 'Paris'
    },
    {
        'latitude'   => '49.867',
        'regionname' => 'Region',
        'region'     => 'Île-de-France',
        'alias'      => '',
        'elevation'  => '34 m',
        'longitude'  => '2.333',
        'name'       => 'Paris'
    }
);

is_deeply( $towns[$_], $tests[$_], $tests[$_]{name} ) for 0 .. 1;
