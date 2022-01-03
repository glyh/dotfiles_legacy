fish_vi_key_bindings

# Editor

alias e="nvim"
alias en="nvim -u NONE"
alias er="sudoedit"

function ec
    echo "cd ~/.config/nvim/; and nvim init.lua" | fish /dev/stdin
end

function ef
    echo "cd ~/.config/fish; and nvim config.fish" | fish /dev/stdin
end

function es
    echo "cd ~/.config/sway; and nvim config" | fish /dev/stdin
end

function f
  ranger --choosedir=$HOME/.rangerdir
  set LASTDIR (cat $HOME/.rangerdir)
  cd $LASTDIR
end

alias g="git"
alias l="ls"
alias c="cd"
alias i="sudo light"
alias i100 "sudo light -S 100"
alias p="proxychains"
alias pg="proxychains git"
alias pa="proxychains paru"
alias a="paru"
alias ch="chezmoi"
alias rm="rm -i"
alias tp="trash-put"
alias tl="trash-list"
alias te="trash-empty"
alias rt="trash-restore"
alias nb="nimble"
alias janet="janet -m ~/.local/lib/janet/lib/"
alias jpm="jpm --tree=janet"

#alias ccljs="create-cljs-project"
#alias cljs="shadow-cljs"

#alias xournalpp="GTK_THEME=Adwaita:dark xournalpp"
