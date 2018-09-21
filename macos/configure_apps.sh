#!/usr/bin/env bash

source ./macos/output_tools.sh

function set_fish_default_shell() {
  CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
  if [[ "$CURRENTSHELL" != "/usr/local/bin/fish" ]]; then
    substep "Setting Fish as default shell"
    sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/fish > /dev/null 2>&1
  fi

  if [[ -d "/Library/Ruby/Gems/2.0.0" ]]; then
    substep "Fixing Ruby Gems Directory Permissions\n"
    sudo chown -R $(whoami) /Library/Ruby/Gems/2.0.0
  fi
}

function setup_fish() {
  substep "Configuring fish shell"
  substep "Installing omf"
  curl -L https://get.oh-my.fish > /tmp/omf.fish && bash -c "fish /tmp/omf.fish --noninteractive"; rm -f /tmp/omf.fish
  substep "Installing bobthefish theme"
  fish -c "omf install bobthefish"
  substep "Installing Fish custom configuration"
  cp ./fish/config.fish $HOME/.config/fish/config.fish
  rsync -a ./fish/functions/ $HOME/.config/fish/functions/
}

function setup_dock() {
  substep "Configuring Dock"
  substep "Restarting Dock"
  killall Dock
  curl -o dockutil https://raw.githubusercontent.com/kcrawford/dockutil/master/scripts/dockutil
  substep "Deleting useless elements from the Dock"
  python dockutil                     \
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
      --no-restart                    \
      --allhomes
  substep "Adding iTerm"
  python dockutil --add /Applications/iTerm.app --no-restart
  substep "Adding Spotify"
  python dockutil --add /Applications/Spotify.app --no-restart
  substep "Adding Google Chrome"
  python dockutil --add /Applications/Google\ Chrome.app --no-restart
  substep "Adding Spark"
  python dockutil --add /Applications/Spark.app --no-restart
  substep "Adding Slack"
  python dockutil --add /Applications/Slack.app --no-restart
  substep "Adding Telegram"
  python dockutil --add /Applications/Telegram.app --no-restart
  substep "Removing Skype for Business"
  python dockutil --remove 'Skype for Business' --no-restart
  rm -f dockutil
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

#function setup_neovim() {
#  # TODO (Keep it installed on mac ?)
#}

function setup_vscode() {
  substep "Configuring VSCode"

  substep "Installing x86_64 assembly support plugin"
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

  cd ./vscode; ./install.sh; cd -
}

function setup_atom() {
  substep "Configuring Atom"
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
  git clone --depth=1 https://github.com/kerma/defaultbrowser /tmp/defaultbrowser
  make -C /tmp/defaultbrowser ; /tmp/defaultbrowser/defaultbrowser chrome
  rm -rf /tmp/defaultbrowser
}

function setup_docker() {
  substep "Creating Docker symlink"
  ln -s /Applications/Docker.app/Contents/Resources/bin/docker /usr/local/bin/
}

#function setup_boom3d() {
#  # TODO
#}

function setup_daisydisk() {
  cd ./daisydisk; ./install.sh; cd -
}

set_fish_default_shell
setup_fish
setup_dock
setup_skype_for_business
setup_git
setup_gdb
setup_caprine
#setup_spark
#setup_neovim
setup_vscode
setup_atom
setup_iterm
setup_chrome
setup_docker
#setup_boom3d
setup_daisydisk
