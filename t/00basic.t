use Test;
BEGIN { plan tests => 1 }
END   { ok($loaded) }
use WWW::Gazetteer::HeavensAbove;
$loaded++;
