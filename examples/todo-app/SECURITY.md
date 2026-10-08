# Security

## Report a vulnerability

Report a vulnerability through a private security advisory on this repository, not in a public issue. Include the steps to reproduce it and the browser you used. The owner replies within a week.

## What the app protects

- **Tasks stay on the device.** The app makes no network calls after it loads, and it stores tasks only in the browser's local storage on its own origin.
- **Task text is never run as code.** The app renders task text as text, and the Content-Security-Policy in `_headers` allows scripts only from the app's own origin.
- **Imports are checked.** An import file over 1 MB is refused, and each task is rebuilt from known fields.

## What it doesn't protect

Anyone with access to the browser profile can read the tasks, and an exported backup file is plain JSON. Keep backups where you'd keep any other personal file.
