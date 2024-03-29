package WWW::Gazetteer::HeavensAbove;
$WWW::Gazetteer::HeavensAbove::VERSION = '0.23';
use strict;
use warnings;
use LWP::UserAgent;
use HTML::Form;
use HTML::TreeBuilder;
use Carp qw( croak );

use vars qw( $VERSION );

# web site data
my $base = 'http://www.heavens-above.com/';

# convert ISO3166 2-letter codes to heavens-above.com's own codes
my %iso = (

    # Computer generated
    'AD' => 'AN',    # ANDORRA
    'AE' => 'AE',    # UNITED ARAB EMIRATES
    'AF' => 'AF',    # AFGHANISTAN
    'AG' => 'AC',    # ANTIGUA AND BARBUDA
    'AI' => 'AV',    # ANGUILLA
    'AL' => 'AL',    # ALBANIA
    'AM' => 'AM',    # ARMENIA
    'AO' => 'AO',    # ANGOLA
    'AQ' => 'AT',    # ANTARCTICA
    'AR' => 'AR',    # ARGENTINA
    'AS' => 'AX',    # AMERICAN SAMOA
    'AT' => 'AU',    # AUSTRIA
    'AU' => 'AS',    # AUSTRALIA
    'AW' => 'AA',    # ARUBA
    'AZ' => 'AJ',    # AZERBAIJAN
    'BB' => 'BB',    # BARBADOS
    'BD' => 'BG',    # BANGLADESH
    'BE' => 'BE',    # BELGIUM
    'BF' => 'UV',    # BURKINA FASO
    'BG' => 'BU',    # BULGARIA
    'BH' => 'BA',    # BAHRAIN
    'BI' => 'BY',    # BURUNDI
    'BJ' => 'BN',    # BENIN
    'BM' => 'BD',    # BERMUDA
    'BO' => 'BL',    # BOLIVIA
    'BR' => 'BR',    # BRAZIL
    'BT' => 'BT',    # BHUTAN
    'BW' => 'BC',    # BOTSWANA
    'BY' => 'BO',    # BELARUS
    'BZ' => 'BH',    # BELIZE
    'CA' => 'CA',    # CANADA
    'CC' => 'CK',    # COCOS (KEELING) ISLANDS
    'CF' => 'CT',    # CENTRAL AFRICAN REPUBLIC
    'CH' => 'SZ',    # SWITZERLAND
    'CI' => 'IV',    # COTE D'IVOIRE
    'CK' => 'CW',    # COOK ISLANDS
    'CL' => 'CI',    # CHILE
    'CM' => 'CM',    # CAMEROON
    'CN' => 'CH',    # CHINA
    'CO' => 'CO',    # COLOMBIA
    'CR' => 'CS',    # COSTA RICA
    'CU' => 'CU',    # CUBA
    'CV' => 'CV',    # CAPE VERDE
    'CX' => 'KT',    # CHRISTMAS ISLAND
    'CY' => 'CY',    # CYPRUS
    'CZ' => 'EZ',    # CZECH REPUBLIC
    'DE' => 'GM',    # GERMANY
    'DJ' => 'DJ',    # DJIBOUTI
    'DK' => 'DA',    # DENMARK
    'DM' => 'DO',    # DOMINICA
    'DO' => 'DR',    # DOMINICAN REPUBLIC
    'DZ' => 'AG',    # ALGERIA
    'EC' => 'EC',    # ECUADOR
    'EE' => 'EN',    # ESTONIA
    'EG' => 'EG',    # EGYPT
    'ER' => 'ER',    # ERITREA
    'ES' => 'SP',    # SPAIN
    'ET' => 'ET',    # ETHIOPIA
    'FI' => 'FI',    # FINLAND
    'FJ' => 'FJ',    # FIJI
    'FO' => 'FO',    # FAROE ISLANDS
    'FR' => 'FR',    # FRANCE
    'GA' => 'GB',    # GABON
    'GB' => 'UK',    # UNITED KINGDOM
    'GD' => 'GJ',    # GRENADA
    'GE' => 'GG',    # GEORGIA
    'GF' => 'FG',    # FRENCH GUIANA
    'GH' => 'GH',    # GHANA
    'GI' => 'GI',    # GIBRALTAR
    'GN' => 'GV',    # GUINEA
    'GQ' => 'EK',    # EQUATORIAL GUINEA
    'GR' => 'GR',    # GREECE
    'GT' => 'GT',    # GUATEMALA
    'GU' => 'GU',    # GUAM
    'GY' => 'GY',    # GUYANA
    'HK' => 'HK',    # HONG KONG
    'HN' => 'HO',    # HONDURAS
    'HT' => 'HA',    # HAITI
    'HU' => 'HU',    # HUNGARY
    'ID' => 'ID',    # INDONESIA
    'IE' => 'EI',    # IRELAND
    'IL' => 'IS',    # ISRAEL
    'IN' => 'IN',    # INDIA
    'IQ' => 'IZ',    # IRAQ
    'IS' => 'IC',    # ICELAND
    'IT' => 'IT',    # ITALY
    'JM' => 'JM',    # JAMAICA
    'JO' => 'JO',    # JORDAN
    'JP' => 'JA',    # JAPAN
    'KE' => 'KE',    # KENYA
    'KG' => 'KG',    # KYRGYZSTAN
    'KH' => 'CB',    # CAMBODIA
    'KI' => 'KR',    # KIRIBATI
    'KN' => 'SC',    # SAINT KITTS AND NEVIS
    'KW' => 'KU',    # KUWAIT
    'KY' => 'CJ',    # CAYMAN ISLANDS
    'KZ' => 'KZ',    # KAZAKHSTAN
    'LB' => 'LE',    # LEBANON
    'LC' => 'ST',    # SAINT LUCIA
    'LI' => 'LS',    # LIECHTENSTEIN
    'LK' => 'CE',    # SRI LANKA
    'LR' => 'LI',    # LIBERIA
    'LS' => 'LT',    # LESOTHO
    'LT' => 'LH',    # LITHUANIA
    'LU' => 'LU',    # LUXEMBOURG
    'LV' => 'LG',    # LATVIA
    'MA' => 'MO',    # MOROCCO
    'MC' => 'MN',    # MONACO
    'MG' => 'MA',    # MADAGASCAR
    'MH' => 'RM',    # MARSHALL ISLANDS
    'MK' => 'MK',    # MACEDONIA, THE FORMER YUGOSLAV REPUBLIC OF
    'ML' => 'ML',    # MALI
    'MN' => 'MG',    # MONGOLIA
    'MR' => 'MR',    # MAURITANIA
    'MT' => 'MT',    # MALTA
    'MU' => 'MP',    # MAURITIUS
    'MV' => 'MV',    # MALDIVES
    'MW' => 'MI',    # MALAWI
    'MX' => 'MX',    # MEXICO
    'MY' => 'MY',    # MALAYSIA
    'MZ' => 'MZ',    # MOZAMBIQUE
    'NA' => 'WA',    # NAMIBIA
    'NE' => 'NG',    # NIGER
    'NF' => 'NF',    # NORFOLK ISLAND
    'NG' => 'NI',    # NIGERIA
    'NI' => 'NU',    # NICARAGUA
    'NL' => 'NL',    # NETHERLANDS
    'NO' => 'NO',    # NORWAY
    'NP' => 'NP',    # NEPAL
    'NZ' => 'NZ',    # NEW ZEALAND
    'OM' => 'MU',    # OMAN
    'PA' => 'PM',    # PANAMA
    'PE' => 'PE',    # PERU
    'PF' => 'FP',    # FRENCH POLYNESIA
    'PG' => 'PP',    # PAPUA NEW GUINEA
    'PH' => 'RP',    # PHILIPPINES
    'PK' => 'PK',    # PAKISTAN
    'PL' => 'PL',    # POLAND
    'PR' => 'PR',    # PUERTO RICO
    'PT' => 'PO',    # PORTUGAL
    'PY' => 'PA',    # PARAGUAY
    'QA' => 'QA',    # QATAR
    'RO' => 'RO',    # ROMANIA
    'SA' => 'SA',    # SAUDI ARABIA
    'SB' => 'BP',    # SOLOMON ISLANDS
    'SD' => 'SU',    # SUDAN
    'SE' => 'SW',    # SWEDEN
    'SG' => 'SN',    # SINGAPORE
    'SI' => 'SI',    # SLOVENIA
    'SL' => 'SL',    # SIERRA LEONE
    'SN' => 'SG',    # SENEGAL
    'SO' => 'SO',    # SOMALIA
    'SR' => 'NS',    # SURINAME
    'SV' => 'ES',    # EL SALVADOR
    'SZ' => 'WZ',    # SWAZILAND
    'TC' => 'TK',    # TURKS AND CAICOS ISLANDS
    'TD' => 'CD',    # CHAD
    'TG' => 'TO',    # TOGO
    'TH' => 'TH',    # THAILAND
    'TM' => 'TX',    # TURKMENISTAN
    'TN' => 'TS',    # TUNISIA
    'TO' => 'TN',    # TONGA
    'TR' => 'TU',    # TURKEY
    'TT' => 'TD',    # TRINIDAD AND TOBAGO
    'TV' => 'TV',    # TUVALU
    'UA' => 'UP',    # UKRAINE
    'UG' => 'UG',    # UGANDA
    'UY' => 'UY',    # URUGUAY
    'UZ' => 'UZ',    # UZBEKISTAN
    'VC' => 'VC',    # SAINT VINCENT AND THE GRENADINES
    'VE' => 'VE',    # VENEZUELA
    'VU' => 'NH',    # VANUATU
    'YE' => 'YM',    # YEMEN
    'ZA' => 'SF',    # SOUTH AFRICA
    'ZM' => 'ZA',    # ZAMBIA
    'ZW' => 'ZI',    # ZIMBABWE

    # hand-made      # ISO / HEAVENS-ABOVE
    'IR' => 'IR',    # IRAN (ISLAMIC REPUBLIC OF) / IRAN
    'BA' => 'BK',    # BOSNIA AND HERZEGOWINA / BOSNIA AND HERZEGOVINA
    'BN' => 'BX',    # BRUNEI DARUSSALAM / BRUNEI
    'BS' => 'BF',    # BAHAMAS / BAHAMAS, THE
    'HR' => 'HR',    # CROATIA (local name: Hrvatska) / CROATIA
    'US' => 'US',    # UNITED STATES / UNITED STATES OF AMERICA
    'RU' => 'RS',    # RUSSIAN FEDERATION / RUSSIA
    'KP' => 'KN',    # KOREA, DEMOCRATIC PEOPLE\'S REPUBLIC OF / NORTH KOREA
    'KR' => 'KS',    # KOREA, REPUBLIC OF / SOUTH KOREA
    'CG' => 'CF',    # CONGO / CONGO. REPUBLIC OF THE
    'ZR' => 'CG',    # ZAIRE / CONGO, DEMOCRATIC REPUBLIC OF THE
    'VN' => 'VM',    # VIET NAM / VIETNAM
    'TW' => 'TW',    # TAIWAN, PROVINCE OF CHINA / TAIWAN
    'LY' => 'LY',    # LIBYAN ARAB JAMAHIRIYA / LIBYA
    'SH' => 'SH',    # ST. HELENA / SAINT HELENA
    'SK' => 'LO',    # SLOVAKIA (Slovak Republic) / SLOVAKIA
    'SY' => 'SY',    # SYRIAN ARAB REPUBLIC / SYRIA
    'MM' => 'BM',    # MYANMAR / BURMA (MYANMAR)
    'GM' => 'GA',    # GAMBIA / GAMBIA, THE
    'MD' => 'MD',    # MOLDOVA, REPUBLIC OF / MOLDOVA
    'WF' => 'WF',    # WALLIS AND FUTUNA ISLANDS / WALLIS AND FUTUNA
    'LA' => 'LA',    # LAO PEOPLE'S DEMOCRATIC REPUBLIC / LAOS

    # added to HA since version 0.18
    'TJ'  => 'TI',   # TAJIKISTAN
    'TZ'  => 'TZ',   # TANZANIA, UNITED REPUBLIC OF
    'VI'  => 'UI',   # VIRGIN ISLANDS (U.S.)
);

