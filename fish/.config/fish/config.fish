if status is-interactive
    # Commands to run in interactive sessions can go here
    set -lx SHELL fish
    eval $(keychain --eval --quiet)
end
starship init fish | source

# pnpm
set -gx PNPM_HOME "/home/carlos/.local/share/pnpm"
if not string match -q -- $PNPM_HOME $PATH
    set -gx PATH "$PNPM_HOME" $PATH
end
# pnpm end

# android
set --export ANDROID_HOME $HOME/Android/Sdk
set --export ANDROID_SDK_ROOT $HOME/Android/Sdk
set --export ANDROID_AVD_HOME $HOME/.android/avd
set -gx PATH "$ANDROID_HOME/platform-tools" "$PATH"
set -gx PATH "$ANDROID_HOME/tools" "$PATH"
set -gx PATH "$ANDROID_HOME/tools/bin" "$PATH"
set -gx PATH "$ANDROID_HOME/emulator" "$PATH"
# android end
