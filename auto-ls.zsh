# vim: sw=2 ts=2 et!
# set up default functions

if (( ! ${+AUTO_LS_PRECMD} )); then
  AUTO_LS_PRECMD=true
fi

if [[ $#AUTO_LS_COMMANDS -eq 0 ]]; then
  AUTO_LS_COMMANDS=(ls git-status)
fi

if (( ! ${+AUTO_LS_NEWLINE} )); then
  AUTO_LS_NEWLINE=true
fi

if (( ! ${+AUTO_LS_PATH} )); then
  AUTO_LS_PATH=true
fi


auto-ls-ls () {
  ls
  [[ $AUTO_LS_NEWLINE != false ]] && echo ""
}

auto-ls-git-status () {
  if [[ $(git rev-parse --is-inside-work-tree 2> /dev/null) == true ]]; then
    git status
  fi
}

auto-ls () {
  if (( ! ${+AUTO_LS_OLDPWD} )); then
      AUTO_LS_OLDPWD="$PWD"
  fi 

  # Only do anything if PWD changed and printing to terminal
  if [ "$AUTO_LS_OLDPWD" = "$PWD" ] || [ ! -t 1 ]; then
      return
  fi

  AUTO_LS_OLDPWD="$PWD"

  for cmd in $AUTO_LS_COMMANDS; do
    # If we detect a command with full path, ex: /bin/ls execute it
    if [[ $AUTO_LS_PATH != false && $cmd =~ '/' ]]; then
      eval $cmd
    else
      # Otherwise run auto-ls function
      auto-ls-$cmd
    fi
  done
}

if [[ ${AUTO_LS_PRECMD} == true && ${precmd_functions[(I)auto-ls]} -eq 0 ]]; then
  precmd_functions+=(auto-ls)
fi
