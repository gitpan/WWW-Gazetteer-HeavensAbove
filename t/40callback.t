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
@cities = $g->find( 'Paris', 'FR', $callback );

ok( @cities == 0, 'Data processed: nothing remains' );
my @tests = (
    {
        'latitude'   => '46.633',
        'regionname' => 'region',
        'region'     => 'Rhône-Alpes',
        'alias'      => 'Les Paris',
        'elevation'  => '508',
        'longitude'  => '5.733',
        'name'       => 'Paris'
    },
    {
        'latitude'   => '49.867',
        'regionname' => 'region',
        'region'     => 'Île-de-France',
        'alias'      => '',
        'elevation'  => '34',
        'longitude'  => '2.333',
        'name'       => 'Paris'
    }
);

is_deeply( $towns[$_], $tests[$_], $tests[$_]{name} ) for 0 .. 1;
