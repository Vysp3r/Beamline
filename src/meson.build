beamline_sources += [
  'main.vala',

  'utils/system.vala',
  'utils/vdf.vala',
  'utils/filesystem.vala',
  'utils/parser.vala',
  'utils/web.vala',
  'utils/network.vala',
  'utils/css.vala',

  'utils/importers/importer.vala',
  'utils/importers/steam.vala',
  'utils/importers/hgl.vala',

  'models/language.vala',
  'models/resolution.vala',

  'models/games/game.vala',
  'models/games/steam.vala',

  'models/launchers/launcher.vala',
  'models/launchers/steam.vala',
  'models/launchers/hgl.vala',

  'widgets/application.vala',
  'widgets/window.vala',

  'widgets/onboarding/main-box.vala',
  'widgets/onboarding/welcome-page.vala',
  'widgets/onboarding/controller-page.vala',
  'widgets/onboarding/launchers-page.vala',
  'widgets/onboarding/setup-page.vala',
  'widgets/onboarding/done-page.vala',

  'widgets/loading/main-box.vala',

  'widgets/home/main-box.vala',
  'widgets/home/image.vala',
  'widgets/home/blurred-image.vala',

  'widgets/home/bar/top-bar.vala',
  'widgets/home/bar/bottom-bar.vala',
  'widgets/home/bar/library-bar.vala',

  'widgets/home/menu/main-box.vala',
  'widgets/home/menu/filter-box.vala',
  'widgets/home/menu/order-by-box.vala',
  'widgets/home/menu/options-box.vala',
  'widgets/home/menu/menu-box.vala',
  'widgets/home/menu/power-box.vala',
  'widgets/home/menu/connection-box.vala',

  'widgets/home/library/main-box.vala',
  'widgets/home/library/games-box.vala',
  'widgets/home/library/game-box.vala',
  'widgets/home/library/collections-box.vala',
  'widgets/home/library/game-row.vala',

  'widgets/home/settings/main-box.vala',
  'widgets/home/settings/sidebar-box.vala',
  'widgets/home/settings/general-box.vala',
  'widgets/home/settings/system-box.vala',
  'widgets/home/settings/internet-box.vala',
  'widgets/home/settings/power-box.vala',
  'widgets/home/settings/audio-box.vala',
  'widgets/home/settings/library-box.vala',
  'widgets/home/settings/interface-box.vala',
]

beamline_deps = [
  declare_dependency(link_args: ['-lm']),
  config_dep,
  dependency('gtk4'),
  dependency('libadwaita-1', version: '>= 1.6'),
  dependency('glib-2.0'),
  dependency('json-glib-1.0'),
  dependency('libsoup-3.0'),
  dependency('libarchive'),
  dependency('gee-0.8'),
  dependency('libportal'),
  dependency('libportal-gtk4'),
  dependency('libnm'),
  dependency('upower-glib'),
  meson.get_compiler('vala').find_library('posix'),
]


executable('beamline',
  beamline_sources,
  dependencies: beamline_deps,
  include_directories: config_inc,
  install: true,
)