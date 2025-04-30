# Git Shortcuts and Productivity Tips

This document contains time-saving shortcuts, aliases, and techniques to make your Git workflow more efficient at Warwick Investment Group.

## Git Aliases

Git aliases allow you to create shortcuts for frequently used commands. Add these to your Git configuration to save time.

### How to Configure Aliases

You can add aliases in two ways:

1. **Command line**:
   ```bash
   git config --global alias.co checkout
   git config --global alias.br branch
   git config --global alias.ci commit
   git config --global alias.st status
   ```

2. **Edit your `.gitconfig` file** directly:
   ```
   [alias]
       co = checkout
       br = branch
       ci = commit
       st = status
   ```

### Essential Aliases for Data Science Work

```
[alias]
    # Basic shortcuts
    co = checkout
    br = branch
    ci = commit
    st = status
    
    # Log viewing
    lol = log --graph --decorate --pretty=oneline --abbrev-commit
    lola = log --graph --decorate --pretty=oneline --abbrev-commit --all
    
    # Show changes
    df = diff
    dfs = diff --staged
    
    # Branch management
    brd = branch -d
    brD = branch -D
    
    # Commit shortcuts
    amend = commit --amend
    undo = reset HEAD~1 --mixed
    
    # Data science specific
    # Show changes in SQL files only
    sql-diff = diff -- '*.sql'
    
    # Quick status of data pipeline files
    pipe-status = status -- 'pipelines/*'
    
    # Stash operations
    save = stash push -m
    pop = stash pop
    
    # Show modifications by colleague
    who = shortlog -s --
```

## Command Line Shortcuts

### Bash/Zsh Shortcuts

Add these to your `.bashrc`, `.zshrc`, or equivalent shell configuration file:

```bash
# Git shortcuts
alias g='git'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias gl='git pull'
alias gs='git status'
alias gd='git diff'
alias gco='git checkout'
alias gb='git branch'
alias gm='git merge'
alias glo='git log --oneline --graph'

# Common Git workflows
alias gnew='git checkout -b'
alias gpush='git push origin $(git branch --show-current)'
alias gupdate='git pull origin $(git branch --show-current)'
```

## Time-Saving Techniques

### Interactive Adding

Add parts of files selectively:
```bash
git add -p
```
This will prompt you to review each change and decide whether to stage it.

### Stashing Workflow

Save your work temporarily without committing:
```bash
# Save changes with a description
git stash save "work in progress on feature X"

# List all stashes
git stash list

# Apply most recent stash
git stash apply

# Apply specific stash
git stash apply stash@{2}

# Remove stash after applying
git stash pop

# Create a branch from a stash
git stash branch new-branch stash@{1}
```

### Quick Fixup

Fix previous commit without changing the commit message:
```bash
# Make your changes then
git commit --fixup=HEAD
git rebase -i --autosquash HEAD~2
```

### Search in Git History

Find commits that introduced or modified specific terms:
```bash
# Search for commits containing text in any file
git log -S "query_term"

# Search for commits containing text changes in specific files
git log -S "SELECT * FROM customers" -- *.sql

# Search for commits with messages containing text
git log --grep="fix bug"

# See who changed a specific line
git blame -L 10,20 filename.sql
```

### Temporary Commits

Create checkpoint commits that you can clean up later:
```bash
# Make a WIP commit
git commit -m "WIP: Implementing new dataset logic"

# After you're done, combine with previous commits
git rebase -i HEAD~3  # Replace 3 with number of commits to review
```

## PowerShell Shortcuts

For Windows users working with PowerShell:

```powershell
# Add to your PowerShell profile
function Get-GitStatus { git status }
New-Alias -Name gst -Value Get-GitStatus

function Invoke-GitCommit { git commit -m $args[0] }
New-Alias -Name gcm -Value Invoke-GitCommit

function Invoke-GitCheckout { git checkout $args[0] }
New-Alias -Name gco -Value Invoke-GitCheckout
```

## Visual Studio Code Shortcuts

If you use VS Code for SQL development:

1. **Source Control panel**: `Ctrl+Shift+G` (Windows/Linux) or `Cmd+Shift+G` (Mac)
2. **Stage changes**: `+` icon next to file
3. **Commit**: `Ctrl+Enter` in commit message box
4. **View diff**: Click on the file in source control panel
5. **Git commands**: `Ctrl+Shift+P` and type "Git"

## GitHub CLI Shortcuts

The GitHub CLI (`gh`) tool can streamline your workflow:

```bash
# Install GitHub CLI (one-time)
# For Windows: winget install --id GitHub.cli
# For Mac: brew install gh
# For Linux: apt/yum install gh

# Authenticate (one-time)
gh auth login

# Create a PR from current branch
gh pr create

# View PR status
gh pr status

# Review a PR
gh pr checkout 123
gh pr review --approve

# Merge a PR
gh pr merge 123
```

## Git Hooks for Data Science

Git hooks are scripts that run automatically when specific events occur. Here are some useful hooks for data science work:

### Pre-commit Hook for SQL Validation

Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash

# Check SQL syntax before committing
for file in $(git diff --cached --name-only | grep -E '\.sql$')
do
    # Simple syntax check (replace with your preferred SQL linter)
    sqlformat --check $file
    if [ $? -ne 0 ]; then
        echo "Error: SQL syntax error in $file"
        exit 1
    fi
done
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

## Recommended Workflow for Warwick Investment Group

### Daily Routine

Start your day with:
```bash
git checkout main
git pull
git checkout your-feature-branch
git rebase main
```

End your day with (even if work is incomplete):
```bash
git add .
git commit -m "WIP: Description of current state"
git push origin your-feature-branch
```

### Code Review Process

When your code is ready for review:
```bash
# Update your branch with latest main
git checkout main
git pull
git checkout your-feature-branch
git rebase main

# Push your changes
git push origin your-feature-branch

# Create a pull request (using GitHub CLI)
gh pr create --title "Feature: Description" --body "Details about changes"
```

---

*This document is maintained by the Warwick Investment Group Data Science Team.*