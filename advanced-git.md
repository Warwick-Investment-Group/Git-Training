# Advanced Git Techniques

This document covers advanced Git techniques that will help Warwick Investment Group Data Science team members become more proficient with Git and handle complex scenarios.

## Rebasing vs. Merging

### When to Use Merge

Merge creates a new commit that combines changes from different branches:

```
A---B---C (main)
     \
      D---E (feature)
```

After merge:

```
A---B---C-------F (main)
     \         /
      D---E--- (feature)
```

**Best for:**
- Preserving complete history
- Public/shared branches
- When you want to see when features were integrated

### When to Use Rebase

Rebase replays your commits on top of another branch:

```
A---B---C (main)
     \
      D---E (feature)
```

After rebase:

```
A---B---C (main)
         \
          D'---E' (feature)
```

**Best for:**
- Keeping history linear and clean
- Before merging a feature branch
- When working on a private branch

### Rebase Commands

```bash
# Basic rebase
git checkout feature
git rebase main

# Interactive rebase (for rewriting history)
git rebase -i HEAD~3  # Rebase last 3 commits

# Rebase onto a specific commit
git rebase --onto main feature~3 feature

# Abort a rebase
git rebase --abort
```

## Interactive Rebasing

Interactive rebasing is powerful for cleaning up your commit history before sharing it.

```bash
git rebase -i HEAD~5  # Open interactive rebase for last 5 commits
```

This opens an editor where you can:

- `pick`: Keep the commit as is
- `reword`: Change the commit message
- `edit`: Pause to amend the commit
- `squash`: Combine with previous commit (keeps both messages)
- `fixup`: Combine with previous commit (discards message)
- `drop`: Remove the commit entirely
- `exec`: Run a command after the commit

### Example: Squashing Multiple Commits

Before pushing your changes, you can squash multiple related commits:

```bash
git rebase -i HEAD~3
```

Change:
```
pick abc123 Add initial query structure
pick def456 Fix column names
pick ghi789 Add performance optimization
```

To:
```
pick abc123 Add initial query structure
fixup def456 Fix column names
fixup ghi789 Add performance optimization
```

This combines all three commits into one.

## Cherry-picking

Cherry-picking allows you to apply specific commits from one branch to another.

```bash
# Apply a single commit to current branch
git cherry-pick abc123

# Apply multiple commits
git cherry-pick abc123 def456

# Cherry-pick a commit without committing
git cherry-pick -n abc123

# Cherry-pick a range of commits
git cherry-pick abc123^..def456
```

**Use cases:**
- Backporting fixes to release branches
- Applying specific features from development to production
- Recovering lost work

## Advanced Branching Strategies

### Git Flow

A structured branching model with five branch types:

1. **main**: Production-ready code
2. **develop**: Integration branch for features
3. **feature/***: New features
4. **release/***: Preparing for release
5. **hotfix/***: Emergency fixes for production

### GitHub Flow

A simpler alternative:

1. **main**: Always deployable
2. **feature/***: All new work (features, fixes, etc.)

### Warwick Investment Group Recommended Flow

For data science projects:

1. **main**: Production-ready code
2. **develop**: Integration and testing
3. **feature/analysis-***: New analyses
4. **feature/model-***: New models
5. **feature/data-***: Data pipeline work
6. **hotfix/***: Emergency production fixes

## Stashing Advanced Usage

Stashing lets you save changes without committing them.

```bash
# Create a stash with description
git stash push -m "Working on customer segmentation"

# List stashes
git stash list

# Show stash contents
git stash show -p stash@{0}

# Apply stash without removing it
git stash apply stash@{0}

# Create a branch from a stash
git stash branch new-branch stash@{0}

# Apply only specific files from a stash
git checkout stash@{0} -- path/to/file.sql

# Stash untracked files too
git stash -u

# Stash only specific files
git stash push path/to/file1.sql path/to/file2.sql

# Remove a specific stash
git stash drop stash@{1}
```

## Git Hooks

Git hooks are scripts that run automatically when specific Git events occur.

### Important Hooks

- **pre-commit**: Runs before a commit is created
- **commit-msg**: Validates commit messages
- **pre-push**: Runs before pushing to a remote
- **post-merge**: Runs after a merge is completed
- **pre-rebase**: Runs before rebasing

### Example: SQL Validation Hook

Create `.git/hooks/pre-commit`:

```bash
#!/bin/bash

# Check SQL files for syntax errors before committing
for file in $(git diff --cached --name-only | grep -E '\.sql$')
do
    # Run a basic syntax check
    # Replace with appropriate SQL validator for your environment
    sqlformat --check $file
    if [ $? -ne 0 ]; then
        echo "Error: SQL syntax error in $file"
        exit 1
    fi
done

# Run custom SQL linting rules
for file in $(git diff --cached --name-only | grep -E '\.sql$')
do
    # Check for SELECT *
    if grep -q "SELECT \*" "$file"; then
        echo "Error: 'SELECT *' found in $file. Please specify columns explicitly."
        exit 1
    fi
    
    # Check for missing WHERE clause in UPDATE/DELETE
    if grep -q "UPDATE .* SET" "$file" && ! grep -q "UPDATE .* SET .* WHERE" "$file"; then
        echo "Warning: UPDATE without WHERE clause in $file"
        exit 1
    fi
    
    if grep -q "DELETE FROM" "$file" && ! grep -q "DELETE FROM .* WHERE" "$file"; then
        echo "Warning: DELETE without WHERE clause in $file"
        exit 1
    fi
done

exit 0
```

Make it executable:
```bash
chmod +x .git/hooks/pre-commit
```

### Commit Message Template Hook

Create `.git/hooks/commit-msg`:

```bash
#!/bin/bash

# Define commit message format
COMMIT_MSG_FILE=$1
COMMIT_MSG=$(cat $COMMIT_MSG_FILE)

# Check for standard format
if ! grep -qE "^\[(SQL|ETL|ANALYSIS|MODEL|DASH|DOC|CONFIG)\] .+: .+" "$COMMIT_MSG_FILE"; then
    echo "Error: Commit message doesn't follow the standard format."
    echo "Format should be: [TYPE] Component: Description"
    echo "Types: SQL, ETL, ANALYSIS, MODEL, DASH, DOC, CONFIG"
    echo ""
    echo "Examples:"
    echo "  [SQL] Customer Analysis: Add lifetime value calculation"
    echo "  [MODEL] Price Forecast: Improve ARIMA parameter selection"
    exit 1
fi

exit 0
```

## Submodules

Submodules allow you to include other Git repositories within your repository.

```bash
# Add a submodule
git submodule add https://github.com/WarwickInvestmentGroup/common-sql-utils.git utils/sql

# Initialize submodules after cloning
git submodule init
git submodule update

# Clone repository with submodules
git clone --recurse-submodules https://github.com/WarwickInvestmentGroup/data-project.git

# Update all submodules
git submodule update --remote

# Execute a command in each submodule
git submodule foreach 'git checkout main && git pull'
```

### When to Use Submodules

- Shared SQL utility functions
- Common data transformation scripts
- Standard visualization modules
- Reusable model components

## Git Bisect for Debugging

Git bisect helps you find which commit introduced a bug through binary search.

```bash
# Start bisect session
git bisect start

# Mark current version as bad
git bisect bad

# Mark a known good version
git bisect good v1.0

# Git will checkout a commit in the middle
# Test it and mark as good or bad
git bisect good  # or git bisect bad

# Continue until Git finds the problematic commit
# When done
git bisect reset
```

### Automated Bisect

```bash
# Automate with a test script
git bisect start
git bisect bad
git bisect good v1.0
git bisect run python test_script.py
```

## Advanced Git Log

```bash
# Show graph of branches
git log --graph --oneline --all --decorate

# Search for specific changes
git log -S "SELECT * FROM customers"

# Search commit messages
git log --grep="fix bug"

# Filter by author
git log --author="John Smith"

# See changes to specific files
git log --follow -- path/to/file.sql

# Show statistics
git log --stat

# Show changes in each commit
git log -p

# Custom formatting
git log --pretty=format:"%h - %an, %ar : %s"

# Filter by date
git log --after="2025-01-01" --before="2025-03-31"
```

## Refspecs and Remote Management

```bash
# Add a remote
git remote add upstream https://github.com/WarwickInvestmentGroup/original-repo.git

# Fetch specific branch from remote
git fetch origin feature/specific-branch

# Push to specific remote branch
git push origin local-branch:remote-branch

# Delete remote branch
git push origin --delete feature/old-branch

# Track remote branch
git checkout --track origin/feature/new-feature

# Update remote URL
git remote set-url origin new-url
```

## Git Worktrees

Worktrees allow you to check out multiple branches simultaneously in different directories.

```bash
# Add a worktree for a branch
git worktree add ../project-hotfix hotfix/urgent-fix

# List worktrees
git worktree list

# Remove a worktree
git worktree remove ../project-hotfix
```

## Git Rerere (Reuse Recorded Resolution)

Git rerere remembers how you resolved conflicts so it can automatically resolve them in the future.

```bash
# Enable rerere
git config --global rerere.enabled true

# When you encounter a conflict, resolve it manually
# Git will record your resolution

# Next time you encounter the same conflict
# Git will automatically resolve it
```

## Git Filter-branch and BFG

For removing sensitive data from repository history:

```bash
# Using filter-branch (slower but built-in)
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch path/to/sensitive/file.txt" \
  --prune-empty --tag-name-filter cat -- --all

# Using BFG (faster, requires Java)
# First, install BFG: https://rtyley.github.io/bfg-repo-cleaner/
bfg --delete-files id_rsa
```

## Git Attributes

`.gitattributes` file controls how Git handles specific files:

```
# Auto-detect text files and normalize line endings
* text=auto

# SQL files should always have LF line endings
*.sql text eol=lf

# Don't diff binary files
*.xlsx binary
*.pbix binary

# Custom diff for SQL
*.sql diff=sql

# Merge driver for specific files
database/schema.sql merge=ours
```

## SQL-Specific Git Configurations

```bash
# Set up custom diff for SQL files
git config --global diff.sql.textconv "sqlformat --reindent --keywords upper --identifiers lower"

# Configure merge driver for schema files
git config --global merge.ours.driver "true"
```

## Secret Management

Best practices for handling secrets in Git repositories:

1. **Never commit secrets** - Use environment variables or secret management tools
2. **Use .gitignore** - Ensure sensitive files are ignored
3. **Consider git-secret or git-crypt** for encrypted secrets
4. **Use CI/CD variables** for deployment secrets
5. **Rotate credentials** if accidentally committed

## Advanced Git Configurations

```bash
# Set default branch name
git config --global init.defaultBranch main

# Auto-correct typos
git config --global help.autocorrect 20

# Custom log format
git config --global alias.lg "log --color --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit"

# Automatically prune remote branches on fetch/pull
git config --global fetch.prune true
git config --global pull.prune true

# Cache credentials
git config --global credential.helper cache

# Set up SSH key
git config --global core.sshCommand "ssh -i ~/.ssh/id_ed25519_warwick"
```

## Recover Lost Work

```bash
# Find dangling commits (garbage collection hasn't run yet)
git fsck --no-reflogs | grep commit

# View content of dangling commit
git show <commit-hash>

# Recover a lost commit
git cherry-pick <commit-hash>

# Recover a deleted branch (if you know the commit hash)
git checkout -b recovered-branch <commit-hash>

# Find lost work in reflog
git reflog
git checkout HEAD@{5}  # Go back 5 operations
```

## Useful Tools for Git Workflows

- **[GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)** - VS Code extension
- **[GitHub Desktop](