package WWW::Gazetteer::HeavensAbove;

use strict;
use LWP::UserAgent;
use HTML::Form;
use HTML::TreeBuilder;
use Carp qw( croak );

use vars qw( $VERSION );
$VERSION = 0.03;

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
    'AN' => 'NT',    # NETHERLANDS ANTILLES / NETHERLAND ANTILLES
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

# ISO 3166 codes not used yet
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
         'TJ' => 'TAJIKISTAN',
         'TK' => 'TOKELAU',
         'TP' => 'EAST TIMOR',
         'TZ' => 'TANZANIA, UNITED REPUBLIC OF',
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
         'VI' => 'VIRGIN ISLANDS (U.S.)',
         'GL' => 'GREENLAND',
         'GP' => 'GUADELOUPE',
         'GS' => 'SOUTH GEORGIA AND THE SOUTH SANDWICH ISLANDS',
         'GW' => 'GUINEA-BISSAU',
         'HM' => 'HEARD AND MC DONALD ISLANDS',
         'WS' => 'SAMOA',
         'PM' => 'ST. PIERRE AND MIQUELON',
         'PN' => 'PITCAIRN',
         'PW' => 'PALAU'
       );

=end codes

=pod

=head1 NAME

WWW::Gazetteer::HeavensAbove - Find location of world towns and cities

=head1 SYNOPSIS

 use WWW::Gazetteer::HeavensAbove;

 my $atlas = WWW::Gazetteer::HeavensAbove->new;

 # simple query using ISO 3166 codes
 my @towns = $atlas->fetch( GB => 'Bacton' );
 print $_->{name}, ", ", $_->{elevation}, $/ for @towns;

 # simple query using heavens-above.com codes
 my @towns = $atlas->query( UK => 'Bacton' );
 print $_->{name}, ", ", $_->{elevation}, $/ for @towns;

 # big queries can use a callback (and return nothing)
 $atlas->fetch(
     GB => 'Bacton',
     sub { print $_->{name}, ", ", $_->{elevation}, $/ for @_ }
 );

 # the heavens-above.com site supports complicated queries
 my @az = $atlas->fetch( FR => 'a*z' );

=head1 DESCRIPTION

A gazetteer is a geographical dictionary (as at the back of an atlas).
The WWW::Gazetteer::HeavensAbove module uses the information at
http://www.heavens-above.com/countries.asp to return geographical location
(longitude, latitude, elevation) for towns and cities in countries in the
world.

Once a WWW::Gazetteer::HeavensAbove objects is created, use the fetch()
method to return lists of hashrefs holding all the information for the
matching cities.

A city tructure looks like this:

 $lesparis = {
     latitude   => '45.633',
     regionname => 'Region',
     region     => 'Rhône-Alpes',
     alias      => 'Les Paris',
     elevation  => '508 m',
     longitude  => '5.733',
     name       => 'Paris',
 };
 
Note: the 'regioname' attribute is the local name of a region (this can
change from country to country).

Due to the way heavens-above.com's database was created, cities from the
U.S.A. are handled as a special case. The C<region> field is the state,
and a special field named C<county> holds the county name.

An example of an American city:

 $newyork = {
     latitude   => '39.685',
     regionname => 'State',
     region     => 'Missouri',
     county     => 'Caldwell',    # this is only for US cities
     alias      => '',
     elevation  => '244 m',
     longitude  => '-93.927',
     name       => 'New York'
 };
 
=head2 Methods

=over 4

=item new()

Return a new WWW::Gazetteer::UserAgent, ready to fetch() cities for you.

=cut

sub new {
    my $class = shift;

    my $ua = LWP::UserAgent->new(
        env_proxy  => 1,
        keep_alive => 1,
        timeout    => 30,
    );
    $ua->agent( "WWW::Gazetteer::HeavensAbove/$VERSION " . $ua->agent );

    bless { ua => $ua }, $class;
}

=item fetch( $code, $city [, $callback ] )

Return a list of cities matching $city, within the country with ISO 3166
code $code (not all codes are supported by heavens-above.com).

This method always returns an array of city structures. If the request
returns a lot of cities, you can pass a callback routine to fetch().
This routine receives the list of city structures as @_. If a callback
method is given to fetch(), fetch() will return an empty list.

Note: heavens-above.com doesn't use ISO 3166 codes, but its own
country codes. If you want to use those directly, please see the query()
method. (And read the source for the full list of HA codes.)

=cut

sub fetch {
    my ( $self, $iso ) = ( shift, uc shift );
    croak "No HA code for $iso ISO code" if !exists $iso{$iso};
    return $self->query( $iso{$iso}, @_ );
}

=item query( $code, $searchstring [, $callback ] );

