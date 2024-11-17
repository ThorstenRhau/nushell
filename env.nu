$env.STARSHIP_SHELL = "nu"
$env.CARAPACE_BRIDGES = 'zsh,fish,bash'
$env.TERM = "wezterm"
$env.LANG = "en_US.UTF-8"
$env.LC_ALL = "en_US.UTF-8"

$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend [
        ($env.HOME | path join "bin")
        ($env.HOME | path join ".local/bin")
        ($env.HOME | path join ".rd/bin")
        "/opt/homebrew/bin"
        "/opt/homebrew/sbin"
        "/usr/local/bin"
    ]
    | each { |it| if ($it | path exists) { $it } else { null } }
    | compact
    | uniq
)

$env.EDITOR = "nvim"
$env.HOMEBREW_PREFIX = "/opt/homebrew"
$env.HOMEBREW_NO_ANALYTICS = 1

carapace _carapace nushell | save -f ~/.cache/carapace/init.nu
starship init nu | save -f ~/.cache/starship/init.nu
zoxide init nushell | save -f ~/.cache/zoxide/init.nu

let wezterm_path = "/Applications/WezTerm.app/Contents/MacOS"
if ($wezterm_path | path exists) {
    $env.PATH = ($env.PATH | append $wezterm_path)
}

def get_macos_theme [] {
    let result = (defaults read -g AppleInterfaceStyle | complete)
    if $result.exit_code == 0 and $result.stdout =~ 'Dark' {
        'dark'
    } else {
        'light'
    }
}

let theme = (get_macos_theme)
if $theme == 'dark' {
    $env.LS_COLORS = (vivid generate catppuccin-macchiato)
} else {
    $env.LS_COLORS = (vivid generate catppuccin-latte)
}


def fuzzy_history [
    --query (-q): string # Optional starting query
] {
    let cmd = (
        history 
        | get command 
        | uniq 
        | reverse 
        | str join (char nl) 
        | fzf --scheme=history 
            --height=40% 
            --prompt="CMD HISTORY> "
            --border='rounded'
    )
    commandline edit --insert $cmd
}
