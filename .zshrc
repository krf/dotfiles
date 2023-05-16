# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
#ZSH_THEME="essembeh"

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
# zstyle ':omz:update' mode disabled  # disable automatic updates
# zstyle ':omz:update' mode auto      # update automatically without asking
# zstyle ':omz:update' mode reminder  # just remind me to update when it's time

# Uncomment the following line to change how often to auto-update (in days).
# zstyle ':omz:update' frequency 13

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# You can also set it to another string to have that shown instead of the default red dots.
# e.g. COMPLETION_WAITING_DOTS="%F{yellow}waiting...%f"
# Caution: this setting can cause issues with multiline prompts in zsh < 5.7.1 (see #5765)
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load?
# Standard plugins can be found in $ZSH/plugins/
# Custom plugins may be added to $ZSH_CUSTOM/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(ag colorize cp git)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Git stuff
ZSH_THEME_GIT_PROMPT_PREFIX="%{$fg_bold[cyan]%}git:(%{$fg[red]%}"
ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%} "
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[cyan]%}) %{$fg[yellow]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN="%{$fg[cyan]%})"

# Borrowed from strug.zsh-theme
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_DETAILED=true
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_PREFIX="%{$fg[yellow]%}("
ZSH_THEME_GIT_PROMPT_REMOTE_STATUS_SUFFIX="%{$fg[yellow]%})%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE=" +"
ZSH_THEME_GIT_PROMPT_AHEAD_REMOTE_COLOR=%{$fg[green]%}
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE=" -"
ZSH_THEME_GIT_PROMPT_BEHIND_REMOTE_COLOR=%{$fg[red]%}


# Set prompt
local returncode="%{$fg[red]%}-%?-%{$reset_color%}"

PROMPT="[%{$terminfo[bold]$fg[cyan]%}%n%{${reset_color}%}\
@%{$fg[cyan]%}%m%{${reset_color}%}\
 %{$fg[yellow]%}%(4c.%1c.%~)%{${reset_color}%}\
%(?,, ${returncode})%{${reset_color}%} \
%{$fg[green]%}"'$(LANGUAGE=C ls -lah | head -1 | tr -d total\ )'"%{${reset_color}%}\
]%{$fg[white]%}%B%#%b%{${reset_color}%} "
RPROMPT='%{$reset_color%}$(git_prompt_info)$(git describe HEAD 2> /dev/null) $(git_remote_status) %T%{${reset_color}%}' # prompt for right side of screen

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
# new_delete_type_mismatch=0 b/c of hit of said check in e.g. QQmlType::create(...)
export ASAN_OPTIONS=suppressions=$HOME/.asan.supp,new_delete_type_mismatch=0
export UBSAN_OPTIONS=print_stacktrace=1
if [[ "$(uname)" == "Darwin" ]]; then
    export NPROC=$(sysctl -n hw.ncpu)
else
    export NPROC=$(nproc)
fi
export CTEST_PARALLEL_LEVEL=$NPROC
export NINJA_STATUS="[%f/%t %o/sec] "

# Exports: Enable GCC output colorization (cf. https://reversed.top/2015-10-25/enable-colorization-of-gcc-output/)
export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# Exports: Set QT_MESSAGE_PATTERN
# Note: For info about colors: https://misc.flogisoft.com/bash/tip_colors_and_formatting#colors
c=`echo -e "\033"`
export QT_MESSAGE_PATTERN_DEFAULT="\
%{appname}(%{pid})/%{category}: \
${c}[31m\
%{if-info}${c}[94m%{endif}\
%{if-debug}${c}[34m%{endif}\
%{function}(%{line})\
${c}[0m: %{message}\
%{if-warning} @ %{backtrace depth=20}%{endif}\
%{if-critical} @ %{backtrace depth=20}%{endif}\
%{if-fatal} @ %{backtrace depth=20}%{endif}\
${c}[0m\
"
export QT_MESSAGE_PATTERN_NO_COLOR="%{appname}(%{pid})/%{category}: %{if-debug}%{endif}%{function}(%{line}): %{message}"
export QT_MESSAGE_PATTERN_WITH_TIMING="[%{time h:mm:ss.zzz}] ${QT_MESSAGE_PATTERN_DEFAULT}"
unset c
export QT_MESSAGE_PATTERN="$QT_MESSAGE_PATTERN_WITH_TIMING"
export QT_LOGGING_CONF="$HOME/.qtlogging.ini"
export QT_FATAL_WARNINGS=0 # for auto-completion, disabled by default

# Environment variables
# linuxbrew
export PATH="$HOME/.linuxbrew/bin:$PATH"
export MANPATH="$HOME/.linuxbrew/share/man:$MANPATH"
export INFOPATH="$HOME/.linuxbrew/share/info:$INFOPATH"
# Snap
export PATH=$PATH:/snap/bin

# Aliases (shortcuts)
alias chmox="chmod +x"
alias cp='nocorrect cp' # ~ on cp
alias mv='nocorrect mv' # no spelling correction on mv
test -x /usr/bin/most && alias man='man -P most'
alias mkdir='nocorrect mkdir' # ~ on on mkdir
alias n='nice ionice -c 3'
alias pu=pushd
alias po=popd
alias d='dirs -v'
alias ducks='du -cks * | sort -rn | head'
alias find-duplicate-files='find . -type f -name "*.o" -printf '%p/ %f\n' | sort -k2 | uniq -f1 --all-repeated=separate' # https://stackoverflow.com/a/45971199
alias find-biggest-files-and-dirs='du -a . | sort -n -r | head -n 20'
alias h=history
alias help=run-help
if [ "$HAVE_BUSYBOX" = "0" ]; then alias grep='grep --color=auto'; fi
alias igrep='grep -i'
test -x /usr/share/vim/vimcurrent/macros/less.sh && alias less='/usr/share/vim/vimcurrent/macros/less.sh'
test -x /usr/share/vim/vim74/macros/less.sh && alias less='/usr/share/vim/vim74/macros/less.sh'
alias ll='ls -l'
#if hash lsd 2> /dev/null; then
#    alias ll='lsd -l'
#fi
alias la='ls -al'
if [ "$HAVE_BUSYBOX" = "0" ]; then alias ls='ls --color=auto'; fi
alias netcat='nc'
alias nowrap='cut -c1-$COLUMNS' # example: 'grep foo file | nowrap'
alias fnd="find . -iname"
function f() { fnd "*$1*" }
alias ..='cd ..'
if mount | grep "on / " | grep btrfs &>/dev/null; then alias -g aptitude='eatmydata aptitude'; fi
alias api='sudo apt install'
alias apr='sudo apt remove'
alias app='sudo apt purge'
alias aps='apt search'
alias apu='sudo apt update; sudo apt full-upgrade'
alias apt-keyadv='sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com'
alias bt='echo 0 | gdb -batch-silent -ex "run" -ex "set logging overwrite on" -ex "set logging file gdb.bt" -ex "set logging on" -ex "set pagination off" -ex "handle SIG33 pass nostop noprint" -ex "echo backtrace:\n" -ex "backtrace full" -ex "echo \n\nregisters:\n" -ex "info registers" -ex "echo \n\ncurrent instructions:\n" -ex "x/16i \$pc" -ex "echo \n\nthreads backtrace:\n" -ex "thread apply all backtrace" -ex "set logging off" -ex "quit" --args'
alias psg='ps aux | grep'
alias notify-done='notify-send -t 3600000 Done'
#alias ag='ag --hidden -t'
#alias ag='ag --unrestricted'
alias helgrind="QT_NO_GLIB=1 valgrind --tool=helgrind --track-lockorders=no"
alias arc.patch='arc patch --nobranch'
alias sprunge="curl -F 'sprunge=<-' http://sprunge.us"
alias turbostat='sudo turbostat --hide "C1,C1E,C3,C6,C7s,C8,C9,C10,POLL%,CPU%c1,CPU%c3,CPU%c6,CPU%c7,CoreTmp,PkgTmp,GFX%rc6,GFXMHz,Totl%C0,Any%C0,GFX%C0,CPUGFX%,Pkg%pc2,Pkg%pc3,Pkg%pc6,Pkg%pc7,Pkg%pc8,Pkg%pc9,Pk%pc10,PkgWatt,CorWatt,GFXWatt,RAMWatt,PKG_%,RAM_%"' # turbostat really shows way too much info by default...
# Alias for pandoc
#
function pandoc.pdf() {
    # Note: Needs package fonts-dejavu-extra for DejavuSans italic variation
    pandoc -s -V mainfont="DejaVu Sans" -V linkcolor:blue -V geometry:a4paper -V geometry:margin=2cm --pdf-engine=xelatex $1 -o "${1%.*}.pdf" "${@:2}"
}
function pandoc.pdf.eisvogel() {
    # Note: Needs package fonts-dejavu-extra for DejavuSans italic variation
    pandoc -s -V mainfont="DejaVu Sans" -V linkcolor:blue -V geometry:a4paper -V geometry:margin=2cm --pdf-engine=xelatex $1 -o "${1%.*}.pdf" --template eisvogel --toc --toc-depth=2 "${@:2}"
}

# Aliases (make tools in /sbin available)
if [ -x /sbin/ifconfig ]; then alias ifconfig='/sbin/ifconfig'; fi

# Aliases (convenience)
alias remove-spaces='find . -depth | rename "s/\ /_/g"' # with subdirs!
alias pwgen='pwgen -B -y 12'
alias whatismyip='dig @resolver1.opendns.com A myip.opendns.com +short -4'
alias whatismyip6='dig @resolver1.opendns.com AAAA myip.opendns.com +short -6'
alias bandwidth-test="wget http://old-releases.ubuntu.com/releases/karmic/ubuntu-9.10-desktop-amd64.iso --output-document=/dev/null"

# Aliases (Vim)
alias ctags-c++='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'

# Aliases (Profiling)
alias valgrind-callgrind='valgrind --tool=callgrind --fn-skip="QMetaObject::activate*" --fn-skip="QMetaObject::metacall*" --fn-skip="*::qt_metacall*" --fn-skip="*::qt_static_metacall*"'

# Alias for quickly compiling Qt-related source file
alias clang++-qt5='g++ -fPIC -I/usr/include/x86_64-linux-gnu/qt5/ -I/usr/include/x86_64-linux-gnu/qt5/QtCore -lQt5Core'
alias g++-qt5='g++ -fPIC -I/usr/include/x86_64-linux-gnu/qt5/ -I/usr/include/x86_64-linux-gnu/qt5/QtCore -I/usr/include/x86_64-linux-gnu/qt5/QtGui -I/usr/include/x86_64-linux-gnu/qt5/QtWidgets -lQt5Core -lQt5Gui -lQt5Widgets'

# Alias (perf)
alias perf.record='perf record --call-graph dwarf'
alias perf.report='perf report -g graph --no-children'

# Functions
# NAME: mkcd - mkdir and cd into it
# SYNOPSIS: mkcd DIRECTORY
function mkcd() {
    [ -n "$1" ] && mkdir -p "$@" && cd "$1";
}

# NAME: top_by-Process_name - Run top but filter by process name ($1)
function top_by_process_name() {
    top -c -p $(pgrep -d',' -f $1)
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

function configure-qt5() {
    CONFIGURE=$1
    shift;

    # Note: Use gcc-11 since building QtWebEngine 5.15 against GCC 12.x does not work atm:
    #   ../../../../../../src/qt5.15/qtwebengine/src/3rdparty/chromium/v8/src/compiler/common-operator.h:599:34: error: call to non-‘constexpr’ function ‘v8::internal::compiler::IrOpcode::Value v8::internal::compiler::Node::opcode() const’
    #  599 |     CONSTEXPR_DCHECK(node->opcode() == IrOpcode::kStart);
    #      |                      ~~~~~~~~~~~~^~

    $CONFIGURE -developer-build -nomake tests -nomake examples -no-warnings-are-errors -skip qt3d -skip qtlocation -skip qtpurchasing -skip qtdocgallery -skip qtcanvas3d -skip qtsystems -skip qtpim -opensource -confirm-license -system-webengine-icu -no-webengine-ffmpeg -system-webengine-webp QMAKE_CXX=g++11 QMAKE_CC=gcc-11 $*
}

function configure-qt6() {
    PATH=/home/kfunk/opt/cmake-3.22.2-linux-x86_64/bin:$PATH
    cmake -DCMAKE_BUILD_TYPE=RelWithDebInfo -DFEATURE_developer_build=ON -DINPUT_dbus=linked -G Ninja \
        -DQT_BUILD_TESTS_BY_DEFAULT=OFF -DQT_BUILD_EXAMPLES_BY_DEFAULT=OFF \
        -DCMAKE_CXX_FLAGS="-fno-omit-frame-pointer" -DCMAKE_CXX_FLAGS_RELWITHDEBINFO="-O2 -g -DQT_FORCE_ASSERTS -DQT_MESSAGELOGCONTEXT" -DCMAKE_C_FLAGS_RELWITHDEBINFO="-O2 -g -DQT_FORCE_ASSERTS -DQT_MESSAGELOGCONTEXT" \
        -DCMAKE_INSTALL_PREFIX=$PWD $*
}

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
#fpath=($fpath $HOME/.zsh/func)
#autoload -U $HOME/.zsh/func/*(:t)

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

# Private sources
if [ -f "$HOME/.zshrc-private" ]; then
    source ~/.zshrc-private
fi
