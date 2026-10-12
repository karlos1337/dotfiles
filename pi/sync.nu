#!/usr/bin/env nu
# Sync pi agent config between ~/.pi/agent (live, what pi reads/writes at runtime)
# and ~/.dotfiles/pi/.pi/agent (the version-controlled canonical copies).
#
# WHY A SYNC SCRIPT INSTEAD OF STOW SYMLINKS
#   pi rewrites `settings.json` atomically (write-to-tmp + rename), and the
#   pi-rtk-optimizer extension does the same for its `config.json`
#   (see node_modules/pi-rtk-optimizer/src/config-store.ts :: saveRtkIntegrationConfig).
#   An atomic rename REPLACES a symlink with a real file, silently breaking the
#   link after the first in-app save. So these files must be real files on both
#   sides and kept in sync by copying — not symlinked.
#
#   Other pi files you only edit by hand (keybindings.json, models.json,
#   AGENTS.md, prompts/, skills/, themes/, hand-written *.ts extensions) are
#   safe to symlink via `stow pi` and are NOT handled here.
#
# USAGE
#   nu ~/.dotfiles/pi/sync.nu pull    # live  -> dotfiles  (save current state)
#   nu ~/.dotfiles/pi/sync.nu push    # dotfiles -> live   (restore on new machine)
#   nu ~/.dotfiles/pi/sync.nu diff    # show differences (no writes)
#   nu ~/.dotfiles/pi/sync.nu status  # one-line summary, which side is newer
#
# Add new mutable configs by extending `files` below.

# Files (relative to the agent root) that pi or its extensions rewrite at runtime.
const files = [
    "settings.json",
    "extensions/pi-rtk-optimizer/config.json",
]

# Live root pi reads from. Honor PI_AGENT_HOME if set, else default ~/.pi/agent.
def live-root [] {
    if ($env.PI_AGENT_HOME? | is-not-empty) { $env.PI_AGENT_HOME } else { $env.HOME | path join ".pi" "agent" }
}

# Canonical version-controlled root. Resolved from this script's location so it
# works regardless of cwd: <repo>/pi/.pi/agent
def canonical-root [] {
    $env.FILE_PWD | path join ".pi" "agent"
}

def pairs [] {
    let live = (live-root)
    let canon = (canonical-root)
    $files | each { |f| { rel: $f, live: ($live | path join $f), canon: ($canon | path join $f) } }
}

def mtime-if-exists [p: path] {
    if ($p | path exists) { (ls -l $p | first).modified } else { null }
}

# `status`: for each file, report which side is newer (or missing).
# Falls back to a content check when mtimes differ, so a stale mtime never
# produces a misleading "newer" verdict.
def "main status" [] {
    pairs | each { |x|
        let lm = (mtime-if-exists $x.live)
        let cm = (mtime-if-exists $x.canon)
        let base = (
            if $lm == null and $cm == null { "missing-both" }
            else if $lm == null { "live-missing (push to restore)" }
            else if $cm == null { "dotfiles-missing (pull to save)" }
            else { null }  # both exist; resolve below
        )
        let dir = (if $base != null {
            $base
        } else if (open -r $x.live) == (open -r $x.canon) {
            "in-sync"
        } else if ($lm | into datetime) > ($cm | into datetime) {
            "live-newer (pull to save)"
        } else {
            "dotfiles-newer (push to restore)"
        })
        { file: $x.rel, status: $dir, live: $lm, dotfiles: $cm }
    } | table
}

# `pull`: copy live -> dotfiles (save pi's current state into version control).
def "main pull" [] {
    pairs | each { |x|
        if not ($x.live | path exists) {
            $"(ansi yellow)skip(ansi reset)  ($x.rel): live file missing"
        } else {
            mkdir ($x.canon | path dirname)
            cp -f $x.live $x.canon
            $"(ansi green)pulled(ansi reset) ($x.rel)"
        }
    } | print
}

# `push`: copy dotfiles -> live (restore canonical state onto this machine).
def "main push" [] {
    pairs | each { |x|
        if not ($x.canon | path exists) {
            $"(ansi yellow)skip(ansi reset)  ($x.rel): dotfiles copy missing"
        } else {
            mkdir ($x.live | path dirname)
            cp -f $x.canon $x.live
            $"(ansi green)pushed(ansi reset) ($x.rel)"
        }
    } | print
}

# `diff`: show content differences between live and dotfiles, no writes.
def "main diff" [] {
    pairs | each { |x|
        let both = ($x.live | path exists) and ($x.canon | path exists)
        if not $both {
            print $"(ansi yellow)— one side missing: ($x.rel)(ansi reset)"
        } else if (open -r $x.live) == (open -r $x.canon) {
            print $"(ansi default_dimmed)== identical: ($x.rel)(ansi reset)"
        } else {
            # `diff -u` exits 1 when files differ. Use `complete` to capture
            # stdout without aborting on non-zero exit.
            let d = (do { diff -u $x.live $x.canon } | complete)
            print $"(ansi cyan)~~ ($x.rel)(ansi reset)\n($d.stdout)\n"
        }
    } | ignore
}

def main [] { main status }
