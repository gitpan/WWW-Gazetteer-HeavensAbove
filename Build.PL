use Module::Build;
my $build = Module::Build->new(
    module_name       => 'WWW::Gazetteer::HeavensAbove',
    dist_author       => 'Philippe Bruhat (BooK) <book@cpan.org>',
    license           => 'perl',
    requires          => {
        'HTML::TreeBuilder' => 3.13,
        'HTML::Form'        => 0,
        'LWP::UserAgent'    => 2,
        'Test::More'        => 0,
    },
    add_to_cleanup => ['WWW-Gazetteer-HeavensAbove-*'],
);
$build->create_build_script();

