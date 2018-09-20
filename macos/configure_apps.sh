#!/usr/bin/env bash

source ./macos/output_tools.sh

# TODO: Separate in functions

CURRENTSHELL=$(dscl . -read /Users/$USER UserShell | awk '{print $2}')
if [[ "$CURRENTSHELL" != "/usr/local/bin/fish" ]]; then
  substep "Setting Fish as default shell"
  sudo dscl . -change /Users/$USER UserShell $SHELL /usr/local/bin/fish > /dev/null 2>&1
fi

if [[ -d "/Library/Ruby/Gems/2.0.0" ]]; then
  substep "Fixing Ruby Gems Directory Permissions\n"
  sudo chown -R $(whoami) /Library/Ruby/Gems/2.0.0
fi

substep "Configuring fish shell"
substep "Installing omf"
curl -L https://get.oh-my.fish > /tmp/omf.fish && bash -c "fish /tmp/omf.fish --noninteractive"; rm -f /tmp/omf.fish
substep "Installing bobthefish theme"
fish -c "omf install bobthefish"
substep "Installing Fish custom configuration"
cp ./fish/config.fish $HOME/.config/fish/config.fish
rsync -a ./fish/functions/ $HOME/.config/fish/functions/

substep "Configuring Dock"
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
    --remove 'Skype for Business'   \
    --allhomes
substep "Adding iTerm"
python dockutil --add /Applications/iTerm.app
substep "Adding Spotify"
python dockutil --add /Applications/Spotify.app
substep "Adding Google Chrome"
python dockutil --add /Applications/Google\ Chrome.app
substep "Adding Spark"
python dockutil --add /Applications/Spark.app
substep "Adding Slack"
python dockutil --add /Applications/Slack.app
substep "Adding Telegram"
python dockutil --add /Applications/Telegram.app
rm -f dockutil

# Configure Skype For Business
sudo rm -f /Library/LaunchDaemons/com.microsoft.autoupdate.helper.plist
osascript -e 'tell application "System Events" to delete login item "Skype For Business"'

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

# Configure Google-Chrome as default browser
git clone --depth=1 https://github.com/kerma/defaultbrowser /tmp/defaultbrowser
make -C /tmp/defaultbrowser ; /tmp/defaultbrowser/defaultbrowser chrome
rm -rf /tmp/defaultbrowser

# Configure Dashlane
# TODO

# Configure Boom3D
# TODO

# Configure DaisyDisk
# TODO
