# Jenkins Basic Pipeline Plan

This document describes the first learning pipeline repository. It is documentation-only for now. No repository, Jenkins job, or Jenkinsfile is created at this stage.

## Purpose

The `jenkins-basic-pipeline` repository proves the smallest useful Jenkins workflow:

```text
Jenkins -> GitHub or Gitea -> Jenkinsfile -> stages -> archived artifact
```

This pipeline is intentionally simple. It should validate Jenkins behavior before the real Angular 22 and C# API projects are connected.

## Repository Goal

The repository should prove that Jenkins can:

- Authenticate to GitHub or Gitea.
- Check out source code.
- Read a `Jenkinsfile`.
- Execute multiple stages.
- Print useful environment information.
- Simulate build and test steps.
- Archive a small artifact.

## Repository Location

Recommended order:

1. Create the repository in GitHub first.
2. Validate Jenkins checkout manually.
3. Recreate or mirror the same repository in Gitea.
4. Compare GitHub and Gitea behavior.

This order keeps the first Git provider test simple while still preparing for self-hosted Gitea integration.

Decision: `jenkins-basic-pipeline` is the first sample repository for the learning path.

Initial trigger strategy:

1. Manual Jenkins run.
2. Poll SCM.
3. Gitea webhook.
4. GitHub webhook later, only after secure Jenkins exposure exists.

## Proposed Repository Structure

```text
jenkins-basic-pipeline
  Jenkinsfile
  docs
    pipeline-notes.md
  scripts
    create-artifact.sh
  artifacts
    .gitkeep
```

Notes:

- `Jenkinsfile` defines the pipeline.
- `docs/pipeline-notes.md` explains what the sample pipeline is testing.
- `scripts/create-artifact.sh` can later create a small text artifact.
- `artifacts/.gitkeep` keeps the folder visible in Git.
- Real generated artifacts should be produced by Jenkins, not committed manually.

## Proposed Pipeline Stages

| Stage | Purpose |
| --- | --- |
| `Checkout` | Confirm Jenkins can read the repository |
| `Environment` | Print safe environment information |
| `Validate Repository` | Confirm expected files exist |
| `Simulate Build` | Create a simple output file |
| `Simulate Test` | Run a simple validation command |
| `Archive Artifact` | Store the generated output in Jenkins |

## Proposed Jenkinsfile Shape

The future Jenkinsfile should follow this structure:

```groovy
pipeline {
    agent any

    stages {
        stage('Checkout') {
            steps {
                checkout scm
            }
        }

        stage('Environment') {
            steps {
                sh 'hostname'
                sh 'pwd'
                sh 'git --version'
            }
        }

        stage('Validate Repository') {
            steps {
                sh 'test -f Jenkinsfile'
            }
        }

        stage('Simulate Build') {
            steps {
                sh 'mkdir -p artifacts'
                sh 'echo "Build created by Jenkins" > artifacts/build-output.txt'
            }
        }

        stage('Simulate Test') {
            steps {
                sh 'test -s artifacts/build-output.txt'
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'artifacts/build-output.txt', fingerprint: true
            }
        }
    }
}
```

This Jenkinsfile assumes a Linux Jenkins environment. A Windows version can be documented later only if a Windows build agent becomes necessary.

## What This Pipeline Should Not Do

- Do not deploy anything.
- Do not connect to SQL Server.
- Do not use real application source code.
- Do not use production credentials.
- Do not expose Jenkins to the internet.
- Do not test GitHub webhooks until Jenkins has a secure reachable URL.

## Future Jenkins Job Plan

When implementation starts later, create the Jenkins job in this order:

1. Create a Pipeline job named `jenkins-basic-pipeline`.
2. Use `Pipeline script from SCM`.
3. Select Git as the SCM.
4. Add the GitHub repository URL first.
5. Select the planned Jenkins credential.
6. Set `Script Path` to `Jenkinsfile`.
7. Run the job manually.
8. Confirm all stages pass.
9. Confirm the artifact is archived.
10. Add polling only after manual runs work.
11. Repeat with Gitea after the GitHub version works.
12. Add Gitea webhook only after Gitea and Jenkins networking is stable.

## Success Criteria

The sample pipeline is successful when:

- Jenkins checks out the repository.
- Jenkins reads the Jenkinsfile from Git.
- All stages pass.
- A small artifact is archived.
- No secrets are printed in logs.
- The same pipeline can later be tested from Gitea.

## Next Step After This Pipeline

After this sample works, continue with the Angular-only sample pipeline before moving to the full Angular and C# stack.
