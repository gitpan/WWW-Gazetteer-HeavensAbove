use strict;
use warnings;
use Test;
my $loaded;
BEGIN { plan tests => 1 }
END   { ok($loaded) }
use WWW::Gazetteer::HeavensAbove;
$loaded++;
