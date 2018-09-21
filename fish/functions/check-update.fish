# Update brew repo, upgrade brew packages,
# upgrade brew cask packages
# proceed clean-up 
# update App Store apps
# update Atom packages
function check-update
    brew update && brew upgrade     ; and \
    brew cask upgrade               ; and \
    brew cask cleanup               ; and \
    brew cleanup                    ; and \
    mas upgrade                     ; and \
    apm update
end
