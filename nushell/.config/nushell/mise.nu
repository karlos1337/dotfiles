def "parse vars" [] {
  $in | from csv --noheaders --no-infer | rename 'op' 'name' 'value'
}

def --env "update-env" [] {
  for $var in $in {
    if $var.op == "set" {
      if ($var.name =~ '(?i)^path$') {
        $env.PATH = ($var.value | split row (char esep))
      } else {
        load-env {($var.name): $var.value}
      }
    } else if $var.op == "hide" {
      try { hide-env $var.name }
    }
  }
}
export-env {
  $env.PATH = (r#'/home/carlos/.local/share/mise/shims:/home/carlos/.config/carapace/bin:/home/carlos/.local/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games:/snap/bin:/home/carlos/.maestro/bin:/usr/lib/jvm/java-1.17.0-openjdk-amd64:/home/carlos/Android/Sdk/platform-tools:/home/carlos/Android/Sdk/tools:/home/carlos/Android/Sdk/tools/bin:/home/carlos/Android/Sdk/emulator:/home/carlos/.bun/bin:/home/carlos/.local/bin:/home/carlos/.maestro/bin'# | split row (char esep))

  '' | parse vars | update-env
  $env.MISE_SHELL = "nu"
  let mise_hook = {
    condition: { "MISE_SHELL" in $env }
    code: { mise_hook }
  }
  add-hook hooks.pre_prompt $mise_hook
  add-hook hooks.env_change.PWD $mise_hook
}

def --env add-hook [field: cell-path new_hook: any] {
  let field = $field | split cell-path | update optional true | into cell-path
  let old_config = $env.config? | default {}
  let old_hooks = $old_config | get $field | default []
  $env.config = ($old_config | upsert $field ($old_hooks ++ [$new_hook]))
}

export def --env --wrapped main [command?: string, --help, ...rest: string] {
  let commands = ["deactivate", "shell", "sh"]

  if ($command == null) {
    ^"/usr/bin/mise"
  } else if ($command == "activate") {
    $env.MISE_SHELL = "nu"
  } else if ($command in $commands) {
    ^"/usr/bin/mise" $command ...$rest
    | parse vars
    | update-env
  } else {
    ^"/usr/bin/mise" $command ...$rest
  }
}

def --env mise_hook [] {
  ^"/usr/bin/mise" hook-env -s nu
    | parse vars
    | update-env
}

