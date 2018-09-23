#!/usr/bin/env bash

source ./macos/output_tools.sh

function init() {
  curl -o /tmp/dockutil https://raw.githubusercontent.com/kcrawford/dockutil/master/scripts/dockutil
  curl -o /tmp/omf.fish https://get.oh-my.fish
  git clone --depth=1 https://github.com/kerma/defaultbrowser /tmp/defaultbrowser
  make -C /tmp/defaultbrowser
  
  # Reload Dock, Skype For Business fix ??
  killall Dock
}

function deinit() {
  rm -f /tmp/dockutil
  rm -f /tmp/omf.fish
  rm -rf /tmp/defaultbrowser
}

function set_fish_default_shell() {
  CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
  if [[ "$CURRENTSHELL" != "/usr/local/bin/fish" ]]; then
    substep "Setting Fish as default shell"
    sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/fish > /dev/null 2>&1
  fi
}

function setup_ruby() {
  if [[ -d "/Library/Ruby/Gems/2.0.0" ]]; then
    substep "Fixing Ruby Gems Directory Permissions\n"
    sudo chown -R $(whoami) /Library/Ruby/Gems/2.0.0
  fi
}

function setup_fish() {
  substep "Configuring fish shell"
  substep "Installing omf"
  bash -c "fish /tmp/omf.fish --noninteractive"
  substep "Installing bobthefish theme"
  fish -c "omf install bobthefish"
  substep "Installing Fish custom configuration"
  cp ./fish/config.fish $HOME/.config/fish/config.fish
  rsync -a ./fish/functions/ $HOME/.config/fish/functions/
}

function setup_dock() {
  substep "Configuring Dock"
  substep "Restarting Dock"
  sync
  substep "Deleting useless elements from the Dock"
  python /tmp/dockutil                     \
      --remove 'System Preferences'   \
      --remove 'iTunes'               \
      --remove 'iBooks'               \
      --remove 'Reminders'            \
      --remove 'Maps'                 \
      --remove 'Calendar'             \
      --remove 'Notes'                \
      --remove 'Photos'               \
      --remove 'Contacts'             \
      --remove 'Launchpad'            \
      --remove 'Safari'               \
      --remove 'Mail'                 \
      --remove 'Siri'                 \
      --remove 'Messages'             \
      --remove 'FaceTime'             \
      --remove 'App Store'            \
      --remove 'Pages'                \
      --remove 'Numbers'              \
      --remove 'Keynote'              \
      --remove 'Skype for Business'   \
      --no-restart                    \
      --allhomes
  substep "Adding iTerm"
  python /tmp/dockutil --add /Applications/iTerm.app --no-restart
  substep "Adding Spotify"
  python /tmp/dockutil --add /Applications/Spotify.app --no-restart
  substep "Adding Google Chrome"
  python /tmp/dockutil --add /Applications/Google\ Chrome.app --no-restart
  substep "Adding Spark"
  python /tmp/dockutil --add /Applications/Spark.app --no-restart
  substep "Adding Slack"
  python /tmp/dockutil --add /Applications/Slack.app --no-restart
  substep "Adding Telegram"
  python /tmp/dockutil --add /Applications/Telegram.app --no-restart
  substep "Removing Skype for Business"
  python /tmp/dockutil --remove 'Skype for Business' --no-restart
  killall Dock
}

function setup_skype_for_business() {
  substep "Preventing Skype for Business to start at launch time"
  sudo rm -f /Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist
  osascript -e 'tell application "System Events" to delete login item "Skype For Business"'
}

function setup_git() {
  substep "Configuring git"
  cd ./git; ./install.sh; cd -
}

function setup_caprine() {
  substep "Configuring Caprine"
  cd ./caprine; ./install.sh; cd -
}

function setup_gdb() {
  substep "Configuring gdb"
  cd ./gdb; ./install.sh; cd -
}

#function setup_spark() {
#  # TODO
#}

function setup_neovim() {
  substep "Configuring Nvim" 

  substep "Installing nvim plugin manager" 
  curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs \
      https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim

  substep "Installing python3 helper" 
  pip3 install --user neovim

  substep "Installing configuration" 
  cd ./nvim; ./install.sh; cd -
}

function setup_vscode() {
  substep "Configuring VSCode"

  mkdir -p $HOME/.config/vscode

  substep "Installing x86_64 assembly support plugin"
  # TODO: Pull request on VSCode repository, add Env variable
  # code --extensions-dir $HOME/.config/vscode --install-extension 13xforever.language-x86-64-assembly
  code --install-extension 13xforever.language-x86-64-assembly
  substep "Installing C / C++ plugin"
  code --install-extension ms-vscode.cpptools
  substep "Installing clang-format plugin"
  code --install-extension xaver.clang-format
  substep "Installing ESLint plugin"
  code --install-extension dbaeumer.vscode-eslint
  substep "Installing Go plugin"
  code --install-extension ms-vscode.go
  substep "Installing Python plugin"
  code --install-extension ms-python.python
  substep "Installing GitLens plugin"
  code --install-extension eamodio.gitlens
  substep "Installing Dash integration plugin"
  code --install-extension deerawan.vscode-dash

  cd ./vscode; ./install.sh; cd -
}

function setup_atom() {
  substep "Configuring Atom"
  mkdir -p $HOME/.config/atom
  export ATOM_HOME="$HOME/.config/atom"

  substep "Installing Nuclide"
  apm install nuclide
  substep "Installing language-babel package"
  apm install language-babel 
  substep "Installing recommended nuclide packages"
  apm install file-icons tool-bar highlight-selected              \
    language-babel language-graphql language-haskell language-ini \
    language-kotlin language-lua language-ocaml language-rust     \
    language-swift language-thrift language-scala                 \
    nuclide-format-js set-syntax sort-lines
}

function setup_iterm() {
  substep "Configuring iTerm"
  cd ./iterm2/; ./install.sh; cd -;
}

function setup_chrome() {
  substep "Setting Google Chrome as default browser"
  /tmp/defaultbrowser/defaultbrowser chrome
}

function setup_docker() {
  substep "Creating Docker symlink"
  ln -s /Applications/Docker.app/Contents/Resources/bin/docker /usr/local/bin/
}

function setup_bettertouchtool() {
  substep "Configuring Better Touch Tool"
  cd bettertouchtool; ./install.sh; cd -;
}

function setup_bartender() {
  substep "Configuring Bartender"
  cd bartender; ./install.sh; cd -;
}

function setup_dash() {
  substep "Configuring Dash"
  cd dash; ./install.sh; cd -;
}

function setup_weechat() {
  substep "Configuring Weechat"
  cd weechat; ./install.sh; cd -;
}

#function setup_boom3d() {
#  # TODO
#}

function setup_daisydisk() {
  cd ./daisydisk; ./install.sh; cd -
}

init # Must be first
set_fish_default_shell
setup_ruby
setup_fish
setup_weechat
setup_bettertouchtool
setup_bartender
setup_dash
setup_skype_for_business
setup_git
setup_gdb
setup_caprine
#setup_spark
setup_neovim
setup_vscode
setup_atom
setup_iterm
setup_chrome
setup_docker
#setup_boom3d
setup_daisydisk
setup_dock
deinit  # Must be last