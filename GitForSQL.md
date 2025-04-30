# Git for SQL Development

This guide outlines best practices for using Git with SQL code at Warwick Investment Group, specifically focusing on how Data Science teams can effectively version control their SQL assets.

## SQL-Specific Challenges with Git

SQL development presents unique version control challenges:
- Schema changes can impact multiple files
- Query performance varies between environments
- Database state dependencies make testing difficult
- SQL lacks a standardized packaging/module system
- Comments and formatting differences can create noise in diffs

## SQL File Organization

### File Structure Best Practices

```
sql/
├── schemas/          # Database schema definitions
├── functions/        # Stored functions/procedures
├── views/            # View definitions
├── queries/          # Ad hoc analysis queries
│   ├── exploration/  # Exploratory queries
│   └── reporting/    # Production reporting queries
├── pipelines/        # ETL process queries
├── migrations/       # Schema migration scripts
└── tests/            # Testing queries
```

### Naming Conventions

- Use descriptive filenames: `customer_acquisition_metrics.sql` rather than `cam.sql`
- Include version or date in filenames when appropriate: `schema_v2.sql` or `daily_report_20250401.sql`
- Include purpose in filename: `update_customer_status.sql` vs `customer_query.sql`
- For script order dependencies, use numeric prefixes: `01_create_tables.sql`, `02_populate_data.sql`

## SQL Formatting Standards

Consistent formatting makes diffs meaningful and reviews easier:

- Align major clauses (SELECT, FROM, WHERE, etc.) to the start of the line
- Indent subqueries and expressions
- Use uppercase for SQL keywords
- Use consistent case for table/column names (prefer lowercase with underscores)
- Put each column on a new line in SELECT statements
- Use meaningful table aliases

Example:
```sql
SELECT 
    c.PROPNUM,
    c.WELLNAME,
    COUNT(o.STAGES) AS total_number_of_stages,
    SUM(o.VOLUME) AS total_fluid_volume
FROM 
    AC_PROPERTY c
JOIN 
    COMPLETIONS o ON c.PROPNUM = o.PROPNUM
WHERE 
    c.status = 'producing'
    AND o.frac_date >= '2025-01-01'
GROUP BY 
    c.PROPNUM,
    c.WELLNAME
HAVING 
    COUNT(o.STAGES) > 0
ORDER BY 
    o.frac_date DESC
```

## SQL File Header Template

Include a standardized header in SQL files:

```sql
/*
* File: customer_lifetime_value.sql
* Author: [Your Name]
* Created: 2025-04-29
* Updated: 2025-04-29
* 
* Description: Calculates customer lifetime value metrics for the marketing team
* 
* Usage: 
*   - Run against OLAP warehouse
*   - Parameters: start_date (YYYY-MM-DD), end_date (YYYY-MM-DD)
*   - Expected runtime: ~2 minutes on production data
* 
* Change history:
*   2025-04-29: Initial version
*/
```

## Commit Practices for SQL Development

### Commit Organization

- Keep schema changes separate from data manipulation changes
- Group related SQL files in a single commit
- Separate large schema changes into smaller, atomic commits
- Include test queries with schema changes

### Commit Message Template for SQL Changes

```
[SQL] <Area>: <Summary>

- Details of changes
- Performance implications
- Breaking changes

Related to: <ticket/issue reference>
```

Examples:
```
[SQL] Customer Analysis: Optimize lifetime value calculation

- Added indexes on order_date and customer_id
- Reduced query runtime from 2.5min to 15sec
- Changed output column names to match BI standards

Related to: DS-123
```

## Branching Strategy for SQL Development

### Branch Naming Convention

- `feature/DS-123-completions-analysis`
- `bugfix/slow-dashboard-query`
- `refactor/standardize-metrics-calculation`
- `schema/add-user-preferences-table`

### SQL Development Workflow

1. Create a feature branch from main
2. Develop and test SQL locally
3. Commit changes with clear messages
4. Push to remote and create pull request
5. Address review comments
6. Merge to main after approval
7. Deploy to production environment

