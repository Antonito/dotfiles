#!/usr/bin/env bash

# Functions
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

function substep() {
    coloredEcho "$1" magenta "  ..."
}

# TODO: Separate in functions

substep "cleanup homebrew"
brew cleanup > /dev/null 2>&1


substep "closing any system preferences to prevent issues with automated changes"
osascript -e 'tell application "System Preferences" to quit'


substep "always boot in verbose mode (not MacOS GUI mode)"
sudo nvram boot-args="-v";

substep "Disable remote login"
echo "yes" | sudo systemsetup -setremotelogin off

substep "Disable wake-on modem"
sudo systemsetup -setwakeonmodem off

substep "Disable wake-on LAN"
sudo systemsetup -setwakeonnetworkaccess off

substep "Disable guest account login"
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool false

substep "Disable local Time Machine snapshots"
sudo tmutil disablelocal;

substep "Remove the sleep image file to save disk space"
sudo rm -rf /Private/var/vm/sleepimage;
substep "Create a zero-byte file instead"
sudo touch /Private/var/vm/sleepimage;
substep "…and make sure it can’t be rewritten"
sudo chflags uchg /Private/var/vm/sleepimage;

substep "Disable disk image verification"
defaults write com.apple.frameworks.diskimages skip-verify -bool true
defaults write com.apple.frameworks.diskimages skip-verify-locked -bool true
defaults write com.apple.frameworks.diskimages skip-verify-remote -bool true;

substep "Increase window resize speed for Cocoa applications"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001;

substep "Save to disk (not to iCloud) by default"
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false;

substep "Automatically quit printer app once the print jobs complete"
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true;

substep "Restart automatically if the computer freezes"
sudo systemsetup -setrestartfreeze on;

substep "Never go into computer sleep mode"
sudo systemsetup -setcomputersleep Off > /dev/null;

substep "Allow quitting via ⌘ + Q; doing so will also hide desktop icons"
defaults write com.apple.finder QuitMenuItem -bool true;

substep "Show hidden files by default"
defaults write com.apple.finder AppleShowAllFiles -bool true;

substep "Show all filename extensions"
defaults write NSGlobalDomain AppleShowAllExtensions -bool true;

substep "Show status bar"
defaults write com.apple.finder ShowStatusBar -bool true;

substep "Show path bar"
defaults write com.apple.finder ShowPathbar -bool true;

substep "Allow text selection in Quick Look"
defaults write com.apple.finder QLEnableTextSelection -bool true;

substep "Display full POSIX path as Finder window title"
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true;

substep "When performing a search, search the current folder by default"
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf";

substep "Use list view in all Finder windows by default"
# Four-letter codes for the other view modes: `icnv`, `clmv`, `Flwv`
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv";

substep "Avoid creating .DS_Store files on network volumes"
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true;

substep "Disable the warning before emptying the Trash"
defaults write com.apple.finder WarnOnEmptyTrash -bool false;

substep "Empty Trash securely by default"
defaults write com.apple.finder EmptyTrashSecurely -bool true;

substep "Enable AirDrop over Ethernet and on unsupported Macs running Lion"
defaults write com.apple.NetworkBrowser BrowseAllInterfaces -bool true;

substep "Show the ~/Library folder"
chflags nohidden ~/Library;

substep "Expand the following File Info panes: “General”, “Open with”, and “Sharing & Permissions”"
defaults write com.apple.finder FXInfoPanesExpanded -dict \
  General -bool true \
  OpenWith -bool true \
  Privileges -bool true;

substep "Disable Dashboard"
defaults write com.apple.dashboard mcx-disabled -bool true;

substep "Don’t show Dashboard as a Space"
defaults write com.apple.dock dashboard-in-overlay -bool true;

substep "Don’t automatically rearrange Spaces based on most recent use"
defaults write com.apple.dock mru-spaces -bool false;

substep "Set Safari’s home page to ‘about:blank’ for faster loading"
defaults write com.apple.Safari HomePage -string "about:blank";

substep "Prevent Safari from opening ‘safe’ files automatically after downloading"
defaults write com.apple.Safari AutoOpenSafeDownloads -bool false;

substep "Disable Safari’s thumbnail cache for History and Top Sites"
defaults write com.apple.Safari DebugSnapshotsUpdatePolicy -int 2;

substep "Enable Safari’s debug menu"
defaults write com.apple.Safari IncludeInternalDebugMenu -bool true;

substep "Make Safari’s search banners default to Contains instead of Starts With"
defaults write com.apple.Safari FindOnPageMatchesWordStartsOnly -bool false;

substep "Remove useless icons from Safari’s bookmarks bar"
defaults write com.apple.Safari ProxiesInBookmarksBar "()";

substep "Enable the Develop menu and the Web Inspector in Safari"
defaults write com.apple.Safari IncludeDevelopMenu -bool true
defaults write com.apple.Safari WebKitDeveloperExtrasEnabledPreferenceKey -bool true
defaults write com.apple.Safari com.apple.Safari.ContentPageGroupIdentifier.WebKit2DeveloperExtrasEnabled -bool true;

substep "Add a context menu item for showing the Web Inspector in web views"
defaults write NSGlobalDomain WebKitDeveloperExtras -bool true;

