#!/bin/sh
# Helix formatter: runs eslint_d and/or prettierd based on project config.
# Usage: format.sh <extension>
# Helix passes the file extension as $1 (e.g. ts, js, svelte).
# CWD is the directory from which helix was launched (typically project root).
# Reads stdin, writes formatted output to stdout.

EXT="$1"
INPUT=$(cat)

# Fake filepath rooted at CWD — used for parser detection and config lookup.
FAKE_FILE="$PWD/helix-format.$EXT"

# Walk up from dir looking for any of the given filenames, stopping at git root.
find_up() {
  _dir="$1"
  shift
  _stop=$(git -C "$_dir" rev-parse --show-toplevel 2>/dev/null)
  while [ -n "$_dir" ] && [ "$_dir" != "/" ]; do
    for _name in "$@"; do
      [ -f "$_dir/$_name" ] && return 0
    done
    [ "$_dir" = "$_stop" ] && return 1
    _dir=$(dirname "$_dir")
  done
  return 1
}

# Check if any package.json up the tree contains a given top-level key.
has_pkg_key() {
  _dir="$1"
  _key="$2"
  _stop=$(git -C "$_dir" rev-parse --show-toplevel 2>/dev/null)
  while [ -n "$_dir" ] && [ "$_dir" != "/" ]; do
    if [ -f "$_dir/package.json" ] && \
       grep -Eq "^[[:space:]]*\"$_key\"[[:space:]]*:" "$_dir/package.json"; then
      return 0
    fi
    [ "$_dir" = "$_stop" ] && return 1
    _dir=$(dirname "$_dir")
  done
  return 1
}

has_eslint() {
  find_up "$PWD" \
    eslint.config.js eslint.config.mjs eslint.config.cjs \
    eslint.config.ts eslint.config.mts eslint.config.cts \
    .eslintrc .eslintrc.js .eslintrc.cjs \
    .eslintrc.json .eslintrc.yml .eslintrc.yaml \
    || has_pkg_key "$PWD" eslintConfig
}

has_prettier() {
  find_up "$PWD" \
    .prettierrc .prettierrc.js .prettierrc.cjs .prettierrc.mjs \
    .prettierrc.json .prettierrc.yml .prettierrc.yaml .prettierrc.toml \
    prettier.config.js prettier.config.cjs prettier.config.mjs \
    || has_pkg_key "$PWD" prettier
}

if has_eslint; then
  RESULT=$(printf '%s' "$INPUT" | eslint_d --fix-to-stdout --stdin --stdin-filename "$FAKE_FILE" 2>/dev/null)
  [ $? -eq 0 ] && [ -n "$RESULT" ] && INPUT="$RESULT"
fi

if has_prettier; then
  RESULT=$(printf '%s' "$INPUT" | prettierd "$FAKE_FILE" 2>/dev/null)
  [ $? -eq 0 ] && [ -n "$RESULT" ] && INPUT="$RESULT"
fi

printf '%s' "$INPUT"
