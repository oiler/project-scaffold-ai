# Changelog

What shipped, for someone who uses it. The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [1.0.0] - 2026-10-01

### Added

- Todo App is live on Cloudflare Pages, on its own address.

### Security

- Import refuses files over 1 MB and task text over 1,000 characters.
- The app sends a Content-Security-Policy that allows scripts only from its own address.

## [0.3.0] - 2026-09-25

### Added

- **Export** downloads your list as a JSON file, and **Import** restores it after showing how many tasks it will replace.
- Import refuses a file that isn't a Todo App backup, says why, and leaves your list as it was.

## [0.2.0] - 2026-09-21

### Added

- Every action works from the keyboard, with a visible focus outline. Press `/` to jump to the add field.
- An **Edit** button on each task, so you can edit on a phone.

### Changed

- The layout fits a phone screen, with larger touch targets.

## [0.1.0] - 2026-09-16

### Added

- Add, finish, reopen, edit, and delete tasks. Your list is saved in the browser and is still there after a restart.