substep "Disable Spotlight indexing for any volume that gets mounted and has not yet been indexed"
# Use `sudo mdutil -i off "/Volumes/foo"` to stop indexing any volume.
sudo defaults write /.Spotlight-V100/VolumeConfiguration Exclusions -array "/Volumes";
substep "Change indexing order and disable some file types from being indexed"
defaults write com.apple.spotlight orderedItems -array \
  '{"enabled" = 1;"name" = "APPLICATIONS";}' \
  '{"enabled" = 1;"name" = "SYSTEM_PREFS";}' \
  '{"enabled" = 1;"name" = "DIRECTORIES";}' \
  '{"enabled" = 1;"name" = "PDF";}' \
  '{"enabled" = 1;"name" = "FONTS";}' \
  '{"enabled" = 0;"name" = "DOCUMENTS";}' \
  '{"enabled" = 0;"name" = "MESSAGES";}' \
  '{"enabled" = 0;"name" = "CONTACT";}' \
  '{"enabled" = 0;"name" = "EVENT_TODO";}' \
  '{"enabled" = 0;"name" = "IMAGES";}' \
  '{"enabled" = 0;"name" = "BOOKMARKS";}' \
  '{"enabled" = 0;"name" = "MUSIC";}' \
  '{"enabled" = 0;"name" = "MOVIES";}' \
  '{"enabled" = 0;"name" = "PRESENTATIONS";}' \
  '{"enabled" = 0;"name" = "SPREADSHEETS";}' \
  '{"enabled" = 0;"name" = "SOURCE";}';
substep "Load new settings before rebuilding the index"
killall mds > /dev/null 2>&1;
substep "Make sure indexing is enabled for the main volume"
sudo mdutil -i on / > /dev/null;

substep "Prevent Time Machine from prompting to use new hard drives as backup volume"
defaults write com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true;

substep "Disable local Time Machine backups"
hash tmutil &> /dev/null && sudo tmutil disablelocal;

substep "Show the main window when launching Activity Monitor"
defaults write com.apple.ActivityMonitor OpenMainWindow -bool true;

substep "Visualize CPU usage in the Activity Monitor Dock icon"
defaults write com.apple.ActivityMonitor IconType -int 5;

substep "Show all processes in Activity Monitor"
defaults write com.apple.ActivityMonitor ShowCategory -int 0;

substep "Sort Activity Monitor results by CPU usage"
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0;

substep "Enable the debug menu in Disk Utility"
defaults write com.apple.DiskUtility DUDebugMenuEnabled -bool true
defaults write com.apple.DiskUtility advanced-image-options -bool true;

substep "Setting Dark bar and hub mode"
osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'; 
substep "Auto-hide Menu bar"
defaults write NSGlobalDomain _HIHideMenuBar -bool false; 
substep "Auto-hide Dock"
defaults write com.apple.dock autohide -bool true;
substep "Super fast Dock auto-hide"
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.5; 
substep "Make Dock icons of hidden applications translucent"
defaults write com.apple.dock showhidden -bool true;
substep "Make Dock more transparent"
defaults write com.apple.dock hide-mirror -bool true;

substep "Don’t display the annoying prompt when quitting iTerm"
defaults write com.googlecode.iterm2 PromptOnQuit -bool false;

substep "Avoid .DS_Files on USB volumes"
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

substep "Enable the automatic update check"
defaults write com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true

substep "Check for software updates daily, not just once per week"
defaults write com.apple.SoftwareUpdate ScheduleFrequency -int 1

substep "Download newly available updates in background"
defaults write com.apple.SoftwareUpdate AutomaticDownload -int 1

substep "Install System data files & security updates"
defaults write com.apple.SoftwareUpdate CriticalUpdateInstall -int 1

substep "Turn on app auto-update"
defaults write com.apple.commerce AutoUpdate -bool true

substep "Disable press-and-hold for keys in favor of key repeat"
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false; 

substep "Set a blazingly fast keyboard repeat rate"
defaults write NSGlobalDomain KeyRepeat -int 1
defaults write NSGlobalDomain InitialKeyRepeat -int 10; 

substep "Disable the “Are you sure you want to open this application?” dialog"
defaults write com.apple.LaunchServices LSQuarantine -bool false;

substep "Set Desktop as the default location for new Finder windows"
defaults write com.apple.finder NewWindowTarget -string "PfDe"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Desktop/";

substep "Remove Guest from Boot Menu"
sudo fdesetup remove -user Guest
sudo defaults write /Library/Preferences/com.apple.loginwindow GuestEnabled -bool NO;
sudo defaults write /Library/Preferences/SystemConfiguration/com.apple.smb.server AllowGuestAccess -bool NO;
sudo defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool NO;

substep "Deleting Guest user account"
sudo dscl . delete /Users/Guest


bot "Remove unwanted apps"
substep 'Deleting Chess app'
sudo rm -rf /Applications/Chess.app;
substep 'Deleting DVD Player app'
sudo rm -rf /Applications/DVD\ Player.app;
substep 'Deleting Stickies app'
sudo rm -rf /Applications/Stickies.app;
substep 'Deleting Grapher app'
sudo rm -rf /Applications/Grapher.app;

###############################################################################
# Kill affected applications                                                  #
###############################################################################

for app in "Activity Monitor" \
	"Address Book" \
	"Calendar" \
	"cfprefsd" \
	"Contacts" \
	"Dock" \
	"Finder" \
	"Google Chrome Canary" \
	"Google Chrome" \
	"Mail" \
	"Messages" \
	"Opera" \
	"Photos" \
	"Safari" \
	"SizeUp" \
	"Spectacle" \
	"SystemUIServer" \
	"Transmission" \
	"Tweetbot" \
	"Twitter" \
	"iCal"; do
	killall "${app}" &> /dev/null
done