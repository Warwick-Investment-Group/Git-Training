# Git Workflow Diagram for Warwick Investment Group

This document provides visual representations of our recommended Git workflows for data science projects at Warwick Investment Group.

## Basic Git Workflow

```
┌─────────────────┐         ┌─────────────────┐         ┌─────────────────┐
│                 │         │                 │         │                 │
│  Working        │  git    │  Staging        │  git    │  Local          │
│  Directory      │  add    │  Area           │  commit │  Repository     │
│                 │ ───────►│                 │ ───────►│                 │
│  (Your files)   │         │  (Ready to      │         │  (.git folder)  │
│                 │         │   commit)       │         │                 │
└─────────────────┘         └─────────────────┘         └─────────────────┘
                                                                  │
                                                                  │ git push
                                                                  ▼
                                                        ┌─────────────────┐
                                                        │     main     │
                           │               │
                           └───────┬───────┘
                                   │
                 ┌─────────────────┼─────────────────┐
                 │                 │                 │
    ┌────────────▼─────┐ ┌─────────▼────────┐ ┌─────▼──────────────┐
    │                  │ │                  │ │                    │
    │ feature/analysis │ │ feature/etl-pipe │ │ feature/dashboard │
    │                  │ │                  │ │                    │
    └────────┬─────────┘ └────────┬─────────┘ └─────────┬──────────┘
             │                    │                     │
   ┌─────────▼─────────┐ ┌────────▼────────┐  ┌────────▼──────────┐
   │  Data Scientist A │ │ Data Engineer B │  │ BI Developer C    │
   │  - Develop query  │ │ - Create ETL    │  │ - Create dashboard│
   │  - Add analysis   │ │ - Test pipeline │  │ - Add metrics     │
   │  - Document       │ │ - Add logging   │  │ - User testing    │
   └─────────┬─────────┘ └────────┬────────┘  └─────────┬─────────┘
             │                    │                     │
             └─────────┬──────────┘                     │
                       │                                │
             ┌─────────▼──────────┐                     │
             │                    │                     │
             │     Code Review    │◄────────────────────┘
             │                    │
             └─────────┬──────────┘
                       │
                       │ Pull Request Approved & Merged
                       ▼
            ┌────────────────────┐
            │                    │
            │        main        │
            │                    │
            └────────────────────┘
                       │
                       │ git tag v1.0.0
                       ▼
            ┌────────────────────┐
            │                    │
            │      Release       │
            │                    │
            └────────────────────┘
```

## Merge Conflict Resolution Process

```
              Your Branch                           Their Branch
                  │                                      │
                  ▼                                      ▼
┌─────────────────────────────┐             ┌─────────────────────────────┐
│ SELECT                      │             │ SELECT                      │
│   customer_id,              │             │   customer_id,              │
│   transaction_date,         │             │   transaction_date,         │
│   amount                    │             │   amount,                   │
│ FROM                        │             │   category                  │
│   transactions              │             │ FROM                        │
│ WHERE                       │             │   transactions              │
│   amount > 1000             │             │ WHERE                       │
└─────────────────────────────┘             │   amount > 500              │
                  │                         └─────────────────────────────┘
                  │                                      │
                  └──────────────┬───────────────────────┘
                                 │
                                 ▼
                ┌─────────────────────────────┐
                │ Auto-merge failed!          │
                │ Conflict in query.sql       │
                └─────────────────────────────┘
                                 │
                                 ▼
                ┌─────────────────────────────┐
                │ <<<<<<< HEAD               │
                │ SELECT                      │
                │   customer_id,              │
                │   transaction_date,         │
                │   amount                    │
                │ FROM                        │
                │   transactions              │
                │ WHERE                       │
                │   amount > 1000             │
                │ =======                     │
                │ SELECT                      │
                │   customer_id,              │
                │   transaction_date,         │
                │   amount,                   │
                │   category                  │
                │ FROM                        │
                │   transactions              │
                │ WHERE                       │
                │   amount > 500              │
                │ >>>>>>> their-branch        │
                └─────────────────────────────┘
                                 │
                                 ▼
                ┌─────────────────────────────┐
                │ # Manual resolution         │
                │ SELECT                      │
                │   customer_id,              │
                │   transaction_date,         │
                │   amount,                   │
                │   category                  │
                │ FROM                        │
                │   transactions              │
                │ WHERE                       │
                │   amount > 1000             │
                └─────────────────────────────┘
                                 │
                                 ▼
                ┌─────────────────────────────┐
                │ git add query.sql           │
                │ git commit                  │
                │ git push                    │
                └─────────────────────────────┘
```

## Git Lifecycle for SQL Analysis Projects

```
┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│  ┌────────────┐      ┌────────────┐      ┌─────────────┐               │
│  │            │      │            │      │             │               │
│  │  Planning  ├─────►│  Analysis  ├─────►│  Reporting  │               │
│  │            │      │            │      │             │               │
│  └────────────┘      └────────────┘      └─────────────┘               │
│                                                                         │
│  ┌────────────┐      ┌────────────┐      ┌─────────────┐               │
│  │ git init   │      │ git branch │      │ git merge   │               │
│  │ git clone  │      │ git add    │      │ git tag     │               │
│  │ git config │      │ git commit │      │ Pull Request│               │
│  └────────────┘      └────────────┘      └─────────────┘               │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘

┌─────────────────────────────────────────────────────────────────────────┐
│                                                                         │
│     ┌─────────────────────────────────────────────────────────┐        │
│     │                                                         │        │
│     │               Ongoing Maintenance & Updates             │        │
│     │                                                         │        │
│     └─────────────────────────────────────────────────────────┘        │
│                                                                         │
│     ┌─────────────┐      ┌─────────────┐      ┌─────────────┐          │
│     │ git pull    │      │ git rebase  │      │ git cherry- │          │
│     │ git fetch   │      │ git bisect  │      │  pick       │          │
│     │ git stash   │      │             │      │             │          │
│     └─────────────┘      └─────────────┘      └─────────────┘          │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

## GitHub Pull Request Workflow

```
┌──────────────────┐     ┌───────────────────┐     ┌─────────────────┐
│                  │     │                   │     │                 │
│ Create Branch    │────►│ Push Branch       │────►│ Create Pull     │
│                  │     │                   │     │ Request         │
└──────────────────┘     └───────────────────┘     └────────┬────────┘
                                                           │
