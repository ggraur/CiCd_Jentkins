# Sample Angular App Pipeline Plan

This document describes the first Angular 22 learning pipeline. It is documentation-only for now. No repository, Angular app, Jenkins job, or Jenkinsfile is created at this stage.

## Purpose

The `sample-angular-app` repository proves that Jenkins can build and validate an Angular frontend before the real frontend project is connected.

The pipeline should validate:

- Git checkout from GitHub or Gitea.
- Node.js availability.
- Package manager behavior.
- Dependency installation.
- Lint execution.
- Unit test execution.
- Production build output.
- Frontend artifact publishing.

## Repository Goal

The sample repository should be small but realistic enough to prepare for the real Angular 22 project.

Recommended goal:

```text
Build an Angular 22 sample application and archive the production output as a Jenkins artifact.
```

## Open Decisions

Before implementation, decide:

| Decision | Options | Notes |
| --- | --- | --- |
| Node.js version | Node 20 or Node 22 | Angular 22 compatibility must be confirmed before implementation |
| Package manager | npm, pnpm, or yarn | Match the real project if already known |
| Repository provider | GitHub, Gitea, or both | GitHub first is simplest; Gitea validates self-hosted flow |
| Test command | Project-specific | Should run without a browser UI requirement in CI |
| Lint command | Project-specific | Depends on Angular lint setup |
| Build output path | `dist/...` | Confirm exact output after the sample app exists |

## Proposed Repository Structure

```text
sample-angular-app
  Jenkinsfile
  package.json
  package-lock.json or equivalent lock file
  angular.json
  src
  docs
    pipeline-notes.md
```

If the sample uses `pnpm` or `yarn`, replace `package-lock.json` with the correct lock file.

## Proposed Pipeline Stages

| Stage | Purpose |
| --- | --- |
| `Checkout` | Read the Angular sample repository from Git |
| `Environment` | Print safe Node.js, npm, and Git version information |
| `Install` | Install dependencies from the lock file |
| `Lint` | Run Angular linting if configured |
| `Test` | Run unit tests in CI mode |
| `Build` | Create production frontend build output |
| `Archive Artifact` | Store the frontend build output in Jenkins |

## Proposed Jenkinsfile Shape

The future Jenkinsfile should follow this structure once the sample repository exists:

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
                sh 'node --version'
                sh 'npm --version'
                sh 'git --version'
            }
        }

        stage('Install') {
            steps {
                sh 'npm ci'
            }
        }

        stage('Lint') {
            steps {
                sh 'npm run lint'
            }
        }

        stage('Test') {
            steps {
                sh 'npm test -- --watch=false'
            }
        }

        stage('Build') {
            steps {
                sh 'npm run build'
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'dist/**', fingerprint: true
            }
        }
    }
}
```

This example assumes `npm`. If the real project uses `pnpm` or `yarn`, the commands should be adjusted before implementation.

## CI Test Notes

Angular tests often need CI-friendly configuration.

Before implementation, confirm:

- Whether tests require Chrome or a headless browser.
- Whether the test command exits after one run.
- Whether linting is configured in the Angular project.
- Whether test reports should be archived later.

## Artifact Plan

The first Angular artifact should be the production build folder.

Future artifact pattern:

```text
dist/**
```

Later, if the Angular project name creates a nested output folder, replace this with the exact build output path.

## What This Pipeline Should Not Do Yet

- Do not deploy the frontend.
- Do not connect to the backend API.
- Do not use production environment files.
- Do not store API URLs or secrets in the Jenkinsfile.
- Do not publish to the external provider yet.

## Success Criteria

The sample Angular pipeline is successful when:

- Jenkins checks out the repository.
- Node.js and the package manager are available.
- Dependencies install from the lock file.
- Lint passes or is explicitly skipped with a documented reason.
- Unit tests pass in CI mode.
- Production build succeeds.
- Jenkins archives the build output.

## Next Step After This Pipeline

After the Angular sample pipeline works, create the `sample-dotnet-api` pipeline plan and validate the backend build flow separately.