=begin codes

# Heavens-above places without ISO 3166 code
# You can use those with query()
%ha = (
        'JE' => 'JERSEY',
        'SR' => 'SERBIA',
        'MW' => 'MONTENEGRO',
        'GK' => 'GUERNSEY',
        'GZ' => 'GAZA STRIP',
        'WE' => 'WEST BANK',
      );

# ISO 3166 codes not used yet or countries not in HA
%iso = (
         'IO' => 'BRITISH INDIAN OCEAN TERRITORY',
         'BV' => 'BOUVET ISLAND',
         'YT' => 'MAYOTTE',
         'YU' => 'YUGOSLAVIA',
         'RE' => 'REUNION',
         'RW' => 'RWANDA',
         'KM' => 'COMOROS',
         'SC' => 'SEYCHELLES',
         'SJ' => 'SVALBARD AND JAN MAYEN ISLANDS',
         'SM' => 'SAN MARINO',
         'ST' => 'SAO TOME AND PRINCIPE',
         'TF' => 'FRENCH SOUTHERN TERRITORIES',
         'EH' => 'WESTERN SAHARA',
         'TK' => 'TOKELAU',
         'TP' => 'EAST TIMOR',
         'MO' => 'MACAU',
         'MP' => 'NORTHERN MARIANA ISLANDS',
         'MQ' => 'MARTINIQUE',
         'MS' => 'MONTSERRAT',
         'FK' => 'FALKLAND ISLANDS (MALVINAS)',
         'UM' => 'UNITED STATES MINOR OUTLYING ISLANDS',
         'FM' => 'MICRONESIA, FEDERATED STATES OF',
         'NC' => 'NEW CALEDONIA',
         'FX' => 'FRANCE, METROPOLITAN',
         'VA' => 'VATICAN CITY STATE (HOLY SEE)',
         'NR' => 'NAURU',
         'NU' => 'NIUE',
         'VG' => 'VIRGIN ISLANDS (BRITISH)',
         'GL' => 'GREENLAND',
         'GP' => 'GUADELOUPE',
         'GS' => 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS',
         'GW' => 'GUINEA-BISSAU',
         'HM' => 'HEARD AND MC DONALD ISLANDS',
         'WS' => 'SAMOA',
         'PM' => 'ST. PIERRE AND MIQUELON',
         'PN' => 'PITCAIRN',
         'PW' => 'PALAU'

         # removed from HA since version 0.18
         'AN' => 'NETHERLANDS ANTILLES / NETHERLAND ANTILLES', # NT
       );

