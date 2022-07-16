#!/bin/bash

# utilities

# courtesy: https://apple.stackexchange.com/a/425118/378721
brew_install() {
    echo "\nInstalling $1"
    if brew list $1 &>/dev/null; then
        echo "${1} is already installed"
    else
        brew install $1 && echo "$1 is installed"
    fi
}

# ---------------------------------------------------------------

# setup tools needed to run a project on a new laptop
brew_install gh # install github tools
