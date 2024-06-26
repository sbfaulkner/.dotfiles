# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/Users/sbfaulkner/.oh-my-zsh"

# Set name of the theme to load --- if set to "random", it will
# load a random theme each time oh-my-zsh is loaded, in which case,
# to know which specific one was loaded, run: echo $RANDOM_THEME
# See https://github.com/ohmyzsh/ohmyzsh/wiki/Themes
ZSH_THEME="spaceship"
SPACESHIP_VI_MODE_SHOW=false
SPACESHIP_GCLOUD_SHOW=false
SPACESHIP_DOCKER_SHOW=false
SPACESHIP_DIR_PREFIX='
in '
SPACESHIP_KUBECTL_SHOW=true
SPACESHIP_KUBECTL_VERSION_SHOW=false

SPACESHIP_PROMPT_ORDER=(
  kubectl       # Kubectl context section
  time          # Time stampts section
  user          # Username section
  dir           # Current directory section
  host          # Hostname section
  git           # Git section (git_branch + git_status)
  node          # Node.js section
  ruby          # Ruby section
  golang        # Go section
  rust          # Rust section
  docker        # Docker section
  pyenv         # Pyenv section
  terraform     # Terraform workspace section
  exec_time     # Execution time
  line_sep      # Line break
  battery       # Battery level and status
  vi_mode       # Vi-mode indicator
  jobs          # Background jobs indicator
  exit_code     # Exit code section
  char          # Prompt character
)

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
DISABLE_MAGIC_FUNCTIONS="true"

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
[ -f /opt/dev/dev.sh ] && plugins=(last-working-dir vi-mode)
[ -f /opt/dev/dev.sh ] || plugins=(chgo chruby dev last-working-dir vi-mode)

source $ZSH/oh-my-zsh.sh

# User configuration

export CDPATH=:$(find ~/src -type d -maxdepth 2 | tail -r | paste -s -d : -):$HOME

export GOPATH=$HOME

export PATH=$HOME/scripts:$HOME/bin:$HOME/src/github.com/Shopify/edge-infrastructure/scripts:/usr/local/sbin:$PATH:$HOME/.krew/bin

# export MANPATH="/usr/local/man:$MANPATH"

# disable autocd (ie. require actual cd command)
unsetopt autocd

# pass glob through unmodified if it doesn't match (backwards compatible)
unsetopt nomatch

# don't require enter after recalling command
unsetopt hist_verify

# don't ask about wildcard for rm
setopt rm_star_silent

# exit less after last page
export LESS="$LESS -XE"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
  export EDITOR='vim'
else
  export EDITOR='code --wait'
fi

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

alias h=history
alias gcurl='curl -s --header "Authorization: Bearer $(gcloud auth print-access-token)"'

alias chinaon="sudo networksetup -setsocksfirewallproxy Wi-Fi localhost 1080"
alias chinaoff="sudo networksetup -setsocksfirewallproxystate Wi-Fi off"

alias decode64="ruby -r base64 -e 'puts Base64.decode64(ARGV[0])' --"
alias dejson="ejson d --key-from-stdin"

function ssh-rekey() {
	for host in $*; do
		ssh-keygen -f ~/.ssh/known_hosts -R $host
		ssh-keyscan $host >>~/.ssh/known_hosts
	done
}

[ -f /opt/dev/dev.sh ] && source /opt/dev/dev.sh

[[ -f /opt/dev/sh/chruby/chruby.sh ]] && (
  type chruby >/dev/null 2>&1 || chruby () { source /opt/dev/sh/chruby/chruby.sh; chruby "$@"; }
)

[[ -x /opt/homebrew/bin/brew ]] && eval $(/opt/homebrew/bin/brew shellenv)
[[ -x /usr/local/bin/brew ]] && eval $(/usr/local/bin/brew shellenv)

trap "rm -f $HOME/.dotfiles/secrets.$$" EXIT

function load_secrets() {
  eval $(ejson2env $HOME/.dotfiles/secrets.ejson)
  touch $HOME/.dotfiles/secrets.$$
}

[[ -f $HOME/.dotfiles/secrets.ejson ]] && load_secrets

function reload_secrets() {
  [[ $HOME/.dotfiles/secrets.ejson -nt $HOME/.dotfiles/secrets.$$ ]] && {
    echo "Reloading secrets..."
    load_secrets
  }
}

precmd_functions+=(reload_secrets)

[ -d /Users/sbfaulkner/src/github.com/Shopify/cloudplatform ] && (
  # cloudplatform: add Shopify clusters to your local kubernetes config
  export KUBECONFIG=${KUBECONFIG:+$KUBECONFIG:}/Users/sbfaulkner/.kube/config:/Users/sbfaulkner/.kube/config.shopify.cloudplatform
  for file in /Users/sbfaulkner/src/github.com/Shopify/cloudplatform/workflow-utils/*.bash; do source ${file}; done
  kubectl-short-aliases
)
