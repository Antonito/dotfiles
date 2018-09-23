# Dotfiles

  Scripts that I use to configure my own Macbook Pro (High Sierra, 10.13)
  It is still a work-in-progress.

## Usage

Run `curl https://raw.githubusercontent.com/Antonito/dotfiles/master/install.sh | bash`

You should set-up your own `~/.config/git/config`

## Customization

### Variables

These variables will be read from your environment, if provided

| Variable               | Default value                        |
|------------------------|--------------------------------------|
| CONF_TIMEZONE          | America/Los_Angeles                  |
| CONF_CURRENCY          | EUR                                  |
| CONF_COMPUTER_NAME     | MacbookPro                           |
| CONF_GIT_DOTFILES_REPO | https://github.com/Antonito/dotfiles |
| CONFIG_WALLPAPER_URL   |                                      | # TODO

### Licenses

These script will install several software licenses, if provided

> APP_SUPPORT=`~/Library/Application\ Support`

| Software          | File to provide                            | Location                                                |
|-------------------|--------------------------------------------|---------------------------------------------------------|
| Better Touch Tool | bettertouchtool/bettertouchtool.bttlicense | $APP_SUPPORT/BetterTouchTool/bettertouchtool.bttlicense |
| Daisy Disk        | daisydisk/License.DaisyDisk                | $APP_SUPPORT/DaisyDisk/License.DaisyDisk                |
| Dash              | dash/license.dash-license                  | $APP_SUPPORT/Dash/License/license.dash-license          |

## Features

- MacOS tweaks (see `macos/tweak.sh` for more informations)
- MacOS apps and utilities (see `brew/macOS.BrewFile` for more informations)
- Default shell is `fish`, with `bobthefish` theme
  - Custom command `check-update` (update applications installed with `brew`, `brew cask` and `mas`)
  - Custom command `rarch-dev` which starts an archlinux Docker container with all my development tools (ASM, C, C++, NodeJS, Python and Go)
- Dock is configured with `iTerm`, `Spotify`, `Chrome`, `Spark`, `Slack` and `Telegram`
- `Chrome` as default browser
- `Caprine` configured with Dark mode
- `iTerm` configured (fonts, key mapping)
- `gdb` configure to use Intel syntax
- `Atom` configured with `Nuclide`
- `VSCode` configured for ASM/C/C++/JS/Go/Python development, with `Dash` integration

## Note

`docker-archlinux/gui` image is an experimentation

I am trying to find a way to use GUI applications ran inside a docker container, from a MacOS host.

I've tried Xquartz, but there's too much latency and it does not support Retina display... I've had better results with VNC

Any suggestion is welcomed !