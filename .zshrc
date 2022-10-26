# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH

# https://github.com/z-shell/zi
# Enable Zi
typeset -A ZI
ZI[BIN_DIR]="${HOME}/.zi/bin"
source "${ZI[BIN_DIR]}/zi.zsh"

# Enable Zi completions
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi

# Zi Linter
zi light z-shell/zui
zi light z-shell/zsh-lint

# History Search Multi Word
zi load z-shell/H-S-MW

# Feature-rich Syntax Highlighting And Autosuggestions
zi light zsh-users/zsh-syntax-highlighting
zi light zsh-users/zsh-autosuggestions

# Packages
zi pack"binary" for fzf
#zi pack for nb
#zi pack for ls_colors
#zi pack for dircolors-material
#zi pack for system-completions
#zi pack for zsh

# Zi Theme
zi light spaceship-prompt/spaceship-prompt
SPACESHIP_PROMPT_ASYNC=false

# User configuration
export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
export LANG=zh_CN.UTF-8
export LANGUAGE=zh_CN:en_US

# Preferred editor for local and remote sessions
if [[ -n $SSH_CONNECTION ]]; then
    export EDITOR='vim'
else
    export EDITOR='nvim'
fi

# Compilation flags
export ARCHFLAGS="-arch x86_64"

# Aliases
alias zshconfig="mate ~/.zshrc"
alias ohmyzsh="mate ~/.oh-my-zsh"
alias vi="nvim"
alias vim="nvim"
alias nvim-sync="nvim +'hi NormalFloat guibg=#1e222a' +NvChadUpdate +PackerSync"

# Envs
# autoenv
source $HOME/.autoenv/activate.sh
# autojump
[[ -s $HOME/.autojump/etc/profile.d/autojump.sh ]] && source $HOME/.autojump/etc/profile.d/autojump.sh
autoload -U compinit && compinit -u
# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# golang
export GOROOT=/usr/local/go
export GOPATH=/home/i/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin
# TinyTeX
export PATH=$PATH:$HOME/.TinyTeX/bin/x86_64-linux
# pyenv
#export PYENV_ROOT="$HOME/.pyenv"
#export PATH="$PYENV_ROOT/bin:$PATH"
#eval "$(pyenv init --path)"
# x11
#export DISPLAY=$(awk '/nameserver / {print $2; exit}' /etc/resolv.conf 2>/dev/null):0
#export LIBGL_ALWAYS_INDIRECT=1
