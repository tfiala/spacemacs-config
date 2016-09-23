#!/bin/bash

# Grab this script's directory
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Sync Spacemacs Emacs setup
EMACS_DIR="$HOME/.emacs.d"
CLONE_NEEDED=1
if [ -d "$EMACS_DIR" ]; then
    # Check if it looks like a Spacemacs repo.
    pushd "$EMACS_DIR"
    if [[ "$(git remote get-url origin)" =~ "syl20bnr/spacemacs" ]]; then
        # This is a spacemacs repo.  Just go ahead and
        # pull the latest.
        echo "~/.emacs.d is a Spacemacs repo, pulling latest."
        git pull
        CLONE_NEEDED=0
        popd
    else
        # The config dir is not a spacemacs repo.
        # Move it.
        echo "~/.emacs.d is not a Spacemacs repo, moving aside."
        popd
        mv -f "$EMACS_DIR" "${EMACS_DIR}.bak"
    fi
fi

# Clone Spacemacs repo if we need to do so.
if [ $CLONE_NEEDED -eq 1 ]; then
    echo "Cloning the Spacemacs repo"
    pushd "$HOME"
    SPACEMACS_REPO_URL="https://github.com/syl20bnr/spacemacs"
    git clone "$SPACEMACS_REPO_URL" ".emacs.d"
    popd
fi

# Create link for .spacemacs file
SPACEMACS_CONFIG="$HOME/.spacemacs"
if [ ! -h "$SPACEMACS_CONFIG" ]; then
    # It's not a link.  Does it exist?
    if [ -e "$SPACEMACS_CONFIG" ]; then
        # Yes, it exists.  We need to move it.
        echo "backing up non-link .spacemacs file"
        mv -f "$SPACEMACS_CONFIG" "${SPACEMACS_CONFIG}.bak"
    fi
    # Create the link.
    echo "creating .spacemacs link"
    ln -s "$SCRIPT_DIR/spacemacs.el" "$SPACEMACS_CONFIG"        
else
    echo ".spacemacs link exists, leaving as is"
fi

# Link this repository's layers into Spacemacs.
PRIVATE_LAYERS_PATH="${SCRIPT_DIR}/layers"
if [ -d "$PRIVATE_LAYERS_PATH" ]; then
    for layer_path in $(find "$PRIVATE_LAYERS_PATH" -maxdepth 1 -type d); do
        echo "Linking in private layer: ${layer_path}"
        ln -s -f "$layer_path" "${EMACS_DIR}/private"
    done
fi
