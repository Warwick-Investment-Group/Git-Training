# Git Training for Warwick Investment Group

Welcome to the Git training repository for the Warwick Data Science team. This repository is designed to help data professionals learn the fundamentals of Git version control and establish best practices for collaborative data science work.

## Learning Objectives

By the end of this training, you will be able to:
- Understand the purpose and benefits of version control
- Set up Git on your machine
- Perform basic Git operations
- Collaborate with team members using Git
- Apply Git best practices to data science workflows
- Troubleshoot common Git issues

## Git Introduction

### What is Git?

Git is a distributed version control system that allows multiple people to work on a project simultaneously without overwriting each other's changes. Unlike centralized version control systems, Git gives each developer a local copy of the entire project history, making operations fast and allowing for work without an internet connection.

### Origins

Git was created by Linus Torvalds in 2005 for the development of the Linux kernel. Frustrated with existing version control systems, Torvalds designed Git to be:
- Fast
- Simple in design
- Strongly supportive of non-linear development (thousands of parallel branches)
- Fully distributed
- Able to handle large projects efficiently

### Why Git is Popular in Teams Worldwide

Git has become the industry standard for version control because it:
- Enables seamless collaboration across teams
- Provides a complete history of changes
- Supports branching and merging with minimal overhead
- Allows for easy experimentation without risk to production code
- Integrates with modern development workflows and tools
- Scales from small projects to enterprise-level operations

### Benefits for Data Science Teams

For data science teams like ours at Warwick, Git offers specific advantages:
- Tracking changes to data pipelines and SQL scripts
- Reproducing analysis from specific points in time
- Collaborating on models without code conflicts
- Managing different versions of dashboards and reports
- Creating an audit trail for compliance and governance
- Facilitating code reviews to maintain quality standards

## Installation Guide

### Prerequisites
- A computer with Windows, macOS, or Linux
- Administrative access or permission to install software
- Basic familiarity with command line interfaces

### Installing Git

#### Windows (Command Prompt/PowerShell)

Option 1: Using the installer
1. Download the installer from [git-scm.com](https://git-scm.com/download/win)
2. Run the installer and follow the prompts
3. Select recommended settings unless you have specific preferences

Option 2: Using Chocolatey (Windows package manager)
```powershell
choco install git
```

#### macOS (Terminal)

Option 1: Using the installer
1. Download the installer from [git-scm.com](https://git-scm.com/download/mac)
2. Run the installer and follow the prompts

Option 2: Using Homebrew
```bash
brew install git
```

Option 3: Using built-in Git (macOS may come with Git pre-installed)

#### Linux (Bash)

For Debian/Ubuntu-based distributions:
```bash
sudo apt update
sudo apt install git
```
### Verifying Installation

After installation, verify Git is properly installed by opening your terminal or command prompt and typing:
```bash
git --version
```

You should see output showing the installed Git version, such as `git version 2.35.1`.

## Git Basics

### Initial Configuration

Before using Git, configure your identity. This information will be included with every commit you make:

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@warwickinvestmentgroup.com"
```

Optional configurations that can be helpful:
```bash
# Set your default editor (replace with your preferred editor)
git config --global core.editor "code --wait"

# Set default branch name to main
git config --global init.defaultBranch main
```

### Core Concepts

- **Repository**: A collection of files and their history
- **Commit**: A snapshot of your files at a specific point in time
- **Branch**: A parallel version of the repository
- **Remote**: A version of the repository hosted on a server (like GitHub)
- **Clone**: Creating a local copy of a remote repository
- **Push**: Sending your commits to a remote repository
- **Pull**: Getting changes from a remote repository
- **Merge**: Combining changes from different branches

### Basic Workflow

1. **Clone the repository**
   ```bash
   git clone https://github.com/WarwickInvestmentGroup/git-training.git
   cd git-training
   ```

2. **Check repository status**
   ```bash
   git status
   ```

3. **Create a new branch for your work**
   ```bash
   git checkout -b feature/your-name-exercise
   ```

4. **Make changes to files**
   - Edit the SQL scripts in the `exercises` folder

5. **Check what changes you've made**
   ```bash
   git diff
   ```

6. **Stage changes for commit**
   ```bash
   git add exercises/your-modified-file.sql
   ```

7. **Commit your changes with a descriptive message**
   ```bash
   git commit -m "Add filtering logic to customer analysis query"
   ```

8. **Push your branch to the remote repository**
   ```bash
   git push -u origin feature/your-name-exercise
   ```

9. **Create a pull request** (through GitHub web interface)

10. **Merge your changes** (after review)

## Hands-on Exercises

This repository contains several exercises to help you practice Git commands and workflows. Each exercise builds on the previous one, gradually introducing more advanced concepts.

### Exercise 1: Setup and First Commit
1. Clone this repository
2. Create a new branch with your name
3. Edit the `exercises/01-introduction.sql` file to add your name and date
4. Commit and push your changes
5. Create a pull request

### Exercise 2: Working with Branches
1. Create a new branch from your previous branch
2. Modify the `exercises/02-branches.sql` file
3. Commit and push your changes
4. Create a pull request to merge into your original branch

### Exercise 3: Resolving Conflicts
1. Work with a partner on the same file
2. Deliberately create a conflict
3. Resolve the conflict using Git commands
4. Document your process

### Exercise 4: SQL Script Versioning
1. Improve the query in `exercises/04-query-optimization.sql`
2. Make multiple commits showing your thought process
3. Use commit messages to explain your reasoning

### Exercise 5: Collaborative Workflow
1. Review another team member's pull request
2. Suggest changes using GitHub's review features
3. Approve and merge the pull request

## Git Workflows for Data Science

### Feature Branch Workflow

At Warwick Investment Group, we follow a feature branch workflow:
1. Create a new branch for each feature or analysis
2. Make changes in your branch
3. Create a pull request when ready
4. Get code reviewed by peers
5. Merge into the main branch

### Data Analysis Workflow Best Practices

- Commit early and often
- Use descriptive commit messages
- Break large analyses into smaller, logical commits
- Include context in commit messages (why, not just what)
- Reference ticket/issue numbers in commit messages

### SQL Script Management

- Keep one query per file for better version control
- Comment your SQL code thoroughly
- Include execution context in file headers
- Test queries before committing
- Document performance considerations

## Next Steps

After completing these exercises, explore these additional resources:
- [Git-Shortcuts.md](./Git-Shortcuts.md): Time-saving Git commands and aliases
- [Common-Issues.md](./Common-Issues.md): Solutions to frequent Git problems
- [Advanced-Git.md](./Advanced-Git.md): More advanced Git techniques
- [Git-for-SQL.md](./Git-for-SQL.md): Best practices for versioning SQL code

## Additional Resources

### Recommended Tools
- **Visual Studio Code**: Git integration with GUI interface
- **GitHub Desktop**: Simplified Git client for beginners
- **GitKraken**: Powerful Git GUI for visual learners
- **Fork**: User-friendly Git client

### Helpful Links
- [Pro Git Book](https://git-scm.com/book/en/v2) - Comprehensive Git documentation
- [GitHub Learning Lab](https://github.com/apps/github-learning-lab) - Interactive Git tutorials
- [Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf) - Quick reference
- [Oh Shit, Git!](https://ohshitgit.com/) - Recovering from common mistakes

## Contribution Guidelines

If you find issues or have suggestions for improving this training material, please:
1. Create an issue describing the problem or enhancement
2. Submit a pull request with your proposed changes

---

*This training repository was created by the Warwick Investment Group Data Science Team.*