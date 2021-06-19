set XDG_CONFIG_HOME          ~/.config

set -a PATH ~/.local/bin
set -a PATH ~/.nimble/bin
#set -a PATH ~/.luarocks
set -a PATH ~/.yarn/bin
set -a PATH ~/.cargo/bin
#set -a PATH ~/.carp/bin

#set -gx CARP_DIR ~/.carp/

set CHROMIUM_USER_FLAGS "--enable-features=UseOzonePlatform --ozone-platform=wayland"

# for i in (luarocks path | awk '{sub(/PATH=/, "PATH ", $2); print "set -gx "$2}'); eval $i; end
# set WAYLAND_DISPLAY "wayland-0"

set XDG_USER_CONFIG_DIR ~/.config

alias ed="nvim"
alias li="brightnessctl s 100"
alias p="proxychains"
alias pa="paru"
alias ppa="proxychains paru"
alias ch="chezmoi"
alias lr="lein repl"
alias rm="rm -i"
#alias carp="env CARP_DIR=/home/lyh/.carp carp"

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