=end codes

=cut

my %isolatin = (
    a => '[Aa������������]',
    c => '[Cc��]',
    e => '[Ee��������]',
    i => '[Ii��������]',
    d => '[Dd��]',
    n => '[Nn��]',
    o => '[Oo������������]',
    u => '[Uu��������]',
    y => '[Yy���]',
);

# helper sub
sub _isolatin {
    $_[0] =~ tr{���������������������������������������������������������}
               {aaaaaaaaaaaacceeeeeeeeiiiiiiiiddnnoooooooooooouuuuuuuuyyy};
}

sub new {
    my $class = shift;

    my $ua = LWP::UserAgent->new(
        env_proxy  => 1,
        keep_alive => 1,
        timeout    => 30,
    );
    $ua->agent( "WWW-Gazetteer-HeavensAbove/$VERSION " );

    bless { ua => $ua, retry => 5, @_ }, $class;
}

sub find {
    my ( $self, $query, $iso ) = ( shift, shift, uc shift );
    croak "No HA code for $iso ISO code" if !exists $iso{$iso};
    return $self->query( $query, $iso{$iso}, @_ );
}

# alias for backward compatibility
*WWW::Gazetteer::HeavensAbove::fetch = \&find;

sub query {
    my ( $self, $query, $code, $callback ) = @_;
    $code = uc $code;
    my $iso = '';
    for ( keys %iso ) { $iso = $_, last if $iso{$_} eq $code }

    my $url = $base . "SelectTown.aspx";
    my $res = $self->{ua}->request( HTTP::Request->new( GET => $url ) );
    croak $res->status_line if not $res->is_success;

    my $form = HTML::Form->parse( $res->content, $base );

    my $string = $query;
    _isolatin($string);
    my @data;
    do {

        # $string now holds the next request (if necessary)
        ( $string, my @list ) = $self->_getpage( $form, $string, $code, $iso );

        # process the block of data
        defined $callback ? $callback->(@list) : push @data, @list;

    } while ( length($query) < length($string) );

    return wantarray ? @data : \@data;
}

