use ExtUtils::MakeMaker;
WriteMakefile(
    NAME         => 'WWW::Gazetteer::HeavensAbove',
    VERSION_FROM => 'HeavensAbove.pm',
    PREREQ_PM    => {
        'LWP::UserAgent' => 0.01,
        'Test::More'     => 0,
    },
    ABSTRACT_FROM => 'HeavensAbove.pm',
    AUTHOR        => 'Philippe "BooK" Bruhat <book@cpan.org>',
);
