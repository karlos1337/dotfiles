# Nushell Environment Config File
#
# version = "0.100.0"

def create_left_prompt [] {
    starship prompt --cmd-duration $env.CMD_DURATION_MS $'--status=($env.LAST_EXIT_CODE)'
}

# Use nushell functions to define your right and left prompt
$env.PROMPT_COMMAND = {|| create_left_prompt }
$env.PROMPT_COMMAND_RIGHT = ""

# The prompt indicators are environmental variables that represent
# the state of the prompt
$env.PROMPT_INDICATOR = {|| "> " }
$env.PROMPT_INDICATOR_VI_INSERT = {|| ": " }
$env.PROMPT_INDICATOR_VI_NORMAL = {|| "> " }
$env.PROMPT_MULTILINE_INDICATOR = {|| "::: " }

# If you want previously entered commands to have a different prompt from the usual one,
# you can uncomment one or more of the following lines.
# This can be useful if you have a 2-line prompt and it's taking up a lot of space
# because every command entered takes up 2 lines instead of 1. You can then uncomment
# the line below so that previously entered commands show with a single `🚀`.
# $env.TRANSIENT_PROMPT_COMMAND = {|| "🚀 " }
# $env.TRANSIENT_PROMPT_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_INSERT = {|| "" }
# $env.TRANSIENT_PROMPT_INDICATOR_VI_NORMAL = {|| "" }
# $env.TRANSIENT_PROMPT_MULTILINE_INDICATOR = {|| "" }
# $env.TRANSIENT_PROMPT_COMMAND_RIGHT = {|| "" }

# Specifies how environment variables are:
# - converted from a string to a value on Nushell startup (from_string)
# - converted from a value back to a string when running external commands (to_string)
# Note: The conversions happen *after* config.nu is loaded
$env.ENV_CONVERSIONS = {
    "PATH": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
    "Path": {
        from_string: { |s| $s | split row (char esep) | path expand --no-symlink }
        to_string: { |v| $v | path expand --no-symlink | str join (char esep) }
    }
}

# Directories to search for scripts when calling source or use
# The default for this is $nu.default-config-dir/scripts
$env.NU_LIB_DIRS = [
    ($nu.default-config-dir | path join 'scripts') # add <nushell-config-dir>/scripts
    ($nu.data-dir | path join 'completions') # default home for nushell completions
]

# Directories to search for plugin binaries when calling register
# The default for this is $nu.default-config-dir/plugins
$env.NU_PLUGIN_DIRS = [
    ($nu.default-config-dir | path join 'plugins') # add <nushell-config-dir>/plugins
]

# To add entries to PATH (on Windows you might use Path), you can use the following pattern:
# $env.PATH = ($env.PATH | split row (char esep) | prepend '/some/path')
# An alternate way to add entries to $env.PATH is to use the custom command `path add`
# which is built into the nushell stdlib:
# use std "path add"
# $env.PATH = ($env.PATH | split row (char esep))
# path add /some/path
# path add ($env.CARGO_HOME | path join "bin")
# path add ($env.HOME | path join ".local" "bin")
# $env.PATH = ($env.PATH | uniq)

# To load from a custom file you can use:
# source ($nu.default-config-dir | path join 'custom.nu')

# System
$env.EDITOR = "hx"
$env.VISUAL = "hx"

# OS detection (cached once per session)
let is_linux = (sys host | get name) == "Linux"

# Docker
if $is_linux {
    # Docker rootless (Linux)
    if ($env | get -o XDG_RUNTIME_DIR) != null {
        $env.DOCKER_HOST = $"unix://($env.XDG_RUNTIME_DIR)/docker.sock"
    }
} else {
    # Docker Desktop (macOS) — socket at ~/.docker/run/docker.sock
    let docker_sock = ($env.HOME | path join ".docker/run/docker.sock")
    if ($docker_sock | path exists) {
        $env.DOCKER_HOST = $"unix://($docker_sock)"
    }
}

