# Exports
export EDITOR="vim"
export LC_MESSAGES=C # Console messages in english please
export PYTHONSTARTUP="$HOME/.pythonrc"

# Aliases
alias mv='nocorrect mv' # no spelling correction on mv
alias cp='nocorrect cp' # ~ on cp
alias mkdir='nocorrect mkdir' # ~ on on mkdir
alias j=jobs
alias pu=pushd
alias po=popd
alias d='dirs -v'
alias h=history
alias grep=egrep
alias igrep=grep -i
alias ll='ls -l'
alias la='ls -al'
alias ls='ls --color=always'
alias netcat='nc'
alias apt='sudo aptitude'
#alias api='sudo aptitude install'
alias api='sudo aptitude install'
alias aps='aptitude search'
#alias apr='sudo aptitude remove'
alias apr='sudo aptitude remove'
#alias apu='sudo aptitude update; sudo aptitude full-upgrade'
alias apu='sudo aptitude update; sudo aptitude full-upgrade'
alias apt-keyadv='sudo apt-key adv --recv-keys --keyserver keyserver.ubuntu.com'
alias psg='ps aux | grep'
alias remove-spaces='find . -depth | rename "s/\ /_/g"' # with subdirs!
alias whatismyip='wget -O - -o /dev/null http://www.whatismyip.com/automation/n09230945.asp' # http://forum.whatismyip.com/f14/

# Aliases for Vim
alias ctags-c++='ctags -R --c++-kinds=+p --fields=+iaS --extra=+q'

# Override keymap selection
bindkey -e

# Make Pos1/End work correcly
bindkey "^[[g" beginning-of-line
bindkey "^[[1~" beginning-of-line
bindkey "^[[h" end-of-line
bindkey "^[[4~" end-of-line

# Sources
if [ -f "$HOME/.zshrc-private" ]; then
    source ~/.zshrc-private
fi

PATH="$PATH:$HOME/bin"

# Prompt
autoload colors zsh/terminfo
colors
autoload -U promptinit
promptinit
setopt promptsubst
local returncode="%{$fg[red]%}-%?-%{$reset_color%}"

PROMPT="[%{$terminfo[bold]$fg[cyan]%}%n%{${reset_color}%}\
@%{$fg[cyan]%}%m%{${reset_color}%}\
 %{$fg[yellow]%}%(4c.%1c.%~)%{${reset_color}%}\
 %{$fg[green]%}"'$(LC_MESSAGES=C ls -lah --color=never | grep total | tr -d total\ )'"%{${reset_color}%}\
%(?,, ${returncode})%{${reset_color}%}\
]%{$fg[white]%}%B%#%b%{${reset_color}%} "
RPROMPT="%{$fg[white]%}%T%{${reset_color}%}" # prompt for right side of screen

# Autoload scripts in .zsh.d
setopt extended_glob
for zshrc_snipplet in ~/.zsh.d/S[0-9][0-9]*[^~] ; do
    source $zshrc_snipplet
done

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

# command for process lists, the local web server details and host completion
#zstyle ':completion:*:processes' command 'ps -o pid,s,nice,stime,args'
#zstyle ':completion:*:urls' local 'www' '/var/www/htdocs' 'public_html'
zstyle '*' hosts $hosts

# Filename suffixes to ignore during completion (except after rm command)
zstyle ':completion:*:*:(^rm):*:*files' ignored-patterns '*?.o' '*?.c~' \
    '*?.old' '*?.pro'
# the same for old style completion
#fignore=(.o .c~ .old .pro)

# ignore completion functions (until the _ignored completer)
zstyle ':completion:*:functions' ignored-patterns '_*'


# if the command-not-found package is installed, use it
if [ -x /usr/lib/command-not-found ]; then
        function command_not_found_handle {
                # check because c-n-f could've been removed in the meantime
                if [ -x /usr/lib/command-not-found ]; then
                   /usr/bin/python /usr/lib/command-not-found -- $1
                   return $?
                else
                   return 127
                fi
        }
fi
