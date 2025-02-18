#!/bin/sh

# Ensure commit_history.log is ignored
echo "commit_history.log" >> .gitignore
git rm --cached commit_history.log 2>/dev/null

# Ensure ssh-agent is running and add SSH key if not already added
if ! pgrep -u "$USER" ssh-agent > /dev/null; then
  echo "Starting ssh-agent... 🔑"
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_rsa  # Modify if using a different key
else
  echo "ssh-agent is already running. 🔄"
fi

# Check if the SSH key is added
if ! ssh-add -l | grep -q "id_rsa"; then
  echo "Adding SSH key... 🔏"
  ssh-add ~/.ssh/id_rsa  # Modify if using a different key
else
  echo "SSH key is already added. ✅"
fi

# Get project directory name
projectName=$(basename "$(git rev-parse --show-toplevel)")

# Get the current branch
currentBranch=$(git rev-parse --abbrev-ref HEAD)
echo "📂 Project: $projectName | 🌿 Branch: $currentBranch"

# Fetch latest changes to prevent conflicts
echo "🔄 Fetching latest changes from remote..."
git fetch origin "$currentBranch"

# Check for uncommitted changes & stash safely
stashNeeded=false
if ! git diff-index --quiet HEAD --; then
  echo "⚠️ You have uncommitted changes. Stashing them temporarily... 🔄"
  git stash push -m "Auto-stash before commit"
  stashNeeded=true
fi

# Show git status
git status

# Detect untracked files
untrackedFiles=$(git ls-files --others --exclude-standard)
if [ -n "$untrackedFiles" ]; then
  echo "🆕 Untracked files detected:"
  echo "$untrackedFiles"
  echo "Would you like to add all untracked files? (y/n)"
  read addUntracked
  if [ "$addUntracked" = "y" ]; then
    addFiles="."
  fi
fi

# Prompt user for files
if [ -z "$addFiles" ]; then
  echo "📄 Enter files to add (or '.' for all):"
  read addFiles
  if [ -z "$addFiles" ]; then
    echo "❌ No files specified. Exiting..."
    exit 1
  fi
fi

# Prompt for commit message
defaultCommitMessage="Update 🔄"
echo "📝 Enter commit message (Press Enter for default: '$defaultCommitMessage'):"
read commitMessage
commitMessage=${commitMessage:-$defaultCommitMessage}

# Wait before committing
echo "⏳ Waiting 3 seconds before committing..."
sleep 3

# Add and commit changes
git add "$addFiles"
if git commit -m "$commitMessage"; then
  echo "✅ Commit successful!"
else
  echo "❌ Commit failed! Please check for issues."
  exit 1
fi

# Restore stash if needed
if [ "$stashNeeded" = true ]; then
  echo "🔄 Restoring previous changes from stash..."
  git stash pop || echo "⚠️ Warning: Some changes couldn't be applied back."
fi

# Show detailed summary of changes before pushing
echo "📌 **Summary of Changes**"
echo "--------------------------------------"
echo "📝 Modified Files:"
git diff --name-only --cached
echo ""

echo "🆕 New (Untracked) Files:"
echo "$untrackedFiles"
echo ""

echo "🗑️ Deleted Files:"
git ls-files --deleted
echo "--------------------------------------"

# Log commit with project name, branch, and message
logFile="$HOME/.local_commit_history.log"
echo "$(date) | 📂 Project: $projectName | 🌿 Branch: $currentBranch | 📝 Commit: $commitMessage" >> "$logFile"

# Ensure commit history is ignored
echo "$logFile" >> .gitignore
git rm --cached "$logFile" 2>/dev/null

# Notify the user with emojis
notify_user() {
  case "$(uname)" in
    Linux) notify-send -i face-wink "🚀 Push Reminder" "Don't Forget To Push 📤" ;;
    Darwin) osascript -e 'display notification "🚀 Don'\''t Forget To Push 📤" with title "Git Reminder"' ;;
    CYGWIN*|MINGW32*|MSYS*|MINGW*) powershell.exe -Command '[System.Windows.Forms.MessageBox]::Show(\"🚀 Don'\''t Forget To Push 📤\", \"Git Reminder\")' ;;
    *) echo "🚀 Reminder: Don't forget to push your changes! 📤" ;;
  esac
}
notify_user

# Ask if the user wants to push
echo "🛠️ Would you like to push now? (y/n)"
read pushResponse
if [ "$pushResponse" = "y" ]; then
  echo "🚀 Pushing changes..."
  if git push; then
    echo "✅ Changes pushed successfully!"
  else
    echo "❌ Push failed! Check your network and remote repository settings."
  fi
else
  echo "⚠️ Remember to push your changes later. ⏳"
fi

echo "✅ Commit completed! 🎉"

# Display a funny programming joke
jokes=(
  "Why do programmers prefer dark mode? Because light attracts bugs! 🐛"
  "Why do Java developers wear glasses? Because they don't C#! 🤓"
  "Real programmers count from 0. Everyone else is off by one. 🔢"
  "Why was the JavaScript developer sad? Because he didn’t 'null' his feelings. 😆"
  "A SQL query walks into a bar, sees two tables and asks: 'Can I join you?' 🍻"
  "Debugging: Being the detective in a crime movie where you are also the murderer. 🔍💀"
  "Why do Python programmers love nature? Because they prefer beautiful over ugly. 🐍🌿"
)

# Pick a random joke
randomJoke=${jokes[$RANDOM % ${#jokes[@]}]}

echo "🤣 Programming Joke of the Day: $randomJoke"
