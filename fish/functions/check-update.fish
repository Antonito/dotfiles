# Update brew repo, upgrade brew packages,
# upgrade brew cask packages, update App Store apps
# proceed clean-up 
function check-update
    brew update && brew upgrade     ; and \
    brew cask upgrade               ; and \
    mas upgrade                     ; and \
    brew cask cleanup               ; and \
    brew cleanup
end
