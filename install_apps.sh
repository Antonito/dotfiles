#!/usr/bin/env bash

source .private_script_helpers/colors.sh
source .private_script_helpers/require.sh

# ---------------
# Brew
# ---------------
bot "Installing Homebrew"
which -s brew
if [[ $? != 0 ]] ; then
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  if [[ $? != 0 ]]; then
      error "unable to install homebrew, script $0 abort!"
      exit 2
  fi
fi
brew update
brew upgrade
brew cask upgrade
RUBY_CONFIGURE_OPTS="--with-openssl-dir=`brew --prefix openssl` --with-readline-dir=`brew --prefix readline` --with-libyaml-dir=`brew --prefix libyaml`"
require_brew ruby

# ---------------
# Dependencies
# ---------------
bot "Installing dependencies"
require_brew git &
require_brew mas &
require_brew fontconfig &
require_brew python3 &
wait

# ---------------
# Communication
# ---------------
bot "Installing communication tools"
require_cask slack &
require_cask telegram &
require_cask skype-for-business &
require_cask caprine &
wait

# ---------------
# Mail
# ---------------
bot "Installing communication tools"
require_mas "Spark" "1176895641" &

# ---------------
# Media
# ---------------
bot "Installing Media"
require_cask spotify &

wait

# ---------------
# TextEditor
# ---------------
bot "Installing Text Editors"
#require_mas "Xcode" "497799835"
require_brew neovim &
require_cask visual-studio-code &
require_cask atom &
wait

# ---------------
# Desktop Utility
# ---------------
bot "Installing Desktop Utilities"
#require_mas "Keynote" "409183694" &
#require_mas "Numbers" "409203825" &
#require_mas "Pages" "409201541" &
#wait

# ---------------
# Utility
# ---------------
bot "Installing Utilities"
require_brew git-flow &
require_brew fish &
require_cask iterm2 &
require_cask google-chrome &
require_cask dashlane &
require_cask boom-3d &
require_cask daisydisk &
wait

# ---------------
# Virtualization
# ---------------
bot "Installing Virtualization tools"
require_cask docker

# ---------------
# Configuration
# ---------------
bot "Configuring installation"

# Set Fish as default shell
CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/usr/local/bin/fish" ]]; then
  bot "Setting newer homebrew fish (/usr/local/bin/fish) as your shell (password required)"
  sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/fish > /dev/null 2>&1
  ok
fi

bot "Installing fonts"
./fonts/install.sh
brew tap caskroom/fonts
require_cask font-fontawesome &
require_cask font-awesome-terminal-fonts &
require_cask font-hack &
require_cask font-inconsolata-dz-for-powerline &
require_cask font-inconsolata-g-for-powerline &
require_cask font-inconsolata-for-powerline &
require_cask font-roboto-mono &
require_cask font-roboto-mono-for-powerline &
require_cask font-source-code-pro &
wait
ok

if [[ -d "/Library/Ruby/Gems/2.0.0" ]]; then
  running "Fixing Ruby Gems Directory Permissions\n"
  sudo chown -R $(whoami) /Library/Ruby/Gems/2.0.0
  ok
fi

# Configure shell
bot "Configuring shell fish"
running "Installing omf\n"
curl -L https://get.oh-my.fish | fish
running "Installing bobthefish theme\n"
fish -c "omf install bobthefish"
running "Installing Fish custom configuration\n"
cp ./fish/config.fish $HOME/.config/fish/config.fish &
rsync -a ./fish/functions/ $HOME/.config/fish/functions/ &
wait

# Configure Dock
bot "Configuring Dock"
curl -o dockutil https://raw.githubusercontent.com/kcrawford/dockutil/master/scripts/dockutil
running "Deleting useless elements from the Dock"
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
    --remove 'Skype for Business'   \
    --allhomes
running "Adding iTerm\n"
python dockutil --add /Applications/iTerm.app
running "Adding Spotify\n"
python dockutil --add /Applications/Spotify.app
running "Adding Google Chrome\n"
python dockutil --add /Applications/Google\ Chrome.app
running "Adding Spark\n"
python dockutil --add /Applications/Spark.app
running "Adding Slack\n"
python dockutil --add /Applications/Slack.app
running "Adding Telegram\n"
python dockutil --add /Applications/Telegram.app
rm -f dockutil

# Configure Skype For Business
sudo rm -f /Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist &
osascript -e 'tell application "System Events" to delete login item "Skype For Business"' &
wait

# Configure git
cp ./.gitconfig $HOME/

# Configure Caprine
cd ./caprine; ./install.sh; cd -

# Configure Spark
# TODO

# Configure Neovim
# TODO (Keep it installed on mac ?)

# Configure VSCode
# TODO

# Configure Atom
# TODO

# Configure iTerm2
cd ./iterm2/; ./install.sh; cd -;

# Configure Google-Chrome
# TODO

# Configure Dashlane
# TODO

# Configure Boom3D
# TODO

# Configure DaisyDisk
# TODO

# ---------------
# Cleanup
# ---------------

running "Cleaning-up homebrew\n"
brew cleanup > /dev/null 2>&1
ok
