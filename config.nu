use ~/.cache/starship/init.nu

source ~/.cache/carapace/init.nu
source ~/.cache/zoxide/init.nu

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

$env.config = {
    show_banner: false
    ls: {
        use_ls_colors: false
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
        quick: false
        partial: true
        algorithm: "fuzzy"
        external: {
            enable: true
            max_results: 100
        }
    }
}

