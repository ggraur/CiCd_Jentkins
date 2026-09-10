# Production Readiness Checklist

This chapter will track what must be true before the Jenkins setup is considered production-ready.

This checklist is documentation-only for now. It defines the target standard that the learning lab should grow toward.

## Purpose

Turn the learning environment into a controlled, maintainable, and secure CI/CD platform.

## Readiness Levels

Use these levels to avoid calling the environment production-ready too early.

| Level | Meaning |
| --- | --- |
| Learning | Jenkins works and can run manual jobs |
| Production-like | Jenkins can build from Git, use credentials, deploy to staging, and recover from backup |
| Production-ready | Security, backup, restore, deployment, rollback, and monitoring have been tested |

## Minimum Production Rule

Nothing should be considered production-ready until restore, credentials, deployment, and rollback have been tested.

## Jenkins Controller Checklist

- Jenkins runs on a stable host.
- Jenkins uses an LTS version.
- Jenkins data location is documented.
- Jenkins URL is stable.
- Jenkins has a documented administrator account strategy.
- Anonymous access is disabled.
- Installed plugins are documented.
- Plugin updates are controlled.
- Jenkins configuration is included in backup planning.

## Source Control Checklist

- GitHub integration is documented.
- Gitea integration is documented.
- Jenkins does not build from developer-machine local folders.
- Jenkins can check out test repositories.
- Jenkins can check out real application repositories.
- Credentials are dedicated to CI/CD usage.
- Repository access follows least privilege.
- Webhook or polling strategy is documented.

## Pipeline Checklist

- Minimal checkout pipeline works.
- Angular 22 pipeline is defined.
- C# API pipeline is defined.
- Full-stack sample pipeline is defined.
- Frontend, backend, and database artifacts are defined separately.
- Automated test stage exists.
- Artifact publishing stage exists.
- Database migration strategy is documented.
- Pipeline failures stop deployment.
- Jenkinsfiles are stored in Git.
- Secrets are not stored in Jenkinsfiles.

## Build Agent Checklist

- Controller versus agent responsibilities are documented.
- First Linux build agent decision is documented.
- Windows agent decision is documented.
- Agent labels are planned.
- Build jobs run only on appropriate agents.
- Production deployment jobs are restricted to trusted agents.
- Agent access to credentials is limited.

## Credentials and Security Checklist

- Jenkins administrator access is controlled.
- Personal accounts are not used directly for automation.
- GitHub credentials are dedicated to Jenkins.
- Gitea credentials are dedicated to Jenkins.
- Deployment credentials are separated from Git credentials.
- Staging and production credentials are separated.
- SQL Server credentials are not stored in source code.
- Credentials follow the documented naming standard.
- Secrets are not printed in build logs.

## Network and HTTPS Checklist

- Jenkins network access is documented.
- Jenkins has a stable local IP or DNS name.
- Firewall rules are documented.
- Jenkins is not exposed to the internet without HTTPS.
- Reverse proxy plan exists before external exposure.
- GitHub webhook exposure strategy is documented.
- Gitea local webhook strategy is documented.

## Backup and Restore Checklist

- Jenkins backup target is documented.
- Backup frequency is documented.
- Backup retention is documented.
- Restore procedure is documented.
- Restore has been tested.
- Gitea backup plan exists if Gitea runs in the lab.
- SQL Server backup is handled separately from Jenkins backup.
- Backup access is restricted.

## Deployment Checklist

- External provider is selected.
- Angular hosting target is selected.
- C# API hosting target is selected.
- SQL Server hosting target is selected.
- Deployment credentials are stored securely.
- Staging deployment works.
- Staging deployment consumes CI artifacts instead of rebuilding.
- Smoke tests run after staging deployment.
- Production deployment requires approval.
- Rollback plan is documented.
- Previous artifact can be redeployed.

## Database Readiness Checklist

- EF Core migration strategy is documented.
- Migration scripts or bundles can be reviewed.
- Staging migrations are tested before production.
- Production connection strings are protected.
- Database rollback or forward-fix strategy is documented.
- Dapper usage is separated from schema migration strategy.

## Monitoring and Operations Checklist

- Jenkins logs are accessible.
- Build failures are visible.
- Deployment failures are visible.
- External provider logs are accessible.
- API health check exists.
- Basic smoke checks are documented.
- Ownership of maintenance tasks is documented.

## Documentation Checklist

- Strategy is documented.
- Installation plan is documented.
- GitHub and Gitea integration plan is documented.
- Pipeline plan is documented.
- Agent strategy is documented.
- Security model is documented.
- Backup and restore plan is documented.
- Deployment plan is documented.
- Open decisions are tracked.

## Next Review

- Revisit this checklist after the installation and first Git integrations are documented in detail.
