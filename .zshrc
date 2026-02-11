# If you come from bash you might have to change your $PATH.
 export PATH=$HOME/bin:/usr/local/bin:$PATH
 
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
 
 plugins=(git)
 
 source $HOME/.oh-my-zsh/oh-my-zsh.sh
 
 # User configuration
 
 function chpwd(){
     emulate -L zsh
     ls -a
 }
 
 export TERM=xterm-256color
 
 export PYENV_ROOT="$HOME/.pyenv"
 [[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
 eval "$(pyenv init - bash)"
 
 eval "$(pyenv virtualenv-init -)"
 
 
 # Auto-update Python packages on SSH login
 if [[ -n "$SSH_CONNECTION" ]]; then
     {
         # Check if updates are available without installing
         outdated=$(python3 -m pip list --outdated --format=freeze 2>/dev/null | grep -E '^(agent_core|cloud_support)=')
 
         # Only update if packages are outdated
         if [[ -n "$outdated" ]]; then
             python3 -m pip install --upgrade agent_core cloud_support
         fi
     } &>/dev/null || {
         echo "Warning: Failed to check/update Python packages (agent_core, cloud_support)"
     }
 fi
 
 export PIP_NO_CACHE_DIR=1
 
 export PROMPT='---------------
 %(!.%F{yellow}.)$USER%F{white}@%M ${ret_status} %F{cyan}%c%f $(git_prompt_info)
 %F{green}➜  %F{white}'
 
 [[ -s /home/qauser/.autojump/etc/profile.d/autojump.sh ]] && source /home/qauser/.autojump/etc/profile.d/autojump.sh
 autoload -U compinit && compinit -u
 
