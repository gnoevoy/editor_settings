# History in cache directory:
HISTSIZE=10000
SAVEHIST=10000



#  AUTO-TAB COMPLITION    ==========================================
#  Double tab to open menu, hjkl - navigation

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)		

# Use vim keys in tab complete menu:
bindkey -M menuselect 'h' vi-backward-char
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -v '^?' backward-delete-char


# QUICK NAVIGATION    =========================================
# Use lf to switch directories and bind it to alt+o
lfcd () {
    tmp="$(mktemp)"
    lf -last-dir-path="$tmp" "$@"
    if [ -f "$tmp" ]; then
        dir="$(cat "$tmp")"
        rm -f "$tmp"
        [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
    fi
}
bindkey -s '\eo' 'lfcd\n'


# AUTOSUGGESTIONS   =========================================
# need to change shortcut to auto filling
source ~/.zsh-plugins/zsh-autosuggestions/zsh-autosuggestions.zsh


# VI MODE   ========================================

bindkey -v
export KEYTIMEOUT=1

# Change cursor shape for different vi modes.
function zle-keymap-select {
  if [[ ${KEYMAP} == vicmd ]] ||
     [[ $1 = 'block' ]]; then
    echo -ne '\e[1 q'
  elif [[ ${KEYMAP} == main ]] ||
       [[ ${KEYMAP} == viins ]] ||
       [[ ${KEYMAP} = '' ]] ||
       [[ $1 = 'beam' ]]; then
    echo -ne '\e[5 q'
  fi
}
zle -N zle-keymap-select
zle-line-init() {
    zle -K viins # initiate `vi insert` as keymap (can be removed if `bindkey -V` has been set elsewhere)
    echo -ne "\e[5 q"
}
zle -N zle-line-init
echo -ne '\e[5 q' # Use beam shape cursor on startup.
preexec() { echo -ne '\e[5 q' ;} # Use beam shape cursor for each new prompt.




# Enable colors and change prompt:
autoload -U colors && colors

export LS_COLORS=$LS_COLORS
alias ls="ls --color=auto"
    
parse_git_branch() {
    git branch 2> /dev/null | sed -n -e 's/^\* \(.*\)/[\1] /p'
}
setopt PROMPT_SUBST
PROMPT='%F{10}%~%f %F{11}$(parse_git_branch)%f%F{250}$%f%b '


# SYNTAX HIGHLIGHTING   ==========================================
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh