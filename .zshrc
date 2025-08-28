# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

# hostname set for cli
HOSTNAME=$HOST

# Set name of the theme to load. Optionally, if you set this to "random"
# # it'll load a random theme each time that oh-my-zsh is loaded.
# # See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="robbyrussell"
SPACESHIP_VI_MODE_SHOW=false
SPACESHIP_PROMPT_ADD_NEWLINE=false
SPACESHIP_HOST_SHOW=true
SPACESHIP_HOST_SHOW_FULL=true
SPACESHIP_VENV_SYMBOL="🐍 "
SPACESHIP_PROMPT_ORDER=(host venv git dir exec_time line_sep char)

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git)

# User configuration

source $ZSH/oh-my-zsh.sh

# aliases

alias gmp="git checkout master;git pull"

# ls after cd
function chpwd() {
    emulate -L zsh
    ls -a
}

export PROMPT='---------------
%(!.%F{yellow}.)$USER%F{white}@%M ${ret_status} %F{cyan}%c%f $(git_prompt_info)
%F{green}➜  %F{white}'


