use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'WWW::Gazetteer::HeavensAbove',
    VERSION_FROM => 'HeavensAbove.pm',
    PREREQ_PM    => {
        'HTML::TreeBuilder' => 3.13,
        'HTML::Form'        => 0,
        'LWP::UserAgent'    => 2,
        'Test::More'        => 0,
    },
    ABSTRACT_FROM => 'HeavensAbove.pm',
    AUTHOR        => 'Philippe "BooK" Bruhat <book@cpan.org>',
    # LICENSE       => 'perl', # EUMM >= 6.30_04 required for this
);
