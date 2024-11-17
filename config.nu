use ~/.cache/starship/init.nu

source ~/.cache/carapace/init.nu
source ~/.cache/zoxide/init.nu

source ~/.nushell_secrets.nu
source ~/.nushell_local.nu

def gpristine [] { 
    git reset --hard
    git clean --force -dfx
}

alias nv = nvim
alias gst = git status
alias gl = git pull
alias gp = git push
alias glog = git log --oneline --graph --decorate
alias gca = git commit -a
alias python = python3
alias pip = pip3

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
        partial: true
        algorithm: "fuzzy"
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