# this is a private method
sub _getpage {
    my ( $self, $form, $string, $code, $iso ) = @_;

    # fill the form and click submit
    $form->find_input('ctl00$cph1$ddlCountry')->value($code);
    $form->find_input('ctl00$cph1$txtSearch')->value($string);

    my $res;
    my $retry = $self->{retry};
    my $delay = 5;

    # retry until it works, with increasing delays
    while ( $retry-- ) {
        $res = $self->{ua}->request( $form->click );
        last if $res->is_success || $res->code >= 500;;
        sleep $delay if $retry;    # don't sleep if you won't retry
        $delay *= 2;
    }

    # there was an error, giving up
    croak $res->status_line if not $res->is_success;

    # check if there were more than 200 answers
    my $content = $res->decoded_content;
    $content =~ s/&nbsp;/ /g;

    # parse the data
    my @data;
    {
        my $root = HTML::TreeBuilder->new_from_content($content);
        my @rows =
          ( $root->look_down( _tag => 'table' ) )[4]->look_down( _tag => 'tr' );

        # handle the region name
        my $header = shift @rows;
        my @headers = map { lc $_->as_trimmed_text } $header->content_list;
        my $regionname;
        ( $regionname, $headers[1] ) = ( $headers[1], 'region' )
          if ( @headers >= 6 );

        # fetch and process the data for each line
        for (@rows) {
            my $town =
              { regionname => $regionname || '', region => '' };
            @$town{@headers} = map { $_->as_trimmed_text } $_->content_list;
            $town->{latitude} =~ s/(.*)\x{b0}([NS])/($2 eq'S'&&'-').$1/e;
            $town->{longitude} =~ s/(.*)\x{b0}([WE])/($2 eq'W'&&'-').$1/e;
            $town->{name} = delete $town->{place};
            $town->{elevation} =~ s/ m$//;
            $town->{iso} = $iso;
            delete $town->{''};
            push @data, $town;
        }

        # clear off the tree
        ( $header, @rows ) = ();
        $root->delete;
    }

    # print STDERR "$string -> "; # DEBUG
    # more than 200 answers: compute better hints for next query
    if ( @data == 200 ) {

        # simplest case (scary, heh?)
        if ( $string =~ y/*// == 1 ) {

            # this removes the ? characters before the * in the query string
            my $len = index( $string, '*' );
            substr( $string, 0, $len, substr( $data[-1]{name}, 0, $len ) );

            # $re removes the cities that the next query will retrieve
            $string =~ /^([^*]*)\*(.*)/;
            my $re  = "^$1(.).*$2\$";
            $re =~ y/?/./;
            _isolatin($re);
            $re =~ s/([aceidnouy])/$isolatin{lc $1}/ig;

            # compute the next query string
            if ( $data[-1]{name} =~ /$re/i ) {
                my $last =
                  $string eq '*' ? substr( $data[-1]{name}, 0, 1 ) : $1;
                _isolatin($last);
                $re =~ s/\(\.\)/$isolatin{lc $last}||$last/e;
                $re = qr/$re/i;
                pop @data while @data && $data[-1]{name} =~ $re;
                $string =~ s/\*/$last*/;
            }
            else {
                # there are more than 200 Buenavista, MX
                # and this is an ugly, ugly hack
                warn "200 identical cities match '$string', "
                  . "only 200 returned\n";
                $string =~ s/\*/?*/;
            }
        }

        # more difficult cases with several jokers are ignored
    }
    else {

        # simplest case
        if ( $string =~ y/*// == 1 ) {

            # shorten the string
            $string =~ s/\?\*/*/i;    # ugly hack, continued
            $string =~ s/z+\*/*/i;

            # next step
            _isolatin($string);
            $string =~ s/([a-y])\*/chr(1+ord$1).'*'/ie;    # classic
            $string =~ s/�\*/t*/;           # German � sorts before t
            $string =~ s/[-'" (,]\*/a*/;    # quick and dirty for now
        }

        # more difficult cases with several jokers are ignored
    }
    # print STDERR scalar(@data), $/; #DEBUG
    return ( $string, @data );
}

