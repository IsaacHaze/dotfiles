# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

export MANWIDTH=80

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=100000
HISTFILESIZE=100000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
#[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

export LESS='-iR'

# custom installed software
if [[ "$OSTYPE" == "darwin"* ]]; then
    # use gnu utils (with their common names, not "g" prefixed)
    for gnu_pkg in findutils coreutils
    do
        PATH="/usr/local/opt/${gnu_pkg}/libexec/gnubin:$PATH"
        MANPATH="/usr/local/opt/${gnu_pkg}/libexec/gnuman:$MANPATH"
    done
    # brew's openssh
    PATH=/usr/local/Cellar/openssh/7.5p1_1/bin:$PATH
    MANPATH=/usr/local/Cellar/openssh/7.5p1_1/share/man:$MANPATH
    # brew's rsync
    PATH=/usr/local/Cellar/rsync/3.1.2/bin:$PATH
    MANPATH=/usr/local/Cellar/rsync/3.1.2/share/man:$MANPATH
    # brew's unzip
    PATH=/usr/local/opt/unzip/bin:$PATH

    # sublime subl
    PATH=/Applications/Sublime\ Text.app/Contents/SharedSupport/bin:$PATH
else
    for dir in ~/software/*
    do
        if [ -d "$dir/bin" ]; then
            PATH="$dir/bin":$PATH

            # python/pip
            PATH=~/.local/bin:$PATH

            PATH=~/bin:$PATH
        fi
    done
fi

export PATH


# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color) color_prompt=yes;;
    xterm-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

#not too fancy a prompt, ANSI escape start '\e[', escape end 'm',
#bold = '1', normal = '0'
export PS1='\[\033[1m\]\u\[\033[0m\]@\[\033[1m\]\h\[\033[0m\] '

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac


# git prompt & completions
function parse_git_branch {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return
  echo "["${ref#refs/heads/}"] "
}

PS1="$PS1\$(parse_git_branch)"

source ~/dotfiles/git-completion.bash


if [[ "$OSTYPE" == "darwin"* ]]; then
    export CLICOLOR=1
fi

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    #alias grep='grep --color=auto'
    #alias fgrep='fgrep --color=auto'
    #alias egrep='egrep --color=auto'
fi

# some more ls aliases
#alias ll='ls -l'
#alias la='ls -A'
#alias l='ls -CF'

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

export LC_ALL=en_US.UTF-8
