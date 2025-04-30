# Common Git Issues and Solutions

This document addresses frequent Git challenges that Warwick team members may encounter and provides straightforward solutions.

## Undoing Mistakes

### "I committed to the wrong branch!"

**Solution:**
```bash
# Create a new branch at your current position
git branch new-correct-branch

# Move the mistaken commit to the correct branch
git checkout correct-branch
git cherry-pick <commit-hash>

# Remove the commit from the wrong branch
git checkout wrong-branch
git reset --hard HEAD~1  # Be careful! This removes the commit
```

### "I need to undo my last commit but keep the changes"

**Solution:**
```bash
git reset --soft HEAD~1
```
This keeps your changes staged but uncommitted.

### "I need to completely undo my last commit and discard changes"

**Solution:**
```bash
git reset --hard HEAD~1
```
⚠️ Warning: This permanently discards changes. Use with caution.

### "I pushed something sensitive to the repository!"

**Solution:**
1. Remove the sensitive data from your latest commit:
   ```bash
   git rm --cached sensitive_file.txt
   git commit --amend -m "Remove sensitive data"
   ```

2. Force push to update the remote repository:
   ```bash
   git push --force origin main
   ```

3. Contact your Git administrator to:
   - Remove the file from Git history
   - Update the .gitignore to prevent future accidental commits
   - Consider using tools like BFG Repo-Cleaner for thorough cleanup

### "I need to undo a specific commit from days/weeks ago"

**Solution:**
```bash
# Create a new commit that reverses the unwanted commit
git revert <commit-hash>
```

## Merge Conflicts

### "I have merge conflicts! How do I handle them?"

**Solution:**

1. Identify which files have conflicts:
   ```bash
   git status
   ```

2. Open each conflicted file and look for conflict markers:
   ```
   <<<<<<< HEAD
   Current branch code
   =======
   Incoming branch code
   >>>>>>> feature/branch-name
   ```

3. Edit the file to resolve conflicts (choose one version or combine both)

4. Stage the resolved files:
   ```bash
   git add resolved-file.sql
   ```

5. Complete the merge:
   ```bash
   git commit
   ```

### "How do I abort a merge with conflicts?"

**Solution:**
```bash
git merge --abort
```
This returns you to the state before the merge began.

### "My merge conflict is too complex to resolve manually"

**Solution:**
1. Use a visual merge tool:
   ```bash
   git mergetool
   ```

2. Or, if you prefer a specific tool:
   ```bash
   git mergetool --tool=vscode
   ```

## Branch Issues

### "I created a branch from the wrong base!"

**Solution:**
```bash
# Assuming you want to base off 'main' instead
git checkout your-branch
git reset --hard main
# Now re-apply your commits or make new changes
```

### "I need to update my branch with changes from main"

**Solution 1 (Merge)**:
```bash
git checkout your-branch
git merge main
```

**Solution 2 (Rebase - preferred for cleaner history)**:
```bash
git checkout your-branch
git rebase main
```

### "My branch is completely broken; I need to start over"

**Solution:**
```bash
git checkout main
git branch -D broken-branch
git checkout -b new-branch
```

## Commit Issues

### "I forgot to add a file to my last commit"

**Solution:**
```bash
git add forgotten-file.sql
git commit --amend --no-edit
```

### "I committed with the wrong message"

**Solution:**
```bash
git commit --amend -m "New correct message"
```

### "I have a bunch of WIP commits I want to clean up"

**Solution:**
```bash
# Interactive rebase to clean up the last 3 commits
git rebase -i HEAD~3
```
In the editor, replace "pick" with:
- `squash` or `s` to combine commits
- `reword` or `r` to change commit messages
- `drop` or `d` to remove commits
- `edit` or `e` to stop for amending

## Push/Pull Issues

### "I can't push because someone else pushed changes"

**Solution:**
```bash
# Pull first, then push
git pull origin branch-name
git push origin branch-name
```

### "I get 'refusing to merge unrelated histories' error"

**Solution:**
```bash
git pull origin branch-name --allow-unrelated-histories
```

### "I get 'fatal: refusing to merge unrelated histories' when pulling"

**Solution:**
This usually happens when a repository has been initialized both locally and remotely. Either:

```bash
# Option 1: Allow unrelated histories
git pull origin main --allow-unrelated-histories

# Option 2: Better option - clone fresh
git clone <repository-url> temp-dir
cp -r temp-dir/.git/ your-project/.git/
```

## Authentication Issues

### "Git keeps asking for my password every time"

**Solution:**
1. Setup credential caching:
   ```bash
   git config --global credential.helper cache
   ```

2. For longer timeout (e.g., 1 hour):
   ```bash
   git config --global credential.helper 'cache --timeout=3600'
   ```

3. For permanent storage (more convenient but less secure):
   ```bash
   git config --global credential.helper store
   ```

4. Better yet, set up SSH keys:
   ```bash
   # Generate SSH key
   ssh-keygen -t ed25519 -C "your.email@warwickinvestmentgroup.com"
   
   # Copy your public key to clipboard (Mac)
   pbcopy < ~/.ssh/id_ed25519.pub
   
   # Or for Windows
   type %userprofile%\.ssh\id_ed25519.pub | clip
   ```
   Then add this key to your GitHub account in settings.

### "I'm getting 'Permission denied (publickey)' error"

**Solution:**
Verify your SSH setup:
```bash
# Test SSH connection
ssh -T git@github.com

# Check what keys SSH is finding
ssh-add -l

# Add your key if needed
ssh-add ~/.ssh/id_ed25519
```

## File Issues

### "I need to ignore changes to a tracked file"

**Solution:**
```bash
# Ignore changes to a specific file
git update-index --skip-worktree config.ini

# To stop ignoring
git update-index --no-skip-