1;

__END__

=encoding iso-8859-1

=head1 NAME

WWW::Gazetteer::HeavensAbove - Find location of world towns and cities

=head1 SYNOPSIS

 use WWW::Gazetteer::HeavensAbove;

 my $atlas = WWW::Gazetteer::HeavensAbove->new;

 # simple query using ISO 3166 codes
 my @towns = $atlas->find( 'Bacton', 'GB' );
 print $_->{name}, ", ", $_->{elevation}, $/ for @towns;

 # simple query using heavens-above.com codes
 my @towns = $atlas->query( 'Bacton', 'UK' );
 print $_->{name}, ", ", $_->{elevation}, $/ for @towns;

 # big queries can use a callback (and return nothing)
 $atlas->find(
     'Bacton', 'GB',
     sub { print $_->{name}, ", ", $_->{elevation}, $/ for @_ }
 );

 # find() returns an arrayref in scalar context
 $cities = $atlas->find( 'Paris', 'FR' );
 print $cities->[1]{name};

 # the heavens-above.com site supports complicated queries
 my @az = $atlas->find( 'a*z', 'FR' );

 # and you can naturally use callbacks for those!
 my ($c, n);
 $atlas->find( 'N*', 'US', sub { $c++; $n += @_ }  );
 print "$c web requests needed for finding $n cities";

 # or use your own UserAgent
 my $ua = LWP::UserAgent->new;
 $atlas = WWW::Gazetteer::HeavensAbove->new( ua => $ua );

 # another way to create a new object
 use WWW::Gazetteer;
 my $g = WWW::Gazetteer->new('HeavensAbove');

