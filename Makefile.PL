use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'WWW::Gazetteer::HeavensAbove',
    VERSION_FROM => 'lib/WWW/Gazetteer/HeavensAbove.pm',
    PREREQ_PM    => {
        'HTML::TreeBuilder' => 3.13,
        'HTML::Form'        => 0,
        'LWP::UserAgent'    => 2,
        'Test::More'        => 0,
    },
    ABSTRACT_FROM => 'lib/WWW/Gazetteer/HeavensAbove.pm',
    AUTHOR        => 'Philippe Bruhat (BooK) <book@cpan.org>',
    LICENSE       => 'perl',
    PL_FILES      => {},
);
