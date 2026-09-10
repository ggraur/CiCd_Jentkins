# Credentials and Hardening

This chapter will document Jenkins security basics for the learning lab and production-like setup.

No credentials are created at this stage. This chapter defines the future security model before implementation.

## Purpose

Protect source code, credentials, deployment targets, and Jenkins itself.

## Security Direction

The learning lab should start simple, but it should not teach unsafe habits.

The main security direction is:

```text
least privilege
dedicated automation identities
no secrets in source code
HTTPS before internet exposure
controlled deployment permissions
tested backup and restore
```

## Account Model

Recommended accounts:

| Account Type | Purpose | Notes |
| --- | --- | --- |
| Jenkins administrator | Initial setup and emergency administration | Use a strong password and avoid daily use later |
| Jenkins normal user | Daily Jenkins use | Add later when more users exist |
| GitHub service identity or token | Repository checkout and status updates | Avoid personal daily credentials |
| Gitea service identity or token | Internal repository checkout | Prefer a dedicated CI user |
| Deployment service identity | Publish to external provider | Scope to staging first |
| SQL Server deployment identity | Future database migrations | Use limited permissions where possible |

## Credential Naming Standard

Use predictable credential IDs so pipelines are readable and maintainable.

Recommended names:

| Credential ID | Purpose |
| --- | --- |
| `github-token-ci` | GitHub HTTPS token for CI checkout |
| `github-ssh-ci` | GitHub SSH key for CI checkout |
| `gitea-token-ci` | Gitea HTTPS token for CI checkout |
| `gitea-ssh-ci` | Gitea SSH key for CI checkout |
| `external-provider-staging-deploy` | External provider staging deployment credential |
| `external-provider-production-deploy` | External provider production deployment credential |
| `sqlserver-staging-connection` | SQL Server staging connection |
| `sqlserver-production-connection` | SQL Server production connection, if ever needed by Jenkins |

Production credentials should be added only when deployment strategy is clear.

## Secret Handling Rules

Rules for Jenkinsfiles and pipelines:

- Do not commit passwords, tokens, private keys, or connection strings.
- Do not print secrets to console logs.
- Do not pass secrets as plain text parameters when avoidable.
- Use Jenkins credentials binding or a dedicated secret manager.
- Use separate credentials for Git checkout, deployment, and database access.
- Keep staging and production credentials separate.

## GitHub and Gitea Credential Strategy

For the first learning phase:

1. Use a low-permission HTTPS token.
2. Give access only to test repositories.
3. Store it in Jenkins credentials.
4. Validate checkout manually.
5. Add SSH keys later after the first checkout pipeline works.
6. Expand permissions only when needed.

For production-like usage:

- Prefer dedicated CI identities.
- Prefer SSH keys or dedicated service tokens.
- Rotate credentials periodically.
- Use repository-level or organization-level access carefully.
- Remove unused credentials from Jenkins.

Do not use personal account passwords for GitHub or Gitea access from Jenkins.

## Jenkins Exposure Rules

For local learning:

- Jenkins can be reachable only inside the local network.
- HTTP on port `8080` is acceptable temporarily inside the lab.
- GitHub webhooks should not force unsafe internet exposure.

Before exposing Jenkins to the internet:

- Add HTTPS.
- Add a reverse proxy.
- Configure firewall rules.
- Use strong authentication.
- Review installed plugins.
- Disable anonymous access.
- Confirm backup and restore work.

## Plugin Safety

Plugins are part of the Jenkins attack surface.

Rules:

- Install only plugins that are needed.
- Prefer well-known Jenkins plugins.
- Keep a list of installed plugins.
- Update plugins intentionally, not randomly during critical work.
- Test important plugin updates in the lab before production use.

## Deployment Security

Deployment credentials should be more protected than build credentials.

Recommended approach:

```text
build and test
publish artifact
deploy to staging with staging credential
run smoke tests
manual approval
deploy to production with production credential
```

Production deployment should require a deliberate approval step later.

Deployment security rules:

- Use separate credentials for staging and production.
- Do not let normal build stages access production deployment credentials.
- Do not expose production credentials to pull request builds from untrusted branches.
- Prefer promotion of approved artifacts over rebuilding with production credentials.
- Restrict production deployment to trusted Jenkins agents.
- Require manual approval before production deployment.

Recommended deployment credential separation:

| Credential | Scope |
| --- | --- |
| `external-provider-staging-deploy` | Deploy only to staging |
| `external-provider-production-deploy` | Deploy only to production |
| `sqlserver-staging-connection` | Validate or migrate staging database |
| `sqlserver-production-connection` | Production database access only if approved and required |

## Database Security

SQL Server access from Jenkins should be limited and intentional.

Rules:

- Do not use developer database accounts in Jenkins.
- Do not use production admin credentials for normal builds.
- Prefer staging database validation before production migrations.
- Keep production connection strings out of repository files.
- Review EF Core migration scripts before applying to production.

Database credential rules:

- Keep staging and production SQL Server credentials separate.
- Use the lowest permissions that still allow the required migration or validation task.
- Prefer generating migration artifacts before allowing Jenkins to apply migrations.
- Require review before production schema changes.
- Confirm database backup or restore point before production migration.

## Future Hardening Checklist

- Change or secure the initial administrator account.
- Disable anonymous access.
- Create dedicated service credentials.
- Add HTTPS and reverse proxy before external exposure.
- Configure firewall rules.
- Limit plugin installation to administrators.
- Document installed plugins.
- Separate staging and production credentials.
- Add manual approval before production deployment.
- Test backup and restore.
- Review agent permissions and labels.

## Ready to Continue Criteria

This chapter is ready for implementation planning when:

- GitHub and Gitea credential methods are selected.
- Staging and production deployment credential boundaries are accepted.
- SQL Server credential boundaries are accepted.
- Jenkins exposure strategy is selected.
- Backup and restore expectations are documented.