┌──────────────────┐     ┌───────────────────┐     ┌──────▼─────────┐
│                  │     │                   │     │                 │
│ Merge to Main    │◄────│ Address Review    │◄────│ Code Review    │
│                  │     │ Comments          │     │ Process        │
└──────────────────┘     └───────────────────┘     └─────────────────┘
         │
         │
         ▼
┌──────────────────┐
│                  │
│ Delete Branch    │
│                  │
└──────────────────┘
```

## Warwick Investment Group's Data Science-Specific Workflow

```
┌───────────────────────────────────────────────────────────────────────┐
│                                                                       │
│                       ┌───────────────────┐                           │
│                       │                   │                           │
│                       │     main          │                           │
│                       │                   │                           │
│                       └─────────┬─────────┘                           │
│                                 │                                     │
│                                 │                                     │
│ ┌─────────────────┐   ┌─────────▼─────────┐   ┌─────────────────────┐ │
│ │                 │   │                   │   │                     │ │
│ │ develop         │◄──┤     release       │   │ hotfix/urgent-bug   │ │
│ │                 │   │                   │   │                     │ │
│ └────────┬────────┘   └───────────────────┘   └──────────┬──────────┘ │
│          │                                                │          │ │
│          │                                                │          │ │
│ ┌────────▼────────┐                              ┌────────▼──────────┐ │
│ │                 │                              │                   │ │
│ │ feature/data-   │                              │ Fix critical      │ │
│ │ science-projects│                              │ production issues │ │
│ └────────┬────────┘                              └───────────────────┘ │
│          │                                                             │
│ ┌────────▼────────────────────────────────────────────────┐           │
│ │                                                         │           │
│ │  Individual Data Science Projects                       │           │
│ │  - feature/customer-segmentation                        │           │
│ │  - feature/price-forecasting                            │           │
│ │  - feature/portfolio-optimization                       │           │
│ │  - feature/risk-analysis                                │           │
│ │                                                         │           │
│ └─────────────────────────────────────────────────────────┘           │
│                                                                       │
└───────────────────────────────────────────────────────────────────────┘
```

## Advanced Git Operations Visualization

```
┌────────────────────────────────────────────────────────────────────┐
│                                                                    │
│  ┌───────────┐    ┌───────────┐    ┌───────────┐    ┌───────────┐  │
│  │ Commit 1  │───►│ Commit 2  │───►│ Commit 3  │───►│ Commit 4  │  │
│  └───────────┘    └───────────┘    └───────────┘    └───────────┘  │
│                                                                    │
│  # Git Rebase                                                      │
│                                                                    │
│  ┌───────────┐    ┌───────────┐                                    │
│  │ Commit A  │───►│ Commit B  │                                    │
│  └───────────┘    └───────────┘                                    │
│                                                                    │
│  After rebase onto Commit 4:                                       │
│                                                                    │
│  ┌───────────┐    ┌───────────┐    ┌───────────┐    ┌───────────┐  │
│  │ Commit 1  │───►│ Commit 2  │───►│ Commit 3  │───►│ Commit 4  │  │
│  └───────────┘    └───────────┘    └───────────┘    └───────────┘  │
│                                                          │         │
│                                                          ▼         │
│                                                    ┌───────────┐   │
│                                                    │ Commit A' │   │
│                                                    └───────────┘   │
│                                                          │         │
│                                                          ▼         │
│                                                    ┌───────────┐   │
│                                                    │ Commit B' │   │
│                                                    └───────────┘   │
│                                                                    │
└────────────────────────────────────────────────────────────────────┘
```

---

*This document is maintained by the Warwick Investment Group Data Science Team.*            │
                                                        │  Remote         │
                                                        │  Repository     │
                                                        │                 │
                                                        │  (GitHub)       │
                                                        │                 │
                                                        └─────────────────┘
```

## Feature Branch Workflow

```
           ┌────────────┐
           │            │
  ┌────────▶   main     ├────────┐
  │        │            │        │
  │        └────────────┘        │
  │                              │
  │                              │ git checkout -b feature/new-query
  │                              │
  │                              ▼
  │                     ┌────────────────────┐
  │                     │                    │
  │                     │  feature/new-query │
  │                     │                    │
  │                     └────────────────────┘
  │                              │
  │                              │ git add, commit
  │                              ▼
  │                     ┌────────────────────┐
  │                     │                    │
  │                     │  feature/new-query │ ◄── Make changes
  │                     │                    │     Add more commits
  │                     └────────────────────┘
  │                              │
  │                              │ git push
  │                              ▼
  │                     ┌────────────────────┐
  │                     │                    │
  │                     │  Pull Request      │ ◄── Code review
  │                     │                    │
  │                     └────────────────────┘
  │                              │
  │                              │ Merge
  │                              ▼
  │        ┌────────────┐
  │        │            │
  └───────┐│   main     │
           │            │
           └────────────┘
```

## Data Science Team Workflow

```
                           ┌───────────────┐
                           │               │
                           │     