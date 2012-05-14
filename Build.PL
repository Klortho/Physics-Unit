
use strict;
use warnings;

use Module::Build 0.3601;

my $build = Module::Build->new(
  module_name => "Physics::Unit",
  dist_author => 'Christopher Maloney <voldrani@gmail.com>',
  license => "perl",
  build_requires => {
    "Module::Build" => "0.3601",
    "Test::More" => 0
  },
  configure_requires => {
    "Module::Build" => "0.3601"
  },
  requires => {
    "warnings" => 0,
  },
  PL_files => {
    'lib/Physics/Unit/UnitsByName.pod.PL' => 'lib/Physics/Unit/UnitsByName.pod',
    'lib/Physics/Unit/UnitsByType.pod.PL' => 'lib/Physics/Unit/UnitsByType.pod',
  },
  meta_merge => {
    resources  => {
      repository => "https://github.com/Klortho/Physics-Unit",
      bugtracker => "https://github.com/Klortho/Physics-Unit/issues",
    },
    #no_index => {
    #  file => [ 'README.pod' ],
    #},
  },
);

$build->create_build_script;
