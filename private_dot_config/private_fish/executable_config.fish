set -a  PATH                ~/.local/bin
set -a  PATH                ~/.nimble/bin
set -a  PATH                ~/.yarn/bin
set -a  PATH                ~/.cargo/bin
set -a  PATH                /usr/lib/jvm/default/bin
set     XDG_CONFIG_HOME     ~/.config
set     XDG_USER_CONFIG_DIR ~/.config
set     JAVA_HOME           /usr/lib/jvm/default
set -gx CLASSPATH           /usr/share/java/antlr-complete.jar
set     BOOT_JVM_OPTIONS    "--add-modules java.xml.bind"
set -gx CARP_DIR ~/.carp
set     VISUAL              nvim

alias vim="nvim"
alias vi="nvim"
alias ed="nvim"
alias edc="nvim ~/.config/nvim/fnl/magic/*"
alias li="brightnessctl s 100"
alias p="proxychains"
alias pa="paru"
alias ppa="proxychains paru"
alias ch="chezmoi"
alias rm="rm -i"

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