This method is the actual method called by fetch().
The only difference is that $code is the heavens-above.com specific
country code, instead of the ISO 3166 code.

=cut

sub query {
    my ( $self, $code, $query, $callback ) = @_;
    $code = uc $code;

    my $url = $base . "selecttown.asp?CountryID=$code&loc=Unspecified";
    my $res = $self->{ua}->request( HTTP::Request->new( GET => $url ) );
    croak $res->status_line if not $res->is_success;

    my $form = HTML::Form->parse( $res->content, $base );

    my $string = $query;
    my @data;
    do {

        # $string now holds the next request (if necessary)
        my ( $string, @list ) = $self->getpage( $form, $string );

        # process the block of data
        defined $callback ? $callback->(@list) : push @data, @list;

    } while ( length($query) < length($string) );

    return @data;
}

# this is a private method
sub getpage {
    my ( $self, $form, $string ) = @_;

    # fill the form and click submit
    $form->find_input('Search')->value($string);
    my $res = $self->{ua}->request( $form->click );
    croak $res->status_line if not $res->is_success;

    my $content = $res->content;
    if ( index( $content, "ADODB.Field" ) != -1 ) {
        $res->request->content =~ /CountryID=(..)/;
        croak "No HA code $1";
    }

    $content =~ s/&nbsp;/ /g;                              # cleanup
    $content =~ /(\d+) towns were found by the search./;
    my $count = $1;
    $count = -1 if index( $content, 'cut-off after 200 towns' ) != -1;

    # parse the data
    my $root = HTML::TreeBuilder->new_from_content($content);
    my @rows =
      ( $root->look_down( _tag => 'table' ) )[2]->look_down( _tag => 'tr' );

    # handle the region name
    my $regionname = shift @rows;
    my $county;
    $county     = ( $regionname->content_list )[2]->as_trimmed_text eq "County";
    $regionname = ( $regionname->content_list )[1]->as_trimmed_text;

    # fetch and process the data for each line
    my @data;
    for (@rows) {
        my $town = { regionname => $regionname, alias => '' };
        @$town{qw( name region county latitude longitude elevation )} =
          ( map { $_->as_trimmed_text } $_->content_list )[ 0, 1, -5 .. -2 ];
        delete $town->{county} if not $county;    # county is only for US
        $town->{alias} = $1 if $town->{name} =~ s/\(alias for (.*?)\)//;
        push @data, $town;
    }
    $root->delete;

    if ( $count == -1 ) {

        # TODO
        # find the first ones and store them
        # and modify $string
        # 1) easy: "str" and "str*"
        # 2) not difficult: "st*r" (one star)
        # 3) difficult: several jokers
    }
    return ( $string, @data );
}

=back

=head2 Callbacks

The fetch() and query() methods both accept a optionnal coderef as
their third argument. This method is used as a callback each time a
batch of cities is returned by a web query to heavens-above.com.

This method is called in void context, and is passed a list of
hashrefs (the cities fetched by the last query).

An example callback is (from F<eg/city.pl>):

 # print a tab separated list of cities
 my $cb = sub {
     local $, = "\t";
     local $\ = $/;
     print @$_{qw(name alias region latitude longitude elevation)} for @_;
 };

=head1 TODO

Allow the script to run correctly when a query returns more than 200
answers (stops at the 200 firsts for the moment).

Find an appropriate interface with Leon, and adhere to it.

=head1 BUGS

WWW::Gazetteer::HeavensAbove does not work correctly yes with the US,
since the database returns State and County. I suppose this is the only
country that behaves this way, due to the way the database was created.

Bugs in the database are not from heavens-above.com, since they
"put together and enhanced" data from the following two sources:
US Geological Survey (http://geonames.usgs.gov/index.html) for the
USA and dependencies, and The National Imaging and Mapping Agency
(http://www.nima.mil/gns/html/index.html) for all other countries.

See also: http://www.heavens-above.com/ShowFAQ.asp?FAQID=100

=head1 AUTHOR

Philippe "BooK" Bruhat E<lt>book@cpan.orgE<gt>.

This module was a script, before I found out about Leon Brocard's
WWW::Gazetteer module. Thanks! And, erm, bits of the documentation were
stolen from WWW::Gazetteer.

Thanks to Alain Zalmanski (from http://www.fatrazie.com/) for asking
me for all that geographical data in the first place.

=head1 SEE ALSO

"How I captured thousands of Afghan cities in a few hours", one of my
lightning talks at YAPC::Europe 2002 (Munich). Slides will be online
someday.

WWW::Gazetteer, the original, by Leon Brocard.

The use Perl discussion that had me write this module from the original
script: http://use.perl.org/~acme/journal/8079

=head1 COPYRIGHT

This module is free software; you can redistribute it or modify it under
the same terms as Perl itself.

=cut

1;

