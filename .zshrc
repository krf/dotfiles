# Exports
export EDITOR="vim" # Set default editor
export LANGUAGE=C # Console messages in english please
export PYTHONSTARTUP="$HOME/.pythonrc"
export KDE_COLOR_DEBUG=1
export HAVE_BUSYBOX=$( (cat --help  | grep -qv BusyBox) >/dev/null 2>&1; echo $? )

# Exports (development)
export VALGRIND_OPTS="\
    --suppressions=$HOME/.valgrind/default.supp \
    --suppressions=$HOME/.valgrind/other.supp \
    --suppressions=$HOME/.valgrind/generated.supp"
export ASAN_OPTIONS=suppressions=$HOME/.asan.supp

# Exports: Set QT_MESSAGE_PATTERN
c=`echo -e "\033"`
export QT_MESSAGE_PATTERN_DEFAULT="[%{appname}(%{pid})/(%{category}) ${c}[31m%{if-debug}${c}[34m%{endif}%{function}(%{line})${c}[0m: %{message}"
export QT_MESSAGE_PATTERN_WITH_TIMING="[%{time yyyyMMdd h:mm:ss.zzz t}] %{appname}(%{pid})/(%{category}) ${c}[31m%{if-debug}${c}[34m%{endif}%{function}${c}[0m: %{message}"
unset c
export QT_MESSAGE_PATTERN="$QT_MESSAGE_PATTERN_DEFAULT"
export QT_LOGGING_CONF="$HOME/.qtlogging.ini"

# Aliases (shortcuts)
alias chmox="chmod +x"
alias cp='nocorrect cp' # ~ on cp
alias dmesg='dmesg -T'
alias mv='nocorrect mv' # no spelling correction on mv
test -x /usr/bin/most && alias man='man -P most'
alias mkdir='nocorrect mkdir' # ~ on on mkdir
alias pu=pushd
alias po=popd
alias d='dirs -v'
alias ducks='du -cks * | sort -rn | head'
alias h=history
alias help=run-help
if [ "$HAVE_BUSYBOX" = "0" ]; then alias grep='grep --color=auto'; fi
alias igrep='grep -i'
test -x /usr/share/vim/vimcurrent/macros/less.sh && alias less='/usr/share/vim/vimcurrent/macros/less.sh'
test -x /usr/share/vim/vim74/macros/less.sh && alias less='/usr/share/vim/vim74/macros/less.sh'
alias ll='ls -l'
alias la='ls -al'
if [ "$HAVE_BUSYBOX" = "0" ]; then alias ls='ls --color=auto'; fi
alias netcat='nc'
alias nowrap='cut -c1-$COLUMNS' # example: 'grep foo file | nowrap'
alias fnd="find . -iname"
function f() { fnd "*$1*" }
alias ..='cd ..'
if mount | grep "on / " | grep btrfs &>/dev/null; then alias -g aptitude='eatmydata aptitude'; fi
alias api='sudo apt-get install'
alias apr='sudo apt-get remove'
alias app='sudo apt-get remove --purge'
alias aps='apt-cache search'
alias apu='sudo apt-get update; sudo apt-get dist-upgrade'
alias apt-keyadv='sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com'
alias bt='echo 0 | gdb -batch-silent -ex "run" -ex "set logging overwrite on" -ex "set logging file gdb.bt" -ex "set logging on" -ex "set pagination off" -ex "handle SIG33 pass nostop noprint" -ex "echo backtrace:\n" -ex "backtrace full" -ex "echo \n\nregisters:\n" -ex "info registers" -ex "echo \n\ncurrent instructions:\n" -ex "x/16i \$pc" -ex "echo \n\nthreads backtrace:\n" -ex "thread apply all backtrace" -ex "set logging off" -ex "quit" --args'
alias psg='ps aux | grep'
alias notify-done='notify-send -t 3600000 Done'

# Alias for pandoc
alias pandoc.pdf="pandoc -s -V geometry:margin=1in -V documentclass:article"

# Aliases (make tools in /sbin available)
if [ -x /sbin/ifconfig ]; then alias ifconfig='/sbin/ifconfig'; fi

# Aliases (convenience)
alias remove-spaces='find . -depth | rename "s/\ /_/g"' # with subdirs!
alias whatismyip="wget -qO- checkip.dyndns.org | grep -Eo '[0-9\.]+' | xargs -I{} sh -c 'echo \"IP: {}\"; echo \"Name: \$(dig -x {} +short)\"'"
alias bandwidth-test="wget http://old-releases.ubuntu.com/releases/karmic/ubuntu-9.10-desktop-amd64.iso --output-document=/dev/null"

# Aliases (Vim)
alias ctags-c++='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'

# Aliases (Profiling)
alias valgrind-callgrind='valgrind --tool=callgrind --fn-skip="QMetaObject::activate*" --fn-skip="QMetaObject::metacall*" --fn-skip="*::qt_metacall*" --fn-skip="*::qt_static_metacall*"'

# Alias for quickly compiling Qt-related source file
alias g++-qt5='g++ -fPIC -I/usr/include/x86_64-linux-gnu/qt5/ -I/usr/include/x86_64-linux-gnu/qt5/QtCore -lQt5Core'

# Functions
# NAME: mkcd - mkdir and cd into it
# SYNOPSIS: mkcd DIRECTORY
function mkcd() {
    [ -n "$1" ] && mkdir -p "$@" && cd "$1";
}

