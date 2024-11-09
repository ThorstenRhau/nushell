use ~/.cache/starship/init.nu

source ~/.cache/carapace/init.nu
source ~/.cache/zoxide/init.nu

source ~/.nushell_secrets

alias nv = nvim
alias gst = git status
alias gl = git pull
alias gp = git push
alias glog = git log --oneline --graph --decorate
alias gca = git commit -a
alias python = python3
alias pip = pip3

alias trhau = with-env {TERM: xterm-256color} {
    mosh --ssh="ssh -C -p 9898" thorre@helio.home -- tmux -2 attach
}

alias srhau = with-env {TERM: xterm-256color} {
    ssh -C -p 9898 -t thorre@helio.home tmux -2 attach
    or
    ssh -C -p 9898 -t thorre@helio.home tmux -2 -u new
}

alias ssh = with-env {TERM: xterm-256color} {
    ssh
}

let fish_completer = {|spans|
    fish --command $'complete "--do-complete=($spans | str join " ")"'
    | $"value(char tab)description(char newline)" + $in
    | from tsv --flexible --no-infer
}

let carapace_completer = {|spans: list<string>|
    carapace $spans.0 nushell ...$spans
    | from json
    | if ($in | default [] | where value =~ '^-.*ERR$' | is-empty) { $in } else { null }
}

let zoxide_completer = {|spans|
    $spans | skip 1 | zoxide query -l ...$in | lines | where {|x| $x != $env.PWD}
}

let external_completer = {|spans|
    let expanded_alias = scope aliases
    | where name == $spans.0
    | get -i 0.expansion

    let spans = if $expanded_alias != null {
        $spans
        | skip 1
        | prepend ($expanded_alias | split row ' ' | take 1)
    } else {
        $spans
    }
    match $spans.0 {
    # carapace completions are incorrect for nu
    nu => $fish_completer
    # fish completes commits and branch names in a nicer way
    git => $fish_completer
    # carapace doesn't have completions for asdf
    asdf => $fish_completer
    # use zoxide completions for zoxide commands
    __zoxide_z | __zoxide_zi => $zoxide_completer
    _ => $carapace_completer
} | do $in $spans
}

$env.config = {
    show_banner: false
    ls: {
        use_ls_colors: true
        clickable_links: true
    }
    rm: {
        always_trash: false
    }
    table: {
        mode: rounded
        index_mode: auto
        trim: {
            methodology: wrapping
            wrapping_try_keep_words: true
        }
    }
    history: {
        max_size: 10000
        sync_on_enter: true
        file_format: "sqlite"
    }
    completions: {
        case_sensitive: false
        quick: true
        partial: false
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 100
            completer: $external_completer
        }
    }
    keybindings: [
        {
            name: zoxide_jump
            modifier: control
            keycode: char_z
            mode: [emacs vi_normal vi_insert]
            event: {
                send: executehostcommand
                cmd: "zi"
            }
        }
        {
            name: fuzzy_history
            modifier: control
            keycode: char_r
            mode: [emacs, vi_normal, vi_insert]
            event: { send: executehostcommand, cmd: "fuzzy_history" }
        }
    ]
}






