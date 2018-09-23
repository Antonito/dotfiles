#!/usr/bin/env bash

function main() {
  prepare_script
  ask_for_sudo
  install_homebrew
  prepare_homebrew
  login_to_app_store
  clone_dotfiles_repo
  install_packages_with_brewfile
  configure_packages
  tweak_macOS
  cleanup
}

##
## Setup default variables
## These variables can be overwritten
##

# 'sudo systemsetup -listtimezones' for other values
export CONF_TIMEZONE=${CONF_TIMEZONE:="America/Los_Angeles"}
export CONF_CURRENCY=${CONF_CURRENCY:="EUR"}
export CONF_COMPUTER_NAME=${CONF_COMPUTER_NAME:="MacbookPro"}
export CONF_GIT_DOTFILES_REPO=${CONF_GIT_DOTFILES_REPO:="https://github.com/Antonito/dotfiles"}
export CONFIG_WALLPAPER_URL=${CONFIG_WALLPAPER_URL:="https://wallpaper.wiki/wp-content/uploads/2017/05/Retina-Great-Nature-Wallpapers-HD.jpg"}

##
## Functions
##

DOTFILES_REPO=/tmp/dotfiles/

function ask_for_sudo() {
  info "Prompting for sudo password..."

  if sudo -v; then
    # Keep-alive: update existing `sudo` time stamp until `setup.sh` has finished
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &
    success "Sudo credentials updated."
  else
    error "Obtaining sudo credentials failed."
  fi
}

function prepare_script() {
  # Retrieve info, success, error and substep commands
  curl -o /tmp/output_tools.sh https://raw.githubusercontent.com/Antonito/dotfiles/master/macos/output_tools.sh
  source /tmp/output_tools.sh
  rm -f /tmp/output_tools.sh
}

function login_to_app_store() {
  info "Logging into app store..."
  if mas account >/dev/null; then
    success "Already logged in."
  else
    info "Please enter your Apple Id login"
    read apple_id
    mas signin --dialog $apple_id
    until (mas account > /dev/null);
    do
      sleep 3
    done
    success "Login to app store successful."
  fi
}

function install_homebrew() {
  info "Installing Homebrew..."
  if hash brew 2>/dev/null; then
    success "Homebrew already exists."
  else
    url=https://raw.githubusercontent.com/Homebrew/install/master/install
    if /usr/bin/ruby -e "$(curl -fsSL ${url})" < /dev/null ; then
      brew update
      brew upgrade
      brew cask upgrade
      success "Homebrew installation succeeded."
    else
      error "Homebrew installation failed."
      exit 1
    fi
  fi
}

function prepare_homebrew() {
  info "Preparing Homebrew..."
  RUBY_CONFIGURE_OPTS="--with-openssl-dir=`brew --prefix openssl` --with-readline-dir=`brew --prefix readline` --with-libyaml-dir=`brew --prefix libyaml`"
  brew install ruby git mas
  success "Homebrew was correctly prepared"
}

function clone_dotfiles_repo() {
  info "Cloning dotfiles repository into ${DOTFILES_REPO} ..."
  if test -e $DOTFILES_REPO; then
    substep "${DOTFILES_REPO} already exists."
    pull_latest $DOTFILES_REPO
  else
    url=$CONF_GIT_DOTFILES_REPO
    if git clone --depth=1 "$url" $DOTFILES_REPO; then
      success "Cloned into ${DOTFILES_REPO}"
    else
      error "Cloning into ${DOTFILES_REPO} failed."
      exit 1
    fi
  fi
}

function tweak_macOS() {
  info "Tweaking MacOS ..."
  cd $DOTFILES_REPO; bash ./macos/tweak.sh ; cd -
  success "MacOS tweaked correctly."
}

function install_packages_with_brewfile() {
  info "Installing packages within ${DOTFILES_REPO}/brew/macOS.Brewfile ..."
  if brew bundle --file=$DOTFILES_REPO/brew/macOS.Brewfile; then
      success "Brewfile installation succeeded."
  else
      error "Brewfile installation failed."
      exit 1
  fi
}

function configure_packages() {
  info "Configuring applications ..."
  cd $DOTFILES_REPO; bash ./macos/configure_apps.sh ; cd -
  success "Applications configured correctly."
}

function cleanup() {
  info "Cleaning up installation"
  rm -rf ${DOTFILES_REPO}
  brew cleanup > /dev/null 2>&1

  info "Syncing files ..."
  sync
  info "Rebooting ..."
  osascript -e 'tell app "System Events" to restart'
  killall "Terminal"
}

##
## Entry point
##

main