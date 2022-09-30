# vcs crap
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked(){
    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep -q '^?? ' 2> /dev/null ; then
        hook_com[unstaged]+='T'
    fi
}

# Styling
zstyle ':vcs_info:*' formats '%F{yellow}%r%f %S/ at %F{magenta}%b%f %F{green}%c%F{red}%u%f '
zstyle ':vcs_info:*' nvcsformats "%5~/ "
zstyle ':vcs_info:*' actionformats "%F{yellow}%r%f %S/ at %F{magenta}%b%f (%a|%F{green}%c%F{red}%u%f) "

# Modal color depending on the return code
# of the last command
foreground_modal="%F{%(?.green.red)}"

function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo 'via %F{blue}'`basename $VIRTUAL_ENV`'%f'
}

precmd() {
  # Base status
  STATUS="%n@%m"$foreground_modal"╶╴%f"

  # Git integration
  vcs_info
  STATUS+=${vcs_info_msg_0_}

  # Virtualenv integration
  STATUS+=$(virtualenv_info)

  # Final prompt assembly
  PS1=$'\n'"%B"$foreground_modal"╭╴%f$STATUS"$'\n'$foreground_modal"╰──⯈%f%b "
}

