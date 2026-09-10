# Sample Angular, .NET, and SQL Server Pipeline Plan

This document describes the first full-stack learning pipeline. It is documentation-only for now. No repository, application, database, Jenkins job, or Jenkinsfile is created at this stage.

## Purpose

The `sample-angular-dotnet-sqlserver` repository connects the separate learning tracks into one coordinated CI/CD flow.

It should prove that Jenkins can coordinate:

- Angular frontend validation and build.
- C# API restore, build, test, and publish.
- EF Core migration artifact generation.
- SQL Server validation planning.
- Artifact publishing for frontend, backend, and database changes.
- Smoke checks before deployment is introduced.

## Repository Goal

The sample repository should model the real stack without touching the real application.

Recommended goal:

```text
Build a full-stack sample with Angular, C# API, EF Core migration output, and SQL Server validation planning.
```

## Proposed Repository Structure

```text
sample-angular-dotnet-sqlserver
  Jenkinsfile
  frontend
    package.json
    angular.json
    src
  backend
    Sample.App.sln
    src
      Sample.Api
        Sample.Api.csproj
    tests
      Sample.Api.Tests
        Sample.Api.Tests.csproj
  database
    notes.md
  docs
    pipeline-notes.md
```

This sample uses a monorepo shape because it is easier to practice full-stack coordination in one Jenkinsfile. The real application may still use monorepo or multi-repo; that remains an open decision.

## Proposed Pipeline Stages

| Stage | Purpose |
| --- | --- |
| `Checkout` | Read the full-stack repository from Git |
| `Environment` | Print safe versions for Git, Node.js, npm, and .NET |
| `Frontend Install` | Install Angular dependencies |
| `Frontend Lint` | Validate frontend code quality |
| `Frontend Test` | Run Angular tests in CI mode |
| `Frontend Build` | Build Angular production output |
| `Backend Restore` | Restore NuGet packages |
| `Backend Build` | Build the C# API |
| `Backend Test` | Run backend tests |
| `Backend Publish` | Create API publish output |
| `Database Migration Artifact` | Generate EF Core migration script or bundle |
| `Archive Artifacts` | Archive frontend, backend, and database artifacts |
| `Smoke Plan` | Document future smoke checks without deploying yet |

## Full-Stack Pipeline Order

The future pipeline should use this order:

```text
checkout
validate tools
build frontend
test frontend
build backend
test backend
generate migration artifact
archive all artifacts
prepare smoke test plan
stop before deployment
```

Do not deploy from the first full-stack pipeline. Deployment should be introduced only after build, test, and artifact publishing are stable.

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
                sh 'git --version'
                sh 'node --version'
                sh 'npm --version'
                sh 'dotnet --version'
            }
        }

        stage('Frontend Install') {
            steps {
                dir('frontend') {
                    sh 'npm ci'
                }
            }
        }

        stage('Frontend Lint') {
            steps {
                dir('frontend') {
                    sh 'npm run lint'
                }
            }
        }

        stage('Frontend Test') {
            steps {
                dir('frontend') {
                    sh 'npm test -- --watch=false'
                }
            }
        }

        stage('Frontend Build') {
            steps {
                dir('frontend') {
                    sh 'npm run build'
                }
            }
        }

        stage('Backend Restore') {
            steps {
                dir('backend') {
                    sh 'dotnet restore Sample.App.sln'
                }
            }
        }

        stage('Backend Build') {
            steps {
                dir('backend') {
                    sh 'dotnet build Sample.App.sln --configuration Release --no-restore'
                }
            }
        }

        stage('Backend Test') {
            steps {
                dir('backend') {
                    sh 'dotnet test Sample.App.sln --configuration Release --no-build'
                }
            }
        }

        stage('Backend Publish') {
            steps {
                dir('backend') {
                    sh 'dotnet publish src/Sample.Api/Sample.Api.csproj --configuration Release --no-build --output ../artifacts/api'
                }
            }
        }

        stage('Database Migration Artifact') {
            steps {
                dir('backend') {
                    sh 'mkdir -p ../artifacts/database'
                    sh 'dotnet ef migrations script --idempotent --output ../artifacts/database/migration.sql'
                }
            }
        }

        stage('Archive Artifacts') {
            steps {
                archiveArtifacts artifacts: 'frontend/dist/**', fingerprint: true
                archiveArtifacts artifacts: 'artifacts/api/**', fingerprint: true
                archiveArtifacts artifacts: 'artifacts/database/**', fingerprint: true
            }
        }
    }
}
```

This Jenkinsfile is a planning example. The final version must be adjusted after the real project paths, package manager, .NET SDK version, and EF Core project paths are known.

## Artifact Coordination

The full-stack pipeline should produce separate artifacts.

| Artifact | Example Pattern | Purpose |
| --- | --- | --- |
| Frontend artifact | `frontend/dist/**` | Deploy Angular frontend |
| Backend artifact | `artifacts/api/**` | Deploy C# API |
| Database artifact | `artifacts/database/**` | Review or apply EF Core migration output |

These artifacts should later feed the deployment chapter. The first full-stack pipeline should only archive them.

## Smoke Check Planning

Smoke checks should be planned before deployment exists.

Future smoke checks:

- Frontend route returns success.
- API health endpoint returns success.
- API can connect to SQL Server.
- A safe read-only database query succeeds.
- Deployed version matches the artifact version.

For this sample pipeline, smoke checks can remain documented placeholders until a staging environment exists.

## What This Pipeline Should Not Do Yet

- Do not deploy to staging or production.
- Do not apply production database migrations.
- Do not use real production credentials.
- Do not expose Jenkins to the internet.
- Do not depend on local Windows folders.
- Do not mix generated artifacts with committed artifacts.

## Success Criteria

The full-stack sample pipeline is successful when:

- Jenkins checks out the repository.
- Frontend install, test, and build complete.
- Backend restore, test, and publish complete.
- EF Core migration artifact is generated or the missing migration setup is documented.
- Frontend, backend, and database artifacts are archived separately.
- No deployment happens yet.
- No secrets are printed in logs.

## Next Step After This Pipeline

After the full-stack pipeline plan is stable, align the deployment chapter with the frontend, backend, and database artifacts produced by this pipeline.
