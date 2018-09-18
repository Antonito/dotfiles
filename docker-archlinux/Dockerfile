FROM base/devel:latest

# Setting WORKDIR and USER
ENV HOME /root
USER root
WORKDIR /root

#
# -- Installations --
#

# Update system and packages
RUN pacman -Syyu --noconfirm

# Install shell and system utilities
RUN pacman -S --noconfirm git           && \
    pacman -S --noconfirm fish          && \
    curl -Lo ~/.config/fish/functions/fisher.fish --create-dirs https://git.io/fisher && \
    curl -L https://get.oh-my.fish > /tmp/omf.fish && /usr/bin/fish -c "fish /tmp/omf.fish --noninteractive"

# Install C/C++ dev tools
RUN pacman -S --noconfirm valgrind      && \
    pacman -S --noconfirm cmake         && \
    pacman -S --noconfirm clang

# Install python dev tools
RUN pacman -S --noconfirm python        && \
    pacman -S --noconfirm python2       && \
    pacman -S --noconfirm python-pip    && \
    pacman -S --noconfirm python-virtualenv

# Install Go dev tools
RUN pacman -S --noconfirm go            && \
    pacman -S --noconfirm go-tools

# Install NodeJS dev tools
RUN pacman -S --noconfirm nodejs        && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash && \
    /usr/bin/fish -c "fisher FabioAntunes/fish-nvm"

#
# -- Setup --
#

# Setup shell
RUN /usr/bin/fish -c "omf install bobthefish"
COPY config.fish $HOME/.config/fish/config.fish

# Setup Go environment
# TODO: Use host Go folder
# TODO: Allow cross-compilation
RUN mkdir -p $HOME/go/src
ENV GOPATH $HOME/go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH


# Cleanup
RUN rm -rf /tmp/* /var/tmp/*

# Start the machine
CMD [ "/bin/fish" ]