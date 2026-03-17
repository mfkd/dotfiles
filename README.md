# dotfiles

This repo is the source of truth for stable home-directory configuration. Managed
paths are listed in `managed-paths.txt` and are linked into `$HOME` from this
repo. Machine-local overrides and secrets stay out of git.

## Workflow

- Edit the repo copy, not the file in `$HOME`.
- Run `script/status` to see drift and missing links.
- Run `script/link` to create or repair symlinks for managed paths.
- Run `script/capture <path>` to adopt a new stable config path into the repo.
- Run `script/list` to print the current managed path set.

`script/link` stores replaced home files in
`$HOME/.local/state/dotfiles-backups/<timestamp>/`.
It preflights the full manifest first and applies no changes if any conflicts are
found.

## Local Overrides

These files are intentionally untracked and may vary by machine:

- `~/.gitconfig.local`
- `~/.profile.local`
- `~/.zprofile.local`
- `~/.zshenv.local`
- `~/.zshrc.local`
- `~/.config/fish/conf.d/99-local.fish`

Git, Zsh, and shell profile entrypoints load these files only when present.
Create `~/.gitconfig.local` on each machine with your machine-specific Git
identity, for example:

```ini
[user]
    email = you@example.com
```

## Notes

- Secrets, tokens, caches, and host state are excluded by default.
- If you want to manage sensitive files later, add an encrypted workflow rather
  than putting them directly in git.
