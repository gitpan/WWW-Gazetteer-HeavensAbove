use strict;
use warnings;
use LWP::UserAgent;

# just load the routine in the main namespace

# check that the web connection is working
sub web_ok {
    my $ua = LWP::UserAgent->new( env_proxy => 1, timeout => 30 );
    my $res = $ua->request(
        HTTP::Request->new( GET => 'http://www.heavens-above.com/' ) );
    return $res->is_success;
}

1;
