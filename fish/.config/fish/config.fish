if status is-interactive
    # Commands to run in interactive sessions can go here
    set -lx SHELL fish
    eval $(keychain --eval --quiet)
end
starship init fish | source
