#!/usr/bin/env bash

function main() {
  ask_for_sudo
  install_homebrew
  prepare_homebrew
  login_to_app_store
  clone_dotfiles_repo
  tweak_macOS
  install_packages_with_brewfile
  configure_packages
  cleanup
}

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

function login_to_app_store() {
  info "Logging into app store..."
  if mas account >/dev/null; then
      success "Already logged in."
  else
      open -a "/Applications/App Store.app"
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
        url=https://github.com/Antonito/dotfiles
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

  info "Rebooting (press enter)"
  read reboot_opt
  osascript -e 'tell app "System Events" to restart'
  killall "Terminal"
}

## Output utilities

function coloredEcho() {
    local exp="$1";
    local color="$2";
    local arrow="$3";
    if ! [[ $color =~ '^[0-9]$' ]] ; then
       case $(echo $color | tr '[:upper:]' '[:lower:]') in
        black) color=0 ;;
        red) color=1 ;;
        green) color=2 ;;
        yellow) color=3 ;;
        blue) color=4 ;;
        magenta) color=5 ;;
        cyan) color=6 ;;
        white|*) color=7 ;; # white or invalid color
       esac
    fi
    tput bold;
    tput setaf "$color";
    echo "$arrow $exp";
    tput sgr0;
}

function info() {
    coloredEcho "$1" blue "[*] "
}

function substep() {
    coloredEcho "$1" magenta "  ..."
}

function success() {
    coloredEcho "$1" green "[+] "
}

function error() {
    coloredEcho "$1" red "[!] "
}

##
## Entry point
##

main