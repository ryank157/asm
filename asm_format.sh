#!/bin/bash
# Read the file content from stdin
content=$(cat)
# Format the content
formatted=$(echo "$content" | sed -E '
    # Make labels start at column 1 (no indentation)
    s/^[[:space:]]+([a-zA-Z0-9_]+:)/\1/g;
    # Indent instructions with 3 spaces
    s/^[[:space:]]*([^a-zA-Z0-9_:;].+)/   \1/g;  # Changed from \t to 3 spaces
    # Ensure only one space after instruction mnemonic
    s/([a-z0-9]+)[[:space:]]+/\1 /g;
    # Align comments
    s/;[[:space:]]*/; /g;
    # Remove trailing whitespace
    s/[[:space:]]+$//g;
')
# Output the formatted content
echo "$formatted"