=head1 DESCRIPTION

B<This module is obsolete, and is going to be removed from CPAN
on 2014-07-06.>

B<As of 2014-01-24, L<http://www.heavens-above.com/SelectTown.aspx>
started returning a C<500 Internal Server Error> code.
The site has moved from using its own geographic database
to using Google map services, making this module obsolete.>

A gazetteer is a geographical dictionary (as at the back of an atlas).
The WWW::Gazetteer::HeavensAbove module uses the information at
L<http://www.heavens-above.com/countries.asp> to return geographical location
(longitude, latitude, elevation) for towns and cities in countries in the
world.

Once a WWW::Gazetteer::HeavensAbove objects is created, use the C<find()>
method to return lists of hashrefs holding all the information for the
matching cities.

A city tructure looks like this:

 $lesparis = {
     iso        => 'FR',
     latitude   => '45.633',
     regionname => 'Region',
     region     => 'Rh�ne-Alpes',
     elevation  => '508',            # meters
     longitude  => '5.733',
     name       => 'Paris',
 };

Note: the 'regioname' attribute is the local name of a region (this can
change from country to country).

Due to the way heavens-above.com's database was created, cities from the
U.S.A. are handled as a special case. The C<region> field is the state,
and a special field named C<county> holds the county name.

Here is an example of an American city:

 $newyork = {
     iso        => 'US',
     latitude   => '39.685',
     regionname => 'State',
     region     => 'Missouri',
     county     => 'Caldwell',    # this is only for US cities
     elevation  => '244',
     longitude  => '-93.927',
     name       => 'New York'
 };
 
