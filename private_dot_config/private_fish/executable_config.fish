fish_vi_key_bindings

set -gxa PATH                ~/.local/bin
set -gxa PATH                ~/.nimble/bin
set -gxa PATH                ~/.yarn/bin
set -gxa PATH                ~/.cargo/bin
set -gxa PATH                /usr/lib/jvm/default/bin
set -gx  XDG_CONFIG_HOME     ~/.config
set -gx  XDG_USER_CONFIG_DIR ~/.config
#set -gx  JAVA_HOME           /usr/lib/jvm/default
#set -gx  CLASSPATH           /usr/share/java/antlr-complete.jar
#set -gx  BOOT_JVM_OPTIONS    "--add-modules java.xml.bind"
#set -gx  CARP_DIR ~/.carp
set -gx  VISUAL              nvim
set -gx  EDITOR              nvim

for i in (luarocks path | awk '{sub(/PATH=/, "PATH ", $2); print "set -gx "$2}')
    eval $i
end

# Editor

alias e="nvim"
alias en="nvim -u NONE"
alias er="sudoedit"

function ec
    echo "cd ~/.config/nvim/; and nvim init.lua lua/*.lua " | fish /dev/stdin
end

function ef
    echo "cd ~/.config/fish; and nvim config.fish" | fish /dev/stdin
end

function es
    echo "cd ~/.config/sway; and nvim config" | fish /dev/stdin
end

# rerun
function rr
  set PREV_CMD (history | head -1)
  set PREV_OUTPUT (eval $PREV_CMD)
  set CMD $argv[1]
  echo "Running '$CMD $PREV_OUTPUT'"
  eval "$CMD $PREV_OUTPUT"
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
alias p="proxychains"
alias pg="proxychains git"
alias pa="proxychains paru"
alias a="paru"
alias h="chezmoi"
alias rm="trash-put"

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

function bind_bang
    switch (commandline -t)[-1]
        case "!"
            commandline -t $history[1]; commandline -f repaint
        case "*"
            commandline -i !
    end
end

function bind_dollar
    switch (commandline -t)[-1]
        case "!"
            commandline -t ""
            commandline -f history-token-search-backward
        case "*"
            commandline -i '$'
    end
end

bind . 'expand-dot-to-parent-directory-path'
bind ! bind_bang
bind '$' bind_dollar
