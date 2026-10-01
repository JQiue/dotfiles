#!/usr/bin/env bash
# linux.sh - deploy shared dotfiles on Linux.
#
# Creates symbolic links from this repo to their expected locations.
# Existing real files are moved to "<path>.backup" (or
# "<path>.backup.<timestamp>" if a backup already exists).
#
# Usage:
#   ./linux.sh
#   ./linux.sh --dry-run
set -euo pipefail

DOTFILES="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DRY_RUN=0

usage() {
    cat <<EOF
Usage: $(basename "$0") [--dry-run]

Deploy Linux-relevant dotfiles from this repo via symbolic links.
Existing real files are backed up instead of deleted.
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --dry-run|-n)
            DRY_RUN=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "unknown option: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

run() {
    if [[ "$DRY_RUN" -eq 1 ]]; then
        printf 'dry-run: %s\n' "$*"
        return 0
    fi
    "$@"
}

same_link() {
    local dest=$1
    local src=$2
    [[ -L "$dest" ]] || return 1
    local current
    current="$(readlink -- "$dest")"
    [[ "$current" == "$src" ]]
}

link_file() {
    local source=$1
    local destination=$2

    if [[ ! -e "$source" ]]; then
        echo "skip (source missing): $source" >&2
        return 0
    fi

    local dest_dir
    dest_dir="$(dirname -- "$destination")"
    if [[ ! -d "$dest_dir" ]]; then
        run mkdir -p -- "$dest_dir"
    fi

    if [[ -L "$destination" || -e "$destination" ]]; then
        if same_link "$destination" "$source"; then
            echo "skip (already linked): $destination"
            return 0
        fi
        if [[ -L "$destination" ]]; then
            run rm -- "$destination"
        elif [[ -f "$destination" ]]; then
            local backup="${destination}.backup"
            if [[ -e "$backup" ]]; then
                backup="${destination}.backup.$(date +%Y%m%d%H%M%S)"
            fi
            run mv -- "$destination" "$backup"
            echo "backup: $destination -> $backup"
        else
            echo "skip (not a regular file): $destination" >&2
            return 1
        fi
    fi

    run ln -s -- "$source" "$destination"
    echo "link:   $destination -> $source"
}

HOME_DIR="${HOME}"

link_file "$DOTFILES/.gitconfig" "$HOME_DIR/.gitconfig"
link_file "$DOTFILES/.npmrc" "$HOME_DIR/.npmrc"
link_file "$DOTFILES/cargo.toml" "$HOME_DIR/.cargo/config.toml"
link_file "$DOTFILES/config.fish" "$HOME_DIR/.config/fish/config.fish"

echo
echo "Done."

