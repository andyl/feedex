#!/bin/bash

# Get the commits in the pull request
commits=$(git log --pretty=format:"%s" origin/master..HEAD)

# Define the regex pattern for Conventional Commits
conventional_commit_regex='^(build|chore|ci|docs|feat|fix|perf|refactor|revert|style|test)(\([a-z \-]+\))?!?: [a-z].+|^Merge.+'

# Initialize error flag
error=0

# Check each commit message
while read -r commit_message; do
  if ! [[ "$commit_message" =~ $conventional_commit_regex ]]; then
    echo "Error: Commit message does not follow Conventional Commits standard: $commit_message"
    error=1
  fi
done <<< "$commits"

# Exit with an error code if any commit failed validation
if [ $error -ne 0 ]; then
  exit 1
fi

echo "All commit messages follow the Conventional Commits standard."
exit 0
