
# Shell options
setopt auto_cd
setopt glob_complete
setopt numeric_glob_sort

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

typeset -U path # Remove duplicates from PATH

source ~/devel/oss/zsh-plugins/antidote/antidote.zsh
antidote load ${ZDOTDIR:-~}/.zsh_plugins.txt

# Prompt Theme Configuration
# Default theme - set this to your preferred theme
PROMPT_THEME=${PROMPT_THEME:-"enhanced"}

# Enhanced prompt (your current improved version)
setup_enhanced_prompt() {
  autoload -Uz vcs_info
  setopt prompt_subst

  # Execution time tracking
  preexec() {
    timer=${timer:-$SECONDS}
  }

  precmd() {
    if [ $timer ]; then
      timer_show=$(($SECONDS - $timer))
      if [[ $timer_show -ge 5 ]]; then
        timer_formatted=" %F{yellow}${timer_show}s%f"
      else
        timer_formatted=""
      fi
      unset timer
    else
      timer_formatted=""
    fi
    vcs_info
  }

  zstyle ':vcs_info:*' enable git
  zstyle ':vcs_info:*' get-revision true
  zstyle ':vcs_info:*' check-for-changes true
  zstyle ':vcs_info:*' stagedstr "%F{green}●%f"
  zstyle ':vcs_info:*' unstagedstr "%F{red}●%f"
  zstyle ':vcs_info:git:*' formats " %F{blue}(%b)%f%c%u"
  zstyle ':vcs_info:git:*' actionformats " %F{blue}(%b|%a)%f%c%u"

  git_prompt() {
    if git rev-parse --git-dir > /dev/null 2>&1; then
      echo -n "${vcs_info_msg_0_}"
      
      # Check for unpushed commits
      if [[ $(git rev-list --count @{upstream}..HEAD 2>/dev/null) -gt 0 ]]; then
        echo -n " %F{cyan}↑%f"
      fi
      
      # Check for unpulled commits  
      if [[ $(git rev-list --count HEAD..@{upstream} 2>/dev/null) -gt 0 ]]; then
        echo -n " %F{magenta}↓%f"
      fi
    fi
  }

  PROMPT='%F{cyan}%~$(git_prompt)${timer_formatted}
%F{244}$  %F{reset}'
}

# Starship setup function (only one we keep)
setup_starship_prompt() {
  eval "$(starship init zsh)"
}

# Enhanced git prompt with status indicators
autoload -Uz vcs_info
setopt prompt_subst

# Execution time tracking
preexec() {
  timer=${timer:-$SECONDS}
}

precmd() {
  if [ $timer ]; then
    timer_show=$(($SECONDS - $timer))
    if [[ $timer_show -ge 5 ]]; then
      timer_formatted=" %F{yellow}${timer_show}s%f"
    else
      timer_formatted=""
    fi
    unset timer
  else
    timer_formatted=""
  fi
  vcs_info
}

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:*' get-revision true
zstyle ':vcs_info:*' check-for-changes true
zstyle ':vcs_info:*' stagedstr "%F{green}●%f"
zstyle ':vcs_info:*' unstagedstr "%F{red}●%f"
zstyle ':vcs_info:git:*' formats " %F{blue}(%b)%f%c%u"
zstyle ':vcs_info:git:*' actionformats " %F{blue}(%b|%a)%f%c%u"

git_prompt() {
  if git rev-parse --git-dir > /dev/null 2>&1; then
    echo -n "${vcs_info_msg_0_}"
    
    # Check for unpushed commits
    if [[ $(git rev-list --count @{upstream}..HEAD 2>/dev/null) -gt 0 ]]; then
      echo -n " %F{cyan}↑%f"
    fi
    
    # Check for unpulled commits  
    if [[ $(git rev-list --count HEAD..@{upstream} 2>/dev/null) -gt 0 ]]; then
      echo -n " %F{magenta}↓%f"
    fi
  fi
}

PROMPT='%F{cyan}%~$(git_prompt)${timer_formatted}
%F{244}$  %F{reset}'

autoload -U colors && colors

# Optimized completion system with XDG cache
autoload -Uz compinit
# Set up XDG cache directory for completions
[[ ! -d "$XDG_CACHE_HOME/zsh" ]] && mkdir -p "$XDG_CACHE_HOME/zsh"
# Only rebuild compinit once per day
if [[ -n "$XDG_CACHE_HOME/zsh/compdump"(#qN.mh+24) ]]; then
  compinit -d "$XDG_CACHE_HOME/zsh/compdump"
else  
  compinit -C -d "$XDG_CACHE_HOME/zsh/compdump"
fi

# Completion options
setopt complete_in_word
setopt auto_menu
setopt no_case_glob

# Completion styling
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- no matches found --%f'

# Process completion
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

zmodload zsh/complist

alias vim="nvim"

# bindkey
bindkey -v       # vi mode

# History search keybindings
bindkey "^R" history-incremental-search-backward
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey -M vicmd 'k' history-substring-search-up
bindkey -M vicmd 'j' history-substring-search-down

# Better vi mode keybindings
bindkey '^a' beginning-of-line
bindkey '^e' end-of-line
bindkey '^P' up-history
bindkey '^N' down-history
bindkey "^k" kill-line
bindkey '^w' backward-kill-word
bindkey '^u' kill-whole-line


if [[ -a $HOME/etc/zshrc ]] ; then
	source $HOME/etc/zshrc
fi


# Prompt themes (disabled - using manual switching)

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
eval "$(zoxide init zsh)"


