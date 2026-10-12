#!/bin/bash
set -e

# Read stdin into variable
INPUT=$(cat)

# Detect if this looks like Ansible YAML
# Must have both - name: and Ansible-specific keys
HAS_TASKS=$(echo "$INPUT" | grep -cE '^[[:space:]]*- name:' || true)
HAS_ANSIBLE_KEYS=$(echo "$INPUT" | grep -cE '^[[:space:]]*(hosts|tasks|handlers|pre_tasks|post_tasks|roles):' || true)

if [ "$HAS_TASKS" -eq 0 ] || [ "$HAS_ANSIBLE_KEYS" -eq 0 ]; then
  # Not Ansible YAML, just run yamlfmt
  echo "$INPUT" | yamlfmt -
  exit 0
fi

# First format with yamlfmt, then add blank lines between - name: blocks
echo "$INPUT" | yamlfmt - | awk '
  BEGIN { prev = ""; prev_indent = -1 }
  {
    # Calculate indent level (number of leading spaces)
    match($0, /^[[:space:]]*/)
    current_indent = RLENGTH
    
    # Detect task block start: line with - name:
    if ($0 ~ /^[[:space:]]*- name:/) {
      # Add blank line if previous non-blank line exists and previous was not blank
      if (prev != "" && prev !~ /^[[:space:]]*$/) {
        # Only add if at same or lower indent than previous non-blank line
        if (current_indent <= prev_indent) {
          print ""
        }
      }
    }
    
    print $0
    prev = $0
    if ($0 !~ /^[[:space:]]*$/) {
      prev_indent = current_indent
    }
  }
'
