# Backup and Restore

This chapter will document how to back up and restore the Jenkins environment.

No backup job is created at this stage. This chapter defines what must be protected and how restore should be proven later.

## Purpose

Make the learning environment recoverable and prepare for production operations.

## Backup Strategy

The Jenkins setup should be treated as important infrastructure even during learning.

Backup priority:

1. Jenkins configuration and jobs.
2. Jenkins credentials metadata.
3. Plugin list and versions.
4. Pipeline definitions that are not stored in Git.
5. Gitea repositories, if Gitea runs in the lab.
6. Build history, only if useful.

The most important production habit is not just creating backups. It is proving that restore works.

## Jenkins Data to Protect

Jenkins stores most of its important state in `JENKINS_HOME`.

Important content includes:

| Data | Why It Matters |
| --- | --- |
| Job configuration | Defines Jenkins jobs and folders |
| Build history | Useful for audit and troubleshooting |
| Credentials metadata | Needed for Jenkins credential references |
| Plugin configuration | Controls installed Jenkins capabilities |
| User configuration | Stores local Jenkins users and settings |
| Global tool configuration | Stores configured tools such as Git, Node.js, or JDK |

For the Docker-based lab, `JENKINS_HOME` should live in a Docker volume or a clearly documented host folder.

## What Git Already Protects

Anything committed to GitHub or Gitea is not only inside Jenkins.

Git should store:

- Application source code.
- `Jenkinsfile` pipeline definitions.
- Infrastructure notes.
- Documentation.
- Deployment scripts, if safe and non-secret.

Jenkins should not be the only place where important pipeline logic exists.

## What Git Must Not Store

Git must not store:

- Passwords.
- Tokens.
- Private keys.
- Production connection strings.
- SQL Server admin credentials.
- External provider secrets.

These belong in Jenkins credentials or a dedicated secret manager.

## Backup Frequency Plan

Recommended evolution:

| Phase | Frequency | Notes |
| --- | --- | --- |
| Early learning | Manual backup after major changes | Enough while experimenting |
| Production-like lab | Scheduled daily or weekly backup | Start practicing operations |
| Production | Scheduled backup with retention | Restore must be tested regularly |

## Restore Testing Plan

A backup is not trusted until restore is tested.

Future restore test:

1. Create a backup.
2. Start a clean Jenkins instance.
3. Restore `JENKINS_HOME`.
4. Confirm Jenkins starts.
5. Confirm jobs and folders exist.
6. Confirm credentials references still exist.
7. Confirm plugins load correctly.
8. Run a safe test pipeline.
9. Document any missing manual steps.

## Gitea Backup Considerations

If Gitea runs in the lab, it also needs backup planning.

Protect:

- Git repositories.
- Gitea database.
- Gitea configuration.
- Gitea users and tokens.
- SSH keys, if stored by Gitea.

If Gitea runs on the same VM as Jenkins, a VM failure can affect both CI/CD and source control. This is acceptable for learning but not ideal for production.

## SQL Server Backup Boundary

SQL Server backups are separate from Jenkins backups.

Jenkins can trigger or coordinate database tasks later, but production database backup should be designed as its own operational responsibility.

Rules:

- Do not treat Jenkins backup as database backup.
- Do not rely on build artifacts as database recovery.
- Keep database restore testing separate from Jenkins restore testing.

## Information to Capture Later

When backup is implemented, document:

- Jenkins storage location.
- Backup destination.
- Backup frequency.
- Retention period.
- Restore procedure.
- Last restore test date.
- Who can access backups.
- How secrets are protected in backups.

## Planned Sections

- What is stored in `JENKINS_HOME`.
- Jenkins Docker volume backup.
- Manual backup procedure.
- Scheduled backup procedure.
- Restore procedure.
- Testing a restore.
- Gitea backup considerations.
- Credential and secret recovery considerations.

## Initial Backup Targets

- Jenkins configuration.
- Jenkins jobs.
- Jenkins credentials metadata.
- Plugin list.
- Build history, if needed.
- Gitea repositories, if Gitea runs in the lab.
