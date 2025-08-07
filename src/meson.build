beamline_sources += [
  'main.vala',

  'utils/system.vala',
  'utils/vdf.vala',
  'utils/filesystem.vala',
  'utils/parser.vala',
  'utils/web.vala',
  'utils/network.vala',

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
  'widgets/image.vala',
  'widgets/blurred-image.vala',

  'widgets/onboarding/main-box.vala',
  'widgets/onboarding/welcome-page.vala',
  'widgets/onboarding/controller-page.vala',
  'widgets/onboarding/launchers-page.vala',
  'widgets/onboarding/setup-page.vala',
  'widgets/onboarding/done-page.vala',

  'widgets/loading/main-box.vala',

  'widgets/bar/main-box.vala',
  'widgets/bar/top-bar.vala',
  'widgets/bar/bottom-bar.vala',
  'widgets/bar/library-bar.vala',

  'widgets/menu/main-box.vala',
  'widgets/menu/filter-box.vala',
  'widgets/menu/order-by-box.vala',
  'widgets/menu/options-box.vala',
  'widgets/menu/menu-box.vala',
  'widgets/menu/power-box.vala',
  'widgets/menu/connection-box.vala',

  'widgets/library/main-box.vala',
  'widgets/library/games-box.vala',
  'widgets/library/game-box.vala',

  'widgets/settings/main-box.vala',
  'widgets/settings/sidebar-box.vala',
  'widgets/settings/general-box.vala',
  'widgets/settings/system-box.vala',
  'widgets/settings/internet-box.vala',
  'widgets/settings/power-box.vala',
  'widgets/settings/audio-box.vala',
  'widgets/settings/library-box.vala',
  'widgets/settings/interface-box.vala',

  'widgets/game-row/main-box.vala',
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