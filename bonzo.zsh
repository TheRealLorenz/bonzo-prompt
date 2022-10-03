# vcs crap
autoload -Uz vcs_info
zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' check-for-changes true
zstyle ':vcs_info:git*+set-message:*' hooks git-untracked

+vi-git-untracked(){
    if [[ "${#hook_com[unstaged]}" == "2" ]]; then
	return
    fi

    if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == 'true' ]] && \
        git status --porcelain | grep -q '^?? ' 2> /dev/null ; then
        hook_com[unstaged]+='T'
    fi
}

# Styling
zstyle ':vcs_info:*' max-exports 6
zstyle ':vcs_info:*' nvcsformats "%5~/ "
zstyle ':vcs_info:*' formats \
  '%r' \
  '%S' \
  '%b' \
  '%c' \
  '%u'
  # Repo name
  # Relative path
  # Branch
  # Changes
  # Untracked

zstyle ':vcs_info:*' actionformats \
  '%r' \
  '%S' \
  '%b' \
  '%c' \
  '%u' \
  '%a'
  # Repo name
  # Relative path
  # Branch
  # Changes
  # Untracked
  # Action

# Modal color depending on the return code
# of the last command
foreground_modal="%F{%(?.green.red)}"

function virtualenv_info {
  [ $VIRTUAL_ENV ] && echo ' via %F{blue}'`basename $VIRTUAL_ENV`'%f'
}

function vcs_info_custom {
  vcs_info

  # Add repo name
  VCS_INFO=" %F{yellow}"${vcs_info_msg_0_}"%f"

  # Add relative path
  [ "${vcs_info_msg_1_}" != "." ] \
    && [ "${vcs_info_msg_1_}" != "" ] \
    && VCS_INFO+="/"${vcs_info_msg_1_}

  # Add branch name
  if [ "${vcs_info_msg_2_}" != "" ]; then
    VCS_INFO+=" at %F{magenta}"${vcs_info_msg_2_}"%f"

    # Add status
    VCS_STATUS=""
    [ "${vcs_info_msg_5_}" != "" ] \
      && VCS_STATUS+=${vcs_info_msg_5_}"|"}
    [ "${vcs_info_msg_3_}" != "" ] \
      && VCS_STATUS+="%F{green}"${vcs_info_msg_3_}"%f"
    [ "${vcs_info_msg_4_}" != "" ] \
      && VCS_STATUS+="%F{red}"${vcs_info_msg_4_}"%f"
    [ "$VCS_STATUS" != "" ] \
      && VCS_INFO+=" ["$VCS_STATUS"]"
  fi

  echo $VCS_INFO
}


precmd() {
  # Base status
  STATUS="%n@%m"

  # Git integration
  STATUS+=$(vcs_info_custom)

  # Virtualenv integration
  STATUS+=$(virtualenv_info)

  # Final prompt assembly
  PS1=$'\n'"%B"$foreground_modal"╭╴%f$STATUS"$'\n'$foreground_modal"╰──⯈%f%b "
}

