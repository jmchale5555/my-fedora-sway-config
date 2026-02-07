# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
    . /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]; then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
    for rc in ~/.bashrc.d/*; do
        if [ -f "$rc" ]; then
            . "$rc"
        fi
    done
fi
unset rc

# Set prompt colour
# export PS1="\[\e[38;2;172;130;233m\]\u@\h \w \$ \[\e[0m\]"
# export PS1='\[\e[1;32m\]\u@\[\e[0;33m\]\h \[\e[1;34m\]\w \$ \[\e[0m\]'
#


sucColor='\e[38;2;102;255;102m'
errColor='\e[38;2;255;110;106m'
if (( EUID )); then
  userColor="$sucColor" userSymbol='$'
else
  userColor="$errColor" userSymbol='#'
fi

prompt_command(){
  unset branch tag

  [[ $PWD =~ ^$HOME ]]&& { PWD="${PWD#$HOME}" PWD="~$PWD"; }

  local branch="$(git rev-parse --abbrev-ref HEAD 2>/dev/null)"
  local tag="$(git describe --tags --abbrev=0 2>/dev/null)"

  printf '\e[2;38;2;255;176;0m%s\e[m' "$PWD"
  [[ $branch ]]&& printf ' \e[2m%s\e[m \e[38;2;243;79;41m\e[m \e[2m%s\e[m' \
    "$branch" "$tag"
  echo
}

PROMPT_COMMAND=prompt_command

PS1="\[$userColor\]\$USER\[\e[m\]@\[\e[38;2;255;176;0m\]\$HOSTNAME\[\e[m\] \
\$((( \$? ))\
  && printf '\[$errColor\]$userSymbol\[\e[m\]> '\
  || printf '\[$sucColor\]$userSymbol\[\e[m\]> ')"

PS4="-[\e[33m${BASH_SOURCE[0]%.sh}\e[m: \e[32m$LINENO\e[m]\
  ${FUNCNAME:+${FUNCNAME[0]}(): }"
