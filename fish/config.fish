if status --is-interactive
    # Theme configuration
    set -g theme_color_scheme zenburn
    set -g theme_display_hostname yes
    set -g theme_show_exit_status yes

    # Shell customization
    set -gx LSCOLORS Gxfxcxdxbxegedabagacad
    set -Ux WEECHAT_HOME $HOME/.config/weechat
    set -Ux ATOM_HOME $HOME/.config/atom
end