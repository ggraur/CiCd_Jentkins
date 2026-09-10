# Sample .NET API Pipeline Plan

This document describes the first C# API learning pipeline. It is documentation-only for now. No repository, API project, Jenkins job, or Jenkinsfile is created at this stage.

## Purpose

The `sample-dotnet-api` repository proves that Jenkins can build, test, and publish a C# backend API before the real backend project is connected.

The pipeline should validate:

- Git checkout from GitHub or Gitea.
- .NET SDK availability.
- NuGet restore.
- Solution or project build.
- Automated test execution.
- API publish output.
- Backend artifact publishing.

## Repository Goal

The sample repository should be small but realistic enough to prepare for the real C# API.

Recommended goal:

```text
Build a sample C# API, run tests, publish the API output, and archive it as a Jenkins artifact.
```

## Open Decisions

Before implementation, decide:

| Decision | Options | Notes |
| --- | --- | --- |
| .NET SDK version | .NET 8, .NET 9, or later supported version | Must match the real API project where possible |
| Repository provider | GitHub, Gitea, or both | GitHub first is simplest; Gitea validates self-hosted flow |
| Repository shape | Solution file or single project | Match the real project style if known |
| Test framework | xUnit, NUnit, MSTest, or none initially | Prefer at least one test project |
| Publish runtime | Framework-dependent or self-contained | Decide later based on hosting provider |
| Artifact format | Folder, zip file, or container image | Start with folder or zip before Docker deployment |

## Proposed Repository Structure

```text
sample-dotnet-api
  Jenkinsfile
  Sample.Api.sln
  src
    Sample.Api
      Sample.Api.csproj
  tests
    Sample.Api.Tests
      Sample.Api.Tests.csproj
  docs
    pipeline-notes.md
```

This structure keeps application code and test code separate, which is closer to a real backend project.

## Proposed Pipeline Stages

| Stage | Purpose |
| --- | --- |
| `Checkout` | Read the sample API repository from Git |
| `Environment` | Print safe .NET and Git version information |
| `Restore` | Restore NuGet packages |
| `Build` | Build the solution in Release configuration |
| `Test` | Run automated tests |
| `Publish` | Generate deployable API output |
| `Archive Artifact` | Store published API output in Jenkins |

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
                sh 'dotnet --version'
                sh 'dotnet --info'
                sh 'git --version'
            }
        }

        stage('Restore') {
            steps {
                sh 'dotnet restore Sample.Api.sln'
            }
        }

        stage('Build') {
            steps {
                sh 'dotnet build Sample.Api.sln --configuration Release --no-restore'
            }
        }

        stage('Test') {
            steps {
                sh 'dotnet test Sample.Api.sln --configuration Release --no-build'
            }
        }

        stage('Publish') {
            steps {
                sh 'dotnet publish src/Sample.Api/Sample.Api.csproj --configuration Release --no-build --output artifacts/api'
            }
        }

        stage('Archive Artifact') {
            steps {
                archiveArtifacts artifacts: 'artifacts/api/**', fingerprint: true
            }
        }
    }
}
```

This Jenkinsfile assumes a Linux Jenkins environment. A Windows version can be documented later only if a Windows build agent becomes necessary.

## EF Core and Dapper Notes

The first `sample-dotnet-api` pipeline should not include database migrations yet.

Recommended separation:

- Use this sample to validate .NET restore, build, test, and publish.
- Create a separate EF Core and SQL Server pipeline plan for migration and database validation.
- Keep Dapper as runtime data access, not as the main schema migration mechanism.

## Artifact Plan

The first backend artifact should be the published API output.

Future artifact pattern:

```text
artifacts/api/**
```

Later, if the deployment provider expects a zip file, add a packaging stage after publish.

## What This Pipeline Should Not Do Yet

- Do not deploy the API.
- Do not connect to production SQL Server.
- Do not run EF Core migrations.
- Do not store connection strings in the Jenkinsfile.
- Do not use production credentials.
- Do not publish to the external provider yet.

## Success Criteria

The sample .NET API pipeline is successful when:

- Jenkins checks out the repository.
- The expected .NET SDK is available.
- NuGet restore succeeds.
- The solution builds in Release configuration.
- Tests pass or the lack of tests is explicitly documented.
- The API publish output is created.
- Jenkins archives the published API artifact.

## Next Step After This Pipeline

After the .NET API sample pipeline works, create the EF Core migrations and SQL Server validation plan before designing deployment.
