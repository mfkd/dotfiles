#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
DOTFILES_ROOT=$(cd "$SCRIPT_DIR/.." && pwd)
MANIFEST_FILE="$DOTFILES_ROOT/managed-paths.txt"
UNMANAGED_FILE="$DOTFILES_ROOT/unmanaged-patterns.txt"

die() {
  printf 'error: %s\n' "$*" >&2
  exit 1
}

manifest_entries() {
  while IFS= read -r line || [ -n "$line" ]; do
    case "$line" in
      ''|'#'*) continue ;;
    esac
    printf '%s\n' "$line"
  done < "$MANIFEST_FILE"
}

repo_path_for() {
  printf '%s/%s\n' "$DOTFILES_ROOT" "$1"
}

home_path_for() {
  printf '%s/%s\n' "$HOME" "$1"
}

ensure_parent_dir() {
  mkdir -p "$(dirname "$1")"
}

path_is_excluded() {
  local rel_path pattern

  rel_path=$1

  while IFS= read -r pattern || [ -n "$pattern" ]; do
    case "$pattern" in
      ''|'#'*) continue ;;
    esac

    case "$rel_path" in
      $pattern) return 0 ;;
    esac
  done < "$UNMANAGED_FILE"

  return 1
}

symlink_matches() {
  [ -L "$1" ] && [ "$(readlink "$1")" = "$2" ]
}

path_kind() {
  if [ -L "$1" ]; then
    printf 'symlink\n'
  elif [ -d "$1" ]; then
    printf 'directory\n'
  elif [ -f "$1" ]; then
    printf 'file\n'
  elif [ -e "$1" ]; then
    printf 'other\n'
  else
    printf 'missing\n'
  fi
}

paths_match() {
  local left_kind right_kind

  left_kind=$(path_kind "$1")
  right_kind=$(path_kind "$2")

  if [ "$left_kind" != "$right_kind" ]; then
    return 1
  fi

  case "$left_kind" in
    file)
      cmp -s "$1" "$2"
      ;;
    directory)
      diff -qr "$1" "$2" >/dev/null
      ;;
    *)
      return 1
      ;;
  esac
}

normalize_rel_path() {
  local input rel

  input=$1

  case "$input" in
    "$HOME")
      die "path must name a file or directory inside \$HOME, not \$HOME itself"
      ;;
    "$HOME"/*)
      rel=${input#"$HOME"/}
      ;;
    /*)
      die "absolute path must be inside \$HOME"
      ;;
    *)
      rel=${input#./}
      ;;
  esac

  case "$rel" in
    ''|'.'|*'/../'*|../*|*/..|*'/./'*|./*|*/.)
      die "refusing ambiguous path: $input"
      ;;
  esac

  printf '%s\n' "$rel"
}

append_manifest_entry() {
  if grep -Fqx "$1" "$MANIFEST_FILE"; then
    return 0
  fi

  printf '\n%s\n' "$1" >> "$MANIFEST_FILE"
}

path_is_git_ignored() {
  git -C "$DOTFILES_ROOT" check-ignore -q -- "$1"
}