# JAVA
if $is_linux {
    $env.JAVA_HOME = "/usr/lib/jvm/java-1.17.0-openjdk-amd64"
} else {
    # macOS: try Homebrew JDK, fall back to /usr/libexec/java_home
    let brew_java = "/opt/homebrew/opt/openjdk/libexec/openjdk.jdk/Contents/Home"
    if ($brew_java | path exists) {
        $env.JAVA_HOME = $brew_java
    } else {
        # Use java_home tool if available
        let java_home = (which java_home | get -o path | first)
        if $java_home != null {
            $env.JAVA_HOME = (^java_home 2>/dev/null | str trim)
        }
    }
}

# PATH
$env.PATH = ($env.PATH | split row (char esep) | append "/usr/local/bin" | append "~/.local/bin" | prepend ($env.HOME | path join ".local/share/mise/shims"))
if ($env | get -o JAVA_HOME) != null and ($env.JAVA_HOME | str length) > 0 {
    $env.PATH = ($env.PATH | append $env.JAVA_HOME)
}

## mise
let mise_path = $nu.default-config-dir | path join mise.nu
^mise activate nu | save $mise_path --force

# Carapace config
$env.CARAPACE_BRIDGES = 'zsh,fish,bash,intellisense'
mkdir ~/.cache/carapace
carapace _carapace nushell | save --force ~/.cache/carapace/init.nu

# Starship config
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# # SSH config
# if ($env | get -o XDG_RUNTIME_DIR) != null {
#     $env.SSH_AUTH_SOCK = $"($env.XDG_RUNTIME_DIR)/ssh-agent.socket"
# }

# Android config
if $is_linux {
    $env.ANDROID_HOME = ($env.HOME + "/Android/Sdk")
    $env.ANDROID_SDK_ROOT = ($env.HOME + "/Android/Sdk")
} else {
    # macOS default SDK location
    $env.ANDROID_HOME = ($env.HOME + "/Library/Android/sdk")
    $env.ANDROID_SDK_ROOT = ($env.HOME + "/Library/Android/sdk")
}
$env.ANDROID_AVD_HOME = ($env.HOME + "/.android/avd")
$env.PATH = ($env.PATH | split row (char esep) | append [
    ($env.ANDROID_HOME | path join "platform-tools")
    ($env.ANDROID_HOME | path join "tools")
    ($env.ANDROID_HOME | path join "tools/bin") 
    ($env.ANDROID_HOME | path join "emulator")
])

## api-keys
$env.DEEPSEEK_API_KEY = (open ~/.api-keys/deepseek-api | str trim)
$env.GROQ_API_KEY = (open ~/.api-keys/groq-api | str trim)
$env.TAVILY_API_KEY = (open ~/.api-keys/tavily-api | str trim)
$env.CONTEXT7_API_KEY = (open ~/.api-keys/context7-api | str trim)
$env.Z_AI_API_KEY = (open ~/.api-keys/zai-api | str trim)
$env.STITCH_API_KEY = (open ~/.api-keys/stitch-api | str trim)

## bun
$env.BUN_DIR = ($env.HOME + "/.bun")
$env.PATH = ($env.PATH | split row (char esep) | append ($env.BUN_DIR | path join "bin") )

## zoxide
zoxide init --cmd cd nushell | save -f ~/.zoxide.nu


## yazi
def --env y [...args] {
	let tmp = (mktemp -t "yazi-cwd.XXXXXX")
	yazi ...$args --cwd-file $tmp
	let cwd = (open $tmp)
	if $cwd != "" and $cwd != $env.PWD {
		cd $cwd
	}
	rm -fp $tmp
}

## Restore last directory
let last_dir_file = ($env.HOME | path join ".cache" "nushell_last_dir")
if ($last_dir_file | path exists) {
    let last_dir = (open $last_dir_file | str trim)
    if ($last_dir | path exists) and ($last_dir != $env.PWD) {
        cd $last_dir
    }
}
