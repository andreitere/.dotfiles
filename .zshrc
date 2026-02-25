# # Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
export XDG_CONFIG_HOME="$HOME/.config"
# export TERM=screen-256color-bce


if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
ZSH_THEME="powerlevel10k/powerlevel10k"

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/my_scripts:$PATH
export PATH=$HOME/my_scripts/flutter/bin:$PATH
export PATH="$PATH":"$HOME/.pub-cache/bin"
export DOCKER_HOST=unix:///Users/tere/.config/colima/default/docker.sock
# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"


# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes

# Set list of themes to pick from when loading at random
# Setting this variable when ZSH_THEME=random will cause zsh to load
# a theme from this variable instead of looking in $ZSH/themes/
# If set to an empty array, this variable will have no effect.
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment one of the following lines to change the auto-update behavior
zstyle ':omz:update' mode disabled  # disable automatic updates
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
# DISABLE_UNTRACKED_FILES_DIRTY="true"

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
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

# 
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
alias zshconfig="nvim ~/.zshrc"
# alias ohmyzsh="nvim ~/.oh-my-zsh"
alias ls="eza"
alias ll="eza -l -h -s type"
alias t="tmux"
alias activenv="source ./venv/bin/activate"
alias newvenv="python -m venv venv && activenv"
alias delvenv="rm -rf ./venv"
alias smartlife="cd ~/Documents/IBM/Projects/Roche-SL/repos/"
alias personal="cd ~/Documents/Personal/"
alias mps='multipass'
alias sl_deploy="git commit --allow-empty -m 'deploy' --no-verify && git push --no-verify"
alias vim="nvim"
alias lg="lazygit"
alias lzd="lazydocker"
alias c="z"
alias ci="zi"

dco() {
  docker-compose "$@"
}

function awspro() {
  if [ -z "$1" ]; then
    echo "Usage: awspro <profile_name>"
    echo "Current AWS_PROFILE: ${AWS_PROFILE:-<not set>}"
    echo "Available profiles:"
    grep -E '^\[profile .*\]$' ~/.aws/config | sed 's/\[profile \(.*\)\]/\1/' | sort
  else
    export AWS_PROFILE="$1"
    echo "AWS_PROFILE set to: $AWS_PROFILE"
    # Optional: Verify the new profile with get-caller-identity
    aws sts get-caller-identity --query "Arn" --output text 2>/dev/null
  fi
}


function next_rc_tag () {
    local version="$1"
    git fetch --tags > /dev/null 2>&1

    local latest_rc=$(git tag -l "${version}-rc.*" | sort -V | tail -n 1)
    if [[ -z "$latest_rc" ]]; then
        echo "${version}-rc.1"
    else
        local rc_number=$(echo "$latest_rc" | grep -oE 'rc\.[0-9]+' | cut -d. -f2)
        local next_rc=$((rc_number + 1))
        echo "${version}-rc.${next_rc}"
    fi
}


function awsvpn() {
  (
    cd ~/Documents/IBM/Projects/Roche-SL/vpn_connect && uv run awsvpn.py "$@"
  )
}


function arm() {
  echo "start using intel. pllsssss!!" 
  intel
}

function intel() {
  arch -x86_64 /bin/zsh
}


function conda_recreate_env() {
  python_v="$1"
  echo "creating with python version: $python_v"
  conda activate base > /dev/null 2>&1
  PROJECT_NAME=$(toml get --toml-path pyproject.toml tool.poetry.name)
  conda env remove -n "$PROJECT_NAME"
  echo "deleted env $PROJECT_NAME"
  conda create --name ${PROJECT_NAME} python=$python_v
  echo "created env $PROJECT_NAME"
  conda activate $PROJECT_NAME
  echo "activated: $PROJECT_NAME"
  poetry config virtualenvs.in-project true
  poetry install --only main --no-root
}