## SQL-Specific `.gitignore` Patterns

Add these patterns to your `.gitignore` file:

```
# Local configuration files
*.env
*_local.sql
config_*.sql

# Query results
*.csv
*.xlsx
*.json
results/
output/

# Database backups
*.backup
*.bak
*.dump

# Temporary query files
*_temp.sql
tmp_*.sql

# SQL IDE files
.idea/dataSources/
.idea/sqlDataSources.xml
*.sqldiff

# Database connection credentials
database.ini
credentials.json
```

## SQL Code Review Checklist

When reviewing SQL code, check for:

- [ ] Appropriate indexes for performance
- [ ] Potential SQL injection vulnerabilities
- [ ] Schema compatibility with existing database
- [ ] Proper error handling
- [ ] Consistent naming conventions
- [ ] Query performance (execution plan)
- [ ] Appropriate transaction handling
- [ ] Clear documentation/comments
- [ ] Potential impact on other systems

## Handling Database Migrations

For tracking database schema changes:

1. Number migration scripts sequentially: `V001_initial_schema.sql`, `V002_add_indexes.sql`
2. Never modify existing migration files after they've been applied
3. Include both "up" (apply) and "down" (rollback) scripts
4. Test migrations in a development environment before committing
5. Document dependencies between migration scripts

## Tools for SQL Git Workflows

### SQL Linters and Formatters

- [SQLFluff](https://github.com/sqlfluff/sqlfluff) - SQL linter
- [sql-formatter](https://github.com/sql-formatter-org/sql-formatter) - SQL formatter
- [pgFormatter](https://github.com/darold/pgFormatter) - PostgreSQL formatter

### Database Schema Migration Tools

- [Flyway](https://flywaydb.org/) - Database migrations
- [Liquibase](https://www.liquibase.org/) - Database schema changes
- [Alembic](https://alembic.sqlalchemy.org/) - Python SQL toolkit

### IDE Plugins

- VS Code:
  - SQL Server (mssql)
  - SQLTools
  - PostgreSQL
  
- JetBrains DataGrip:
  - Built-in Git integration
  - Schema comparison tools

## Solving Common SQL/Git Challenges

### Handling Connection Strings

Don't commit connection strings or credentials. Instead:

1. Use environment variables
2. Create template files with placeholders
3. Use a secret management tool

Example template file (`connection.template.sql`):
```sql
-- Copy this file to connection.sql (which is git-ignored)
-- and replace the placeholders with actual values
CONNECT TO DATABASE
   USER '{USERNAME}'
   IDENTIFIED BY '{PASSWORD}'
   USING '{CONNECTION_STRING}';
```

### Dealing with Large SQL Dump Files

Large SQL dumps can cause Git performance issues:

1. Don't commit full database dumps to Git
2. Store only schema definitions in Git
3. Use Git LFS for large files if necessary
4. Consider storing test data separately from schema

### Resolving SQL Merge Conflicts

When facing SQL merge conflicts:

1. Use a visual diff tool to understand changes
2. Consider the logical impact, not just textual differences
3. Test both versions before resolving
4. Ask for input from the other developer
5. Consider database compatibility when resolving

## Advanced SQL Version Control Techniques

### SQL Modularization

Break large SQL files into logical modules:

```sql
-- Main query file
\i 'common/header.sql'
\i 'dimensions/customer_dim.sql'
\i 'dimensions/product_dim.sql'
\i 'metrics/sales_metrics.sql'
```

### Query Templates

Use SQL templates with placeholders:

```sql
SELECT 
    ${dimensions},
    ${metrics}
FROM 
    ${base_table}
WHERE 
    ${filters}
GROUP BY 
    ${dimensions}
ORDER BY 
    ${sort_column} ${sort_direction}
LIMIT ${row_limit};
```

### Test Data Version Control

For test data management:

1. Create small, representative datasets
2. Store test data generation scripts in Git
3. Use seed scripts for test database setup
4. Include expected query results for validation

---

*This document is maintained by the Warwick Investment Group Data Science Team.*