=head2 Methods

=over 4

=item new()

Return a new WWW::Gazetteer::HeavensAbove user-agent, ready to C<find()> cities for you.

The constructor can be given a list of parameters.
Currently supported parameters are:

C<ua> - the L<LWP::UserAgent> used for the web requests

C<retry> - the number of times a failed connection will be retried

You can also use the generic L<WWW::Gazetteer> module to create a new
WWW::Gazetteer::HeavenAbove object:

 use WWW::Gazetteer;
 my $g = WWW::Gazetteer->new('HeavensAbove');

You can also pass it inialisation parameters:

 use WWW::Gazetteer;
 my $g = WWW::Gazetteer->new('HeavensAbove',  retry => 3);

=item find( $city, $country [, $callback ] )

Return a list of cities matching C<$city>, within the country with ISO 3166
code C<$code> (not all codes are supported by heavens-above.com).

This method always returns an array of city structures. If the request
returns a lot of cities, you can pass a callback routine to C<find()>.
This routine receives the list of city structures as C<@_>. If a callback
method is given to C<find()>, C<find()> will return an empty list.

A single call to C<find()> can lead to several web requests. If the
query returns more than 200 answeris, heavens-above.com cuts at 200.
WWW::Gazetteer::HeavensAbove picks as many data as possible from this
first answer and then refines the query again and again.

Here's an excerpt from heavens-above.com documentation:

=over 4

You can use "wildcard" characters to match several towns if you're not
sure of the exact name. These characters are '*' which means "match
any sequence of characters", and '?' which means "match any single
character". The search is not case-sensitive.

Diacritic characters, such as � and � can either be entered directly
from the keyboard (assuming you have the appropriate keyboard), or
simply enter the letter without diacritic (e.g. you can enter 'a' for
'�', '�', '�', '�', '�' and '�'). If you need a special character which
is not on your keyboard, and is not a diacritic (e.g. the german '�',
and scandinavian '�'), simply enter a "?" instead, and all characers
will be matched.

=back

Note: heavens-above.com doesn't use ISO 3166 codes, but its own
country codes. If you want to use those directly, please see the C<query()>
method. (And read the source for the full list of HA codes.)

=item fetch( $searchstring, $code [, $callback ] );

C<fetch()> is a synonym for C<find()>. It is kept for backward compatibility.

=item query( $searchstring, $code [, $callback ] );

This method is the actual method called by C<find()>.

The only difference is that C<$code> is the heavens-above.com specific
country code, instead of the ISO 3166 code.

=back

=head2 Callbacks

The C<find()> and C<query()> methods both accept a optionnal coderef as
their third argument. This method is used as a callback each time a
batch of cities is returned by a web query to heavens-above.com.

This can be very useful if a query with a joker returns more than
200 answers. WWW::Gazetteer::HeavensAbove breaks it into new requests
that return a smaller number of answers. The callback is called with
the results of the subquery after each web request.

This method is called in void context, and is passed a list of
hashrefs (the cities found by the last query).

An example callback is (from F<eg/city.pl>):

 # print a tab separated list of cities
 my $cb = sub {
     local $, = "\t";
     local $\ = $/;
     print @$_{qw(name region latitude longitude elevation)} for @_;
 };

