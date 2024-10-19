#!/bin/bash

# Ensure we're in the root directory of the repo
if [ ! -d ".git" ]; then
    echo "Error: This script must be run from the root of the Git repository."
    exit 1
fi

# Set up the hooks path
git config --unset core.hooksPath 

echo "Git hooks have been cancelled!"
echo "The commit-msg hook will not enforce conventional commit messages."
