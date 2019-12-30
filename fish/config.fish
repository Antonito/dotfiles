if status --is-interactive
    # Theme configuration
    set -g theme_color_scheme zenburn
    set -g theme_display_hostname yes
    set -g theme_show_exit_status yes

    # Shell customization
    set -gx LSCOLORS Gxfxcxdxbxegedabagacad

    # Rust setup
    set -gx CARGO_HOME $HOME/.config/.cargo
    set -gx RUSTUP_HOME $HOME/.config/.rustup

    set -gx PATH $CARGO_HOME/bin $PATH

    set -Ux LANG en_US.UTF-8
    set -Ux LC_ALL en_US.UTF-8
end
