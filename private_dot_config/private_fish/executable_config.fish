set -a PATH ~/.local/bin
set -a PATH ~/.nimble/bin
set -a PATH ~/.luarocks
for i in (luarocks path | awk '{sub(/PATH=/, "PATH ", $2); print "set -gx "$2}'); eval $i; end

set XDG_USER_CONFIG_DIR ~/.config

alias ed="nvim"
alias li="light -S 40"
alias p="proxychains"
alias pa="paru"
alias ppa="proxychains paru"
alias ch="chezmoi"
alias lr="lein repl"

function expand-dot-to-parent-directory-path -d 'expand ... to ../.. etc'
    # Get commandline up to cursor
    set -l cmd (commandline --cut-at-cursor)

    # Match last line
    switch $cmd[-1]
        case '*..'
            commandline --insert '/..'
        case '*'
            commandline --insert '.'
    end
end

bind . 'expand-dot-to-parent-directory-path'
