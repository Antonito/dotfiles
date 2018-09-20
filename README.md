# Dotfiles

  Scripts that I use to configure my own Macbook Pro (High Sierra, 10.13)
  It is still a work-in-progress.

## Usage

Run `curl https://raw.githubusercontent.com/Antonito/dotfiles/master/install.sh | bash`

You should set-up your own `$HOME/.gitconfig`

## Customization

If you own a Daisydisk license, you can place it as `./daisydisk/License.DaisyDisk`

Your Daisydisk license is located at `~/Library/Application Support/DaisyDisk/License.DaisyDisk`

## Features

- MacOS tweaks (see `macos/tweak.sh` for more informations)
- Installs with `brew`, `brew cask` or `mas`:

  - `git`
  - `python3`
  - `Slack`
  - `Telegram`
  - `Skype for Business`
  - `Caprine`
  - `Spark` (App Store)
  - `Spotify`
  - `VLC`
  - `Xcode` (App Store)
  - `neovim`
  - `Visual Studio Code`
  - `Atom`
  - `Keynote` (App Store)
  - `Numbers` (App Store)
  - `Pages` (App Store)
  - `git-flow`
  - `fish`
  - `iTerm2`
  - `Google Chrome`
  - `Dashlane`
  - `Boom3D`
  - `DaisyDisk`
  - `docker`

- Default shell is `fish`, with `bobthefish` theme

  - Custom command `check-update` (update applications installed with `brew`, `brew cask` and `mas`)
  - Custom command `rarch-dev` which starts an archlinux Docker container with all my development tools (ASM, C, C++, NodeJS, Python and Go)
- Dock is configured with `iTerm`, `Spotify`, `Chrome`, `Spark`, `Slack` and `Telegram`
- Caprine configured with Dark mode
- iTerm configured (fonts, key mapping)

## Note

`docker-archlinux/gui` image is an experimentation

I am trying to find a way to use GUI applications ran inside a docker container, from a MacOS host.

I've tried Xquartz, but there's too much latency and it does not support Retina display... I've had better results with VNC

Any suggestion is welcomed !