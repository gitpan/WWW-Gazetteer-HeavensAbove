use strict;
use warnings;
use t::Util;
use Test::More;
use WWW::Gazetteer::HeavensAbove;

plan 'skip_all' => 'Internet connection required to run this test'
   if ! web_ok();

plan tests => 3;

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
        'iso'        => 'FR',
        'latitude'   => '46.633',
        'regionname' => 'region',
        'region'     => 'Rhône-Alpes',
        'elevation'  => '508',
        'longitude'  => '5.733',
        'name'       => 'Paris'
    },
    {
        'iso'        => 'FR',
        'latitude'   => '49.867',
        'regionname' => 'region',
        'region'     => 'Île-de-France',
        'elevation'  => '34',
        'longitude'  => '2.333',
        'name'       => 'Paris'
    }
);

is_deeply( $towns[$_], $tests[$_], $tests[$_]{name} ) for 0 .. 1;
