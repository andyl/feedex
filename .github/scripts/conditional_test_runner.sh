#!/usr/bin/env bash 

# ============================================================================
# Elixir Optimized Pre-commit Hook
# ============================================================================
#
# Purpose:
#   This pre-commit hook optimizes the test running process for an Elixir
#   project by only executing tests when relevant files have been modified
#   since the last successful test run.
#
# Operation:
#   1. Maintains a timestamp of the last successful test run.
#   2. Checks for modifications to .ex or .exs files in the staged changes.
#   3. Compares the most recent change timestamp with the last test run.
#   4. Runs tests only if relevant changes are detected.
#   5. Updates the last test run timestamp if tests pass.
#   6. Aborts commit if tests fail.
#
# Usage:
#   1. Place this script in .git/hooks/pre-commit of your Elixir project.
#   2. Ensure it's executable: chmod +x .git/hooks/pre-commit
#
# Note:
#   This script creates and maintains a file named .last_test_run in your
#   project root to store the timestamp of the last successful test run.
#
# ============================================================================

# File to store the timestamp of the last successful test run
LAST_TEST_RUN_FILE=".last_test_run"

# Get the timestamp of the last test run
if [ -f "$LAST_TEST_RUN_FILE" ]; then
    last_test_run=$(cat "$LAST_TEST_RUN_FILE")
else
    last_test_run=0
fi

# Check if any .ex or .exs files have been modified since the last test run
files_changed=$(git diff --name-only --cached --diff-filter=ACM | grep -E '\.(ex|exs)$')
latest_change=$(git diff --name-only --cached --diff-filter=ACM | grep -E '\.(ex|exs)$' | xargs -I {} git log -1 --format="%at" -- {} | sort -nr | head -n1)

if [ -z "$latest_change" ]; then
    latest_change=0
fi

if [ "$latest_change" -gt "$last_test_run" ]; then
    echo "Running tests..."
    if mix test; then
        # Tests passed, update the timestamp
        date +%s > "$LAST_TEST_RUN_FILE"
        exit 0
    else
        echo "Tests failed. Commit aborted."
        exit 1
    fi
else
    echo "No relevant changes detected. Skipping tests."
    exit 0
fi
