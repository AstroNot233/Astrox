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

# Update the given flake.
def --wrapped uf [
    flake: string = $astrox
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

# Switch to the given flake.
def --wrapped sf [
    flake: string = $astrox
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
    let astr = (echo $args | flatten | str join ' ');
    if ($system or not $home) {
        print $">>> nixos-rebuild switch --flake ($flake) --sudo ($astr)"
        eval        nixos-rebuild switch --flake ($flake) --sudo ($astr)
        print  '>>> Done.'
    }
    if ($home or not $system) {
        print $">>> home-manager switch --flake ($flake) ($astr)"
        eval        home-manager switch --flake ($flake) ($astr)
        print  '>>> Done.'
    }
}

# Push the flake to remote.
def pf [
    flake: string = $astrox
]: nothing -> nothing {
    if (^git -C $flake status --porcelain | is-not-empty) {
        ^git -C $flake add .
        ^git -C $flake commit -m (date now | format date '%F %a %T %z')
    }
    ^git -C $flake push origin main
    print '>>> Done.'
}

# Perform garbage collection for Nix store and cleanup for boot menu.
def gc []: nothing -> nothing {
    try {
        ^sudo -v
    } catch {
        return (print '>>> Interrupted.')
    }
    print  '>>> nix-collect-garbage -d'
    sudo        nix-collect-garbage -d
    print $">>> nixos-rebuild boot --flake ($astrox)"
    sudo        nixos-rebuild boot --flake ($astrox)
    print  '>>> Done.'
}