# Functions (development)
# NAME: env-devel - Set up development environment
# SYNOPSIS: env-devel [ENV]
# OPTIONS:
#   ENV: E.g. 'master' or 'stable', sets the installation directory. Defaults to 'master'
function env-devel() {
    cd ~/devel/src
    BUILDNAME="$1" source ~/.bashrc_devel
}

alias kdesrc-build-rel='kdesrc-build --rc-file=$HOME/.kdesrc-buildrc-rel'

# History settings
HISTSIZE=10000 # Set command search history
HISTFILE=~/.zsh_history
SAVEHIST=100

# Override keymap selection
bindkey -e

## Fix key bindings
bindkey "\e[1~" beginning-of-line
bindkey "\e[4~" end-of-line
bindkey "\e[5~" beginning-of-history
bindkey "\e[6~" end-of-history
bindkey "\e[3~" delete-char
bindkey "\e[2~" quoted-insert
bindkey "\e[5C" forward-word
bindkey "\eOc" emacs-forward-word
bindkey "\e[5D" backward-word
bindkey "\eOd" emacs-backward-word
bindkey "\e\e[C" forward-word
bindkey "\e\e[D" backward-word
bindkey "^H" backward-delete-word
# for rxvt
bindkey "\e[8~" end-of-line
bindkey "\e[7~" beginning-of-line
# for non RH/Debian xterm, can't hurt for RH/DEbian xterm
bindkey "\eOH" beginning-of-line
bindkey "\eOF" end-of-line
# for freebsd console
bindkey "\e[H" beginning-of-line
bindkey "\e[F" end-of-line
# completion in the middle of a line
bindkey '^i' expand-or-complete-prefix
##

# Private sources
if [ -f "$HOME/.zshrc-private" ]; then
    source ~/.zshrc-private
fi

# Other sources
if [ -f "/etc/zsh_command_not_found" ]; then
    source /etc/zsh_command_not_found
fi

PATH="$HOME/bin:$PATH"

# Load autojump
if [ -f "/usr/share/autojump/autojump.zsh" ]; then
    source /usr/share/autojump/autojump.zsh
fi

# Load functions from .zsh/func
fpath=($fpath $HOME/.zsh/func)
autoload -U $HOME/.zsh/func/*(:t)

# Enable auto-execution of functions.
typeset -ga preexec_functions
typeset -ga precmd_functions
typeset -ga chpwd_functions

# Append git functions needed for prompt.
preexec_functions+='preexec_update_git_vars.sh'
precmd_functions+='precmd_update_git_vars.sh'
chpwd_functions+='chpwd_update_git_vars.sh'

# Enable shared history, see http://superuser.com/questions/519596/share-history-in-multiple-zsh-shell
setopt share_history

# Configure prompt
autoload colors zsh/terminfo
colors
autoload -U promptinit
promptinit
setopt promptsubst

# Set prompt
local returncode="%{$fg[red]%}-%?-%{$reset_color%}"
local gitprompt=$'%{${fg[yellow]}%}%B$(prompt_git_info.sh)%b%{${fg[default]}%}'

PROMPT="[%{$terminfo[bold]$fg[cyan]%}%n%{${reset_color}%}\
@%{$fg[cyan]%}%m%{${reset_color}%}\
 %{$fg[yellow]%}%(4c.%1c.%~)%{${reset_color}%}\
 %{$fg[green]%}"'$(LANGUAGE=C ls -lah | grep total | tr -d total\ )'"%{${reset_color}%}\
%(?,, ${returncode})%{${reset_color}%}\
]%{$fg[white]%}%B%#%b%{${reset_color}%} "
RPROMPT="%{$fg[white]%}${gitprompt} %T%{${reset_color}%}" # prompt for right side of screen

# Emulate tcsh's backward-delete-word
local WORDCHARS="${WORDCHARS:s#/#}"

# Autoload scripts in .zsh.d
setopt extended_glob
for zshrc_snipplet in ~/.zsh.d/S[0-9][0-9]*[^~] ; do
    source $zshrc_snipplet
done

# Modules
zmodload zsh/mathfunc

# Completion Styles

# list of completers to use
#zstyle ':completion:*::::' completer _expand _complete _ignored _approximate

# allow one error for every three characters typed in approximate completer
zstyle -e ':completion:*:approximate:*' max-errors \
    'reply=( $(( ($#PREFIX+$#SUFFIX)/3 )) numeric )'

# insert all expansions for expand completer
#zstyle ':completion:*:expand:*' tag-order all-expansions

# formatting and messages
#zstyle ':completion:*' verbose yes
zstyle ':completion:*:descriptions' format '%B%d%b'
zstyle ':completion:*:messages' format '%d'
#zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'
#zstyle ':completion:*' group-name ''

# match uppercase from lowercase
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'

# offer indexes before parameters in subscripts
#zstyle ':completion:*:*:-subscript-:*' tag-order indexes parameters

# command for the local web server details and host completion
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# command completion for 'kill', 'killall', 'pkill', etc.
zstyle ':completion:*:processes-names' command 'ps -e -o comm='
zstyle ':completion:*:processes' command 'ps -au$USER'
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;32'

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'

# trigger chpwd functions
cd $PWD

# 'thefuck' hook -- see https://github.com/nvbn/thefuck
if hash thefuck 2> /dev/null; then
    eval "$(thefuck --alias)"
fi

# linuxbrew

export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
