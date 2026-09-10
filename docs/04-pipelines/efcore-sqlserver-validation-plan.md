# EF Core and SQL Server Validation Plan

This document describes the future database validation and migration pipeline. It is documentation-only for now. No database, migration job, Jenkins credential, or Jenkinsfile is created at this stage.

## Purpose

The database pipeline protects SQL Server schema changes from being applied accidentally or too early.

It should validate:

- EF Core migration state.
- SQL Server connectivity for safe environments.
- Migration script or bundle generation.
- Review process before applying schema changes.
- Staging migration execution before production.
- Smoke checks after database changes.

## Database Role in the Stack

The real application stack uses:

- Entity Framework Core for schema migration planning.
- Dapper for runtime data access.
- SQL Server as the database engine.

Recommended separation:

```text
EF Core -> schema changes and migration scripts
Dapper -> application runtime queries
SQL Server -> database engine and persisted data
```

Do not use Dapper as the main database migration mechanism if EF Core migrations are already available.

## Open Decisions

Before implementation, decide:

| Decision | Options | Notes |
| --- | --- | --- |
| SQL Server hosting | Managed SQL Server, VM SQL Server, container, provider database | Needed before deployment design |
| Staging database | Separate SQL Server database or separate server | Must not share production data unsafely |
| Production database | External provider or dedicated SQL Server | Requires stronger controls |
| Migration format | SQL script, EF bundle, or direct command | Prefer reviewable output before production |
| Migration approval | Manual or automated | Production should require approval |
| Rollback strategy | Backup restore, forward fix, or provider restore point | Must be planned before production changes |

## Recommended Migration Flow

The future database flow should be:

```text
checkout
restore backend dependencies
build backend project
validate EF Core migration state
generate migration script or bundle
archive migration artifact
review migration artifact
apply migration to staging
run database smoke checks
approve production
apply migration to production
run production smoke checks
```

The first implementation should stop at generating and archiving the migration artifact. Applying migrations should come later.

## Proposed Pipeline Stages

| Stage | Purpose |
| --- | --- |
| `Checkout` | Read the repository from Git |
| `Restore` | Restore NuGet packages |
| `Build` | Build the API and migration project |
| `Validate Migration State` | Confirm migrations can be inspected |
| `Generate Migration Artifact` | Create SQL script or EF migration bundle |
| `Archive Migration Artifact` | Store generated migration output in Jenkins |
| `Staging Migration` | Apply migration to staging later |
| `Staging Smoke Test` | Confirm database remains usable after migration |
| `Production Approval` | Require manual approval later |
| `Production Migration` | Apply migration to production only after approval |

## Future Command Concepts

The exact commands depend on the real project structure. These are planning examples only.

Generate an idempotent SQL script:

```sh
dotnet ef migrations script --idempotent --output artifacts/database/migration.sql
```

Generate a migration bundle:

```sh
dotnet ef migrations bundle --configuration Release --output artifacts/database/migration-bundle
```

The final commands must include the correct project path, startup project path, context name, and output path.

## Required Project Information

Before implementation, capture:

- Solution file path.
- API project path.
- EF Core migrations project path, if separate.
- Startup project path.
- DbContext class name.
- .NET SDK version.
- SQL Server provider package.
- Whether migrations are already used in the real project.

## Credential Rules

Database credentials must be treated separately from Git and deployment credentials.

Rules:

- Do not store SQL Server connection strings in Git.
- Do not print connection strings in Jenkins logs.
- Keep staging and production credentials separate.
- Prefer limited permissions for validation steps.
- Use stronger approval rules for production migration credentials.

Recommended future credential IDs:

| Credential ID | Purpose |
| --- | --- |
| `sqlserver-staging-connection` | Staging migration or smoke test connection |
| `sqlserver-production-connection` | Production migration connection, if Jenkins is allowed to apply it |

## Staging Database Strategy

Staging should be the first real target for migrations.

Staging should prove:

- The migration can be applied.
- The API can connect after schema changes.
- Basic read/write behavior still works.
- Smoke tests pass before production approval.

Staging should not casually use production data unless data privacy and sanitization are handled.

## Production Database Strategy

Production database changes require stricter controls.

Production rules:

- Review migration output before applying it.
- Confirm a recent database backup or restore point exists.
- Apply to staging first.
- Require manual approval before production.
- Keep rollback or forward-fix plan documented.
- Run smoke checks after migration.

## What This Pipeline Should Not Do Yet

- Do not connect to production SQL Server.
- Do not apply migrations automatically.
- Do not store real connection strings.
- Do not mix database migration with the first API build validation.
- Do not treat Jenkins backup as SQL Server backup.

## Success Criteria

The first database validation pipeline is successful when:

- Jenkins can build the backend project.
- EF Core tooling can inspect migrations.
- A migration script or bundle is generated.
- The migration artifact is archived.
- No database secrets are printed.
- No production database changes are made.

## Next Step After This Pipeline

After migration artifact generation is documented and tested later, define staging database migration and smoke test behavior.
