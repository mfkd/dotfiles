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

- `~/.profile.local`
- `~/.zprofile.local`
- `~/.zshenv.local`
- `~/.zshrc.local`
- `~/.config/fish/conf.d/99-local.fish`

Git, Zsh, and shell profile entrypoints load these files only when present.

## Hammerspoon

Hyper is Control + Option + Command + Shift. Hyper+Q requests a graceful quit
of all regular Dock apps, including hidden apps and apps on other Spaces. Finder,
Hammerspoon, menu-bar apps, and background utilities stay running. Apps may prompt
to save changes or refuse to quit; the action never force-quits them.

Add bundle IDs to `quitExclusions` in `.hammerspoon/init.lua` to keep other apps
running. Hyper+X launches or toggles FaceTime.

The implementation uses Hammerspoon's documented
[`runningApplications()`](https://www.hammerspoon.org/docs/hs.application.html#runningApplications),
[`kind()`](https://www.hammerspoon.org/docs/hs.application.html#kind), and
[`kill()`](https://www.hammerspoon.org/docs/hs.application.html#kill) APIs. Its scope
follows the same policy as Bunch's
[Quit Everything command](https://bunchapp.co/docs/bunch-files/commands/quit-everything/):
Dock apps with an exclusion list, leaving Finder and background utilities running.

## Notes

- Secrets, tokens, caches, and host state are excluded by default.
- If you want to manage sensitive files later, add an encrypted workflow rather
  than putting them directly in git.
