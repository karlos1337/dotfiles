#!/bin/sh
# Helix formatter: runs eslint_d and/or prettier based on project config.
# Usage: format.sh <filename>
# Reads stdin, writes formatted output to stdout.

FILE="$1"
INPUT=$(cat)

has_eslint() {
  [ -f eslint.config.js ] || [ -f eslint.config.mjs ] || [ -f eslint.config.cjs ] || \
  [ -f eslint.config.ts ] || [ -f eslint.config.mts ] || [ -f eslint.config.cts ] || \
  [ -f .eslintrc ] || [ -f .eslintrc.js ] || [ -f .eslintrc.cjs ] || \
  [ -f .eslintrc.json ] || [ -f .eslintrc.yml ] || [ -f .eslintrc.yaml ]
}

has_prettier() {
  [ -f .prettierrc ] || [ -f .prettierrc.js ] || [ -f .prettierrc.cjs ] || \
  [ -f .prettierrc.mjs ] || [ -f .prettierrc.json ] || [ -f .prettierrc.yml ] || \
  [ -f .prettierrc.yaml ] || [ -f .prettierrc.toml ] || \
  [ -f prettier.config.js ] || [ -f prettier.config.cjs ] || [ -f prettier.config.mjs ]
}

if has_eslint; then
  RESULT=$(printf '%s' "$INPUT" | eslint_d --fix-to-stdout --stdin --stdin-filename "$FILE" 2>/dev/null)
  [ $? -eq 0 ] && [ -n "$RESULT" ] && INPUT="$RESULT"
fi

if has_prettier; then
  RESULT=$(printf '%s' "$INPUT" | prettier --stdin-filepath "$FILE" 2>/dev/null)
  [ $? -eq 0 ] && [ -n "$RESULT" ] && INPUT="$RESULT"
fi

printf '%s' "$INPUT"
