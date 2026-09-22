let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}
let completer = {|spans|
    let expanded = scope aliases
    | where name == $spans.0
    | get -o 0.expansion
    let spans = if $expanded != null {
        $spans
        | skip 1
        | prepend ($expanded | split row ' ' | take 1)
    } else {
        $spans
    }
    match $spans.0 {
        _ => $carapace_completer
    } | do $in $spans
}

$env.config.history.path = $"($env.HOME)/.config/nushell/history.txt"

$env.config.completions.external = {
    enable: true
    max_results: 128
    completer: $completer
}

const astrox = '/flakes/Astrox'

def --wrapped sudo [ ...commands ]: nothing -> nothing {
    ^sudo -u ("root") nu --stdin --commands (echo $commands | flatten | str join ' ')
}
def --wrapped eval [ ...commands ]: nothing -> nothing {
    ^sudo -u (whoami) nu --stdin --commands (echo $commands | flatten | str join ' ')
}

# Update the `flake.nix` file in the given directory.
def --wrapped fu [
    flake: string = $astrox # A directory with `flake.nix`
    ...args
]: nothing -> nothing {
    try {
        ^sudo -v
    } catch {
        return (print '>>> Interrupted.')
    }
    print $">>> nix flake update --flake ($flake) (echo $args | flatten | str join ' ')"
    eval        nix flake update --flake ($flake) (echo $args | flatten | str join ' ')
    print  '>>> Done.'
}

# Rebuild NixOS with `flake.nix` in the given directory.
def --wrapped rs [
    flake: string = $astrox # A directory with `flake.nix`
    --system(-s)
    --home(-h)
    ...args
]: nothing -> nothing {
    try {
        ^sudo -v
    } catch {
        return (print '>>> Interrupted.')
    }
    ^git -C $flake add .
    if ($system or not $home) {
        print $">>> nixos-rebuild switch --flake ($flake) (echo $args | flatten | str join ' ')"
        sudo        nixos-rebuild switch --flake ($flake) (echo $args | flatten | str join ' ')
        print  '>>> Done.'
    }
    if ($home or not $system) {
        print $">>> home-manager switch --flake ($flake) (echo $args | flatten | str join ' ')"
        eval        home-manager switch --flake ($flake) (echo $args | flatten | str join ' ')
        print  '>>> Done.'
    }
}

def fp [
    flake: string = $astrox
]: nothing -> nothing {
    if (^git -C $flake status --porcelain | is-not-empty) {
        ^git -C $flake add .
        ^git -C $flake commit -m (date now | format date '%F %a %T %z')
    }
    ^git -C $flake push origin main
    print '>>> Done.'
}

# Perform garbage collection for Nix store.
def ngc [
    flake: string = $astrox # A directory with `flake.nix`
]: nothing -> nothing {
    try {
        ^sudo -v
    } catch {
        return (print '>>> Interrupted.')
    }
    print  '>>> nix-collect-garbage -d'
    sudo        nix-collect-garbage -d
    print $">>> nixos-rebuild boot --flake ($flake)"
    sudo        nixos-rebuild boot --flake $flake
    print  '>>> Done.'
}

# Minieap wrapping
def minieap [
    --clear(-c)
    --log(-l)
    --kill(-k)
]: nothing -> nothing {
    try {
        ^sudo -v
    } catch {
        return (print '>>> Interrupted.')
    }
    if ($clear or $log) {
        if ($clear) {
            echo '' | save -f /var/log/minieap.log
        }
        if ($log) {
            open /var/log/minieap.log | print
        }
        return
    }
    if ($kill) {
        sudo minieap -k
    } else {
        sudo minieap
    }
}