function conda_create_env() {
  python_v="$1"
  echo "creating with python version: $python_v"
  conda activate base > /dev/null 2>&1
  PROJECT_NAME=$(toml get --toml-path pyproject.toml tool.poetry.name)
  conda create --name ${PROJECT_NAME} python=$python_v
  echo "created env $PROJECT_NAME"
  conda activate $PROJECT_NAME
  echo "activated: $PROJECT_NAME"
  poetry install
}

function conda_activate() {
  conda activate base
  PROJECT_NAME=$(toml get --toml-path pyproject.toml tool.poetry.name)
  echo "activating: $PROJECT_NAME"
  conda activate $PROJECT_NAME
  which python
}


eval $(thefuck --alias) 

# export NVM_DIR="$HOME/.nvm"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# alias nvm="unalias nvm; [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"; nvm $@"

# lazy load nvm

lazy_load_nvm() {
  unset -f npm node nvm
  export NVM_DIR=~/.nvm
  [[ -s "$NVM_DIR/nvm.sh" ]] && source "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && source "$NVM_DIR/bash_completion"
}

npm() {
 lazy_load_nvm
 npm $@
}

node() {
  lazy_load_nvm
  node $@
}

nvm() {
  lazy_load_nvm
  nvm $@
}



# export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
# export HADOOP_OPTS="$HADOOP_OPTS -Djava.library.path=$HADOOP_HOME/lib/native"

# rosetta terminal setup
# if [ $(arch) = "i386" ]; then
#     alias brew86="/usr/local/bin/brew"
#     alias pyenv86="arch -x86_64 pyenv"
# fi

arch_name="$(uname -m)"
 
if [ "${arch_name}" = "x86_64" ]; then
    source ~/start_miniconda_intel.sh
elif [ "${arch_name}" = "arm64" ]; then
    source ~/start_miniconda_arm.sh
else
    echo "Unknown architecture: ${arch_name}"
fi
# <<<<<<<< end <<<<<<<


# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/tere/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# export DYLD_LIBRARY_PATH=/Users/tere/miniconda3/envs/toolchain_arm/lib/python3.9/site-packages/clidriver/lib:$DYLD_LIBRARY_PATH


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fcd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.*' -prune \
                  -o -type d -print 2> /dev/null | fzf +m) &&
    cd "$dir"
}

switch_env() {
  if [[ -z "$1" ]]; then
    echo "Usage: switch_env <environment>"
    return 1
  fi

  local envFile=".env.$1"

  if [[ ! -f "$envFile" ]]; then
    echo "Error: $envFile not found."
    return 1
  fi
  
  rm .env

  cp "$envFile" .env


  export ENV_FILE="$envFile"
  # source "$envFile"
  echo "Environment set to '$1' using $envFile"
}



# # bun completions
[ -s "/Users/tere/.bun/_bun" ] && source "/Users/tere/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

### MANAGED BY RANCHER DESKTOP START (DO NOT EDIT)
export PATH="/Users/tere/.rd/bin:$PATH"
### MANAGED BY RANCHER DESKTOP END (DO NOT EDIT)

export PATH="/usr/local/opt/libpq/bin:$PATH"
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

alias hawktuah='git push --force'

export PATH=$HOME/.rill:$PATH # Added by Rill install

# Created by `pipx` on 2024-11-16 06:45:31
export PATH="$PATH:/Users/tere/.local/bin"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/tere/.cache/lm-studio/bin"
eval "$(atuin init zsh)"

# if command -v tmux &> /dev/null && [ -n "$PS1" ] && [[ ! "$TERM" =~ screen ]] && [[ ! "$TERM" =~ tmux ]] && [ -z "$TMUX" ] && [[ "$TERM_PROGRAM" != "iTerm.app" ]]; then
#   exec tmux
# fi


export DISABLE_AUTO_TITLE='true'

eval "$(zoxide init zsh)"

# opencode
export PATH=/Users/tere/.opencode/bin:$PATH

#eval "$(try init)"
# #THIS MUST BE AT THE END OF THE FILE FOR SDKMAN TO WORK!!!
# export SDKMAN_DIR="$HOME/.sdkman"
# [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

# Added by Antigravity
export PATH="/Users/tere/.antigravity/antigravity/bin:$PATH"
