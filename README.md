## Git Commit Script

## Getting Started
You can run the script with either `bash` or `sh` command:

```bash
bash git_commit.sh
# or
sh git_commit.sh
```

### This will give you:
- A Git status
- A detailed summary of changes before committing
- Detection and inclusion of untracked files
- Automatic addition of `README.md` if modified
- Proper stash handling to prevent unwanted file restoration

### Features

- Displays `git status` before committing.
- Detects and includes untracked files if user agrees.
- **Ensures `README.md` is always added if modified**.
- Fetches latest changes from the remote repository to prevent conflicts.
- **Cross-platform notifications**:
  - **Linux**: Uses `notify-send`.
  - **macOS**: Uses `osascript`.
  - **Windows**: Uses PowerShell popup.
- Logs commit history (`~/.local_commit_history.log`).
- Detects the current branch and allows switching.
- Stashes uncommitted changes temporarily to avoid conflicts and restores them properly.
- **Shows a detailed summary of modified, new, and deleted files before pushing**.
- Optionally asks the user if they want to push the changes after committing.
- Ends with a **random programming joke** 🎭.

## Prerequisites

- **Git** must be installed and configured.
- **Notifications**:
  - **Linux**: Ensure `notify-send` is installed (`sudo apt install libnotify-bin`).
  - **macOS**: Native notifications via `osascript`.
  - **Windows**: Uses PowerShell for notifications.
- **SSH Authentication**:
  - Ensure your SSH key is added to `ssh-agent`.
  - The script will automatically check if `ssh-agent` is running and start it if necessary.

## Installation

1. **Make the script executable** (only needed once):
   ```sh
   chmod +x git_commit.sh
   ```
2. **Run the script**:
   ```sh
   ./git_commit.sh
   ```

## Usage

1. **Follow the prompts**:
   - Enter the files you want to add (use `.` to add all changes).
   - Provide a commit message (or use the default message).
   - The script will wait 3 seconds before committing.
2. **Choose to push or not**.
   - If confirmed, it will execute `git push` automatically.

## Troubleshooting

- **Git not found**: Install Git using:
  ```sh
  sudo apt install git  # Ubuntu/Debian
  brew install git      # macOS (Homebrew)
  ```
- **Notifications not working**:
  - **Linux**: Ensure `notify-send` is installed.
  - **Windows**: Ensure PowerShell is enabled.
  - **macOS**: Notifications should work by default.
- **Ensure you're inside a valid Git repository** before running the script.
- **SSH Issues**:
  - Ensure your SSH key is added using `ssh-add -l`.
  - If your SSH agent is not running, restart it manually with:
    ```sh
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_rsa
    ```

## Future Enhancements

- Add more automation features like `pre-commit` hooks.
- Provide a configuration file for setting defaults.
- Extend interactive menu with more Git commands.

## License

This script is open-source and free to use under the MIT License. Contributions are welcome!

