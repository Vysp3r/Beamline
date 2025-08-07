<h1 align="center">
    Beamline
</h1>

<p align="center">
  <strong> A simple and modern game launcher</strong>
</p>

<p align="center">
    <a href="https://github.com/Vysp3r/Beamline/stargazers">
      <img alt="Stars" title="Stars" src="https://img.shields.io/github/stars/Vysp3r/Beamline?style=shield&label=%E2%AD%90%20Stars&branch=main&kill_cache=1%22" />
    </a>
    <a href="https://github.com/Vysp3r/ProtonPlus/blob/main/LICENSE.md">
      <img alt="License" title="License" src="https://img.shields.io/github/license/Vysp3r/ProtonPlus?label=%F0%9F%93%9C%20License" />
    </a>
</p>

<p align="center">
    Don't forget to star the repo if you are enjoying the project!</i>
</p>

## ✨ Features

TODO

## 📦️ Installation methods

None for now

## 🏗️ Building from source

**Requirements**

- [git](https://github.com/git/git)
- [ninja](https://github.com/ninja-build/ninja)
- [meson >= 1.0.0](https://github.com/mesonbuild/meson)
- [desktop-file-utils](https://gitlab.freedesktop.org/xdg/desktop-file-utils)
- [gtk4](https://gitlab.gnome.org/GNOME/gtk/)
- [libadwaita >= 1.6](https://gitlab.gnome.org/GNOME/libadwaita)
- [json-glib](https://gitlab.gnome.org/GNOME/json-glib)
- [libsoup](https://gitlab.gnome.org/GNOME/libsoup)
- [libarchive](https://github.com/libarchive/libarchive)
- [libgee](https://gitlab.gnome.org/GNOME/libgee)
- [libnm](https://gitlab.freedesktop.org/NetworkManager/NetworkManager)
- [libportal](https://github.com/flatpak/libportal)
- [libportal-gtk4](https://github.com/flatpak/libportal)
- [upower-glib](https://gitlab.freedesktop.org/upower/upower/)

<details>
  <summary>Linux</summary>

1. Install all dependencies

2. Clone the GitHub repo and change to repo directory
    ```bash
    git clone https://github.com/Vysp3r/Beamline.git && \
      cd Beamline
    ```

3. Build the local source code as a native application
    ```bash
    ./scripts/build-native.sh

    # Alternative: Runs application after the build.
    ./scripts/build-native.sh run
    ```

4. (Optional) Install the application
    ```bash
    cd build-native
    ninja install
    ```

5. Run the application
    ```bash
    cd src && \
    ./beamline
    ```
</details>

## 📖 Wiki

**The wiki is not yet built**

## 🌐 Translate

**You can translate Beamline by modifying the PO files directly**

## 🙌 Contribute

**Please read our [Contribution Guidelines](/CONTRIBUTING.md)**

All contributions are highly appreciated.

## 👥 Contributors

[![Contributors](https://contrib.rocks/image?repo=Vysp3r/Beamline)](https://github.com/Vysp3r/Beamline/graphs/contributors)
