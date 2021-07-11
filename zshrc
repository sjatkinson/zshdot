echo .bashrc
HISTSIZE=10000
SAVEHIST=10000
HISTFILE=~/.zhistory
export EDITOR=vim
PATH=$PATH:$HOME/bin

setopt NO_CASE_GLOB

# history
setopt append_history
setopt bang_hist
setopt extended_history
setopt hist_expire_dups_first
setopt hist_ignore_space
setopt hist_verify
setopt inc_append_history
setopt share_history
setopt HIST_IGNORE_ALL_DUPS

typeset -U path # what does this do?

# git prompt
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git 
precmd() {
    vcs_info
}
setopt prompt_subst

git_prompt() {
  BRANCH=$(git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/*\(.*\)/\1/')

  if [ ! -z $BRANCH ]; then
    echo -n "%F{green} ($BRANCH)"
  fi
}

PROMPT='%F{cyan}%~$(git_prompt)
%F{244}$  %F{reset}'

autoload -U colors && colors

# tab completion
autoload -Uz compinit && compinit -u
setopt complete_in_word
setopt auto_menu
#zstyle ':completion:*' completer _complete _correct _approximate menu select
zmodload zsh/complist

alias vim="NVIM_LISTEN_ADDRESS=/tmp/nvimsocket nvim"

# bindkey
bindkey -v       # vi mode

bindkey "^R" history-incremental-search-backward
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^P' up-history
bindkey '^N' down-history
bindkey "^k" kill-line


if [[ -a $HOME/etc/zshrc ]] ; then
	source $HOME/etc/zshrc
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

echo done