Please note that, due to the nature of the queries, your callback
can (and will most probably) be called with an empty C<@_>.

=head1 ALGORITHM

The web site returns only the first 200 answers to any query.
To handle huge requests like '*' (the biggest possible),
WWW::Gazetteer::HeavensAbove splits the requests in several parts.

Example, looking for C<pa*> in France:

=over 4

=item *

C<pa*> returns more than 200 answers, the last ones being:

    195 Paques, Rh�ne-Alpes
    196 Paquier, Rh�ne-Alpes
    197 Paradiso, Corse
    198 Paradou, Provence-Alpes-C�te d'Azur
    199 Paraise, Bourgogne
    200 Paraize (Paraise), Bourgogne

The algorithm keeps the 196 first ones, because they match C<pa*> and
not C<par*> (C<r> is the first character matched by C<*> in the
last city matched).

=item *

The next sub-query is computed as C<par*> (176 cities)

=item *

It is followed by C<pas*> (64), C<pat*> (12), C<pau*> (44), C<pav*>
(11), C<paw*> (0), C<pay*> (18) and C<paz*> (5).

=back

There is at least one query that cannot be completely fulfilled:
there are more than 200 cities named Buenavista in Mexico. The web site
limitation of 200 cities per query prevents us to get the other Benavistas
in Mexico. WWW::Gazetteer::HeavensAbove as of version 0.11 includes a
workaround to continues with the global query, and fetch only the first
200 Buenavistas. (This will work with other similarly broken answers.)

=head1 TODO

Handle the case where a query with more than one joker (*?) returns
more than 200 answers. For now, it stops at 200.

=head1 BUGS

Network errors croak after the maximum retry count has been reached. This
can be a problem when making big queries (that return more than 200
answers) which results are passed to a callback, because part of the data
has been already processed by the callback when the script dies. And
even if you can catch the exception, you cannot easily guess where to
start again.

Bugs in the database are not from heavens-above.com, since they
"put together and enhanced" data from the following two sources:
US Geological Survey (L<http://geonames.usgs.gov/index.html>) for the
USA and dependencies, and The National Imaging and Mapping Agency
(L<http://www.nima.mil/gns/html/index.html>) for all other countries.

See also: L<http://www.heavens-above.com/ShowFAQ.aspx?FAQID=100>

Please report any bugs or feature requests on the bugtracker website
L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Gazetteer-HeavensAbove> or by
email to bug-git-repository@rt.cpan.org.

When submitting a bug or request, please include a test-file or a
patch to an existing test-file that illustrates the bug or desired
feature.

=head1 AUTHOR

Philippe Bruhat (BooK) <book@cpan.org>

=head1 ACKNOWLEDGEMENTS

This module was a script, before I found out about Leon Brocard's
L<WWW::Gazetteer> module. Thanks! And, erm, bits of the documentation were
stolen from L<WWW::Gazetteer>.

Thanks to Alain Zalmanski (of L<http://www.fatrazie.com/> fame) for asking
me for all that geographical data in the first place.

=head1 SEE ALSO

"I<How I captured thousands of Afghan cities in a few hours>", one of my
lightning talks at YAPC::Europe 2002 (Munich). You had to be there.

L<WWW::Gazetteer> and L<WWW::Gazetteer::Calle>, by Leon Brocard.

The use Perl discussion that had me write this module from the original
script: L<http://use.perl.org/~acme/journal/8079>

The module master repository is held at:
L<http://git.bruhat.net/r/WWW-Gazetteer-HeavensAbove.git> and
L<http://github.com/book/WWW-Gazetteer-HeavensAbove>.

=head1 COPYRIGHT

Copyright 2002-2014 Philippe Bruhat (BooK).

=head1 LICENSE

This module is free software; you can redistribute it or modify it under
the same terms as Perl itself.

=cut
