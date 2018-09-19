# Update brew repo, upgrade brew packages,
# upgrade brew cask packages, update App Store apps
# proceed clean-up 
function check-update
    brew update && brew upgrade     && \
    brew cask upgrade               && \
    mas upgrade                     && \
    brew cask cleanup && brew cleanup
end
