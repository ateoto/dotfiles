#!/usr/bin/env bash

shopt -s expand_aliases

export HISTCONTROL=ignoredups:erasedups   #remove duplicate entries
export HISTSIZE=100000			# Big History
export HISTFILESIZE=1000000		# Big History

# Save and reload history after each command
unset PROMPT_COMMAND
export PROMPT_COMMAND="history -a;history -c;history -r; $PROMPT_COMMAND"

# Add Go workspace to PATH
export GOPATH=${HOME}/Documents/code/go
export GOME=${GOPATH}/src/github.com/ateoto

export PATH="${PATH}:${GOPATH}/bin"
export PATH="${PATH}:/usr/local/go/bin"

# AWS
export AWS_DEFAULT_PROFILE=mccantsio
export AWS_DEFAULT_REGION=us-east-1

# Homebrew Token
if [ -f "${HOME}/.config/mmccants/homebrew_github_token" ];then
  #shellcheck disable=SC2155
  export HOMEBREW_GITHUB_API_TOKEN=$(cat "${HOME}/.config/mmccants/homebrew_github_token")
fi

# Aliases
alias nv=nvim
alias vim=nvim

command -v hub >/dev/null 2>&1
if [[ $? -eq 0 ]];then
  alias git=hub
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
	# If we are on MacOS allow us to easily hide/show hidden files.
  alias show_files="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
  alias hide_files="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

	# Assume we are running iterm2 on MacOS
	# So setup file based conf
  defaults write com.googlecode.iterm2.plist PrefsCustomFolder -string "${HOME}/.config/iterm2"
  defaults write com.googlecode.iterm2.plist LoadPrefsFromCustomFolder -bool true

  if [ -f "$(brew --prefix)/etc/bash_completion" ]; then
    #shellcheck disable=SC1090
    source "$(brew --prefix)/etc/bash_completion"
  fi

	#shellcheck disable=SC1090
	test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
fi

export PS1="\u: \w \\$ \[$(tput sgr0)\]"

function agnostic-install() {
  PACKAGE="${1:-}"
  ARCH=$(uname -s)

  case "${ARCH}" in
    Linux)
      DISTRO=$(grep -h '^ID=' /etc/*-release 2>/dev/null | sed s/ID=//g | sed s/\"//g)
      case "${DISTRO}" in
        alpine)
          PACKAGE="${PACKAGE//python-/py-}"
          apk update
          apk add "${PACKAGE}"
        ;;
        debian|ubuntu)
          apt-get -q update
          apt-get -q -y install "${PACKAGE}"
        ;;
        centos)
          yum -q -y install epel-release
          yum -q -y install "${PACKAGE}"
        ;;
        *)
          echo "Failed to install, Distro not supported. ${DISTRO}"
          exit 1
        ;;
      esac
  ;;
  Darwin)
    command -v brew >/dev/null 2>&1
    if [[ $? -eq 1 ]];then
      echo "FATAL: brew not installed. Please see: https://brew.sh/"
      exit 1
    fi
    
    brew update
    brew install "${PACKAGE}"
  ;;
  MINGW64*)
    echo "Failed to install: windows things are untested."
    exit 1
  ;;
  *)
    echo "Arch not supported: ${ARCH}"
  ;;
  esac
}

function setup-env() {
  # Make sure git is installed
  agnostic-install git
  agnostic-install hub
  git clone https://github.com/ateoto/dotfiles "${HOME}/Documents/code/dotfiles"
  "${HOME}/Documents/code/dotfiles/bin/install.sh"
}
