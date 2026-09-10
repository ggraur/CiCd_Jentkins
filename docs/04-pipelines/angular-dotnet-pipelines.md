# Angular and .NET Pipelines

This chapter will document CI pipelines for the real application stack.

No Jenkins pipeline is created at this stage. This chapter defines the pipeline plan before implementation.

## Target Stack

- Angular 22 frontend.
- C# backend API.
- Entity Framework Core.
- Dapper.
- SQL Server.

## Repository Layout Assumptions

The final repository layout is not decided yet. The pipeline documentation should support both common options.

| Layout | Description | Pipeline Impact |
| --- | --- | --- |
| Monorepo | Frontend and backend live in the same repository | One Jenkinsfile can orchestrate frontend, backend, database, and deployment stages |
| Multi-repo | Frontend and backend live in separate repositories | Separate Jenkins jobs or multibranch pipelines may be easier to manage |

Recommended learning path:

1. Start with separate sample repositories for simple learning.
2. Create a full-stack sample repository to practice combined workflows.
3. Match the real application repository layout after the basic pipelines work.

Open decision: confirm whether the real Angular frontend and C# API are in one repository or separate repositories.

## Pipeline Goals

The first real pipelines should prove that Jenkins can:

- Check out the repository from GitHub or Gitea.
- Install frontend dependencies.
- Restore backend dependencies.
- Build Angular 22.
- Build the C# API.
- Run automated tests.
- Prepare publishable artifacts.
- Keep database migration logic controlled and explicit.

## Recommended Pipeline Order

Create pipelines in this order:

1. Minimal checkout pipeline.
2. Angular-only validation pipeline.
3. C# API-only validation pipeline.
4. SQL Server and EF Core migration planning pipeline.
5. Full-stack build pipeline.
6. Artifact publishing pipeline.
7. Staging deployment pipeline.
8. Production promotion pipeline.

Do not start with deployment. Deployment should happen only after checkout, build, tests, and artifact publishing are stable.

## Angular 22 Pipeline Plan

The frontend pipeline should eventually include:

Detailed sample plan: [Sample Angular App Pipeline Plan](sample-angular-app-pipeline-plan.md).

```text
checkout
select Node.js version
install dependencies
run lint
run unit tests
build production bundle
publish frontend artifact
```

Information to define later:

- Node.js version.
- Package manager: npm, pnpm, or yarn.
- Test command.
- Lint command.
- Production build command.
- Output folder, usually `dist`.

## C# API Pipeline Plan

The backend pipeline should eventually include:

Detailed sample plan: [Sample .NET API Pipeline Plan](sample-dotnet-api-pipeline-plan.md).

```text
checkout
select .NET SDK version
restore NuGet packages
build solution
run tests
publish API output
publish backend artifact
```

Information to define later:

- .NET version.
- Solution file path.
- API project path.
- Test project paths.
- Publish output folder.
- Runtime target, if needed.

## SQL Server and EF Core Plan

Database changes need more control than normal application builds.

Detailed database plan: [EF Core and SQL Server Validation Plan](efcore-sqlserver-validation-plan.md).

Recommended approach:

```text
build application
validate EF Core migrations
generate migration script or bundle
review migration output
apply migration to staging
run smoke checks
apply to production only after approval
```

Important rules:

- Do not run database migrations blindly at the start of every build.
- Do not store connection strings in source code.
- Use EF Core migrations for schema changes if the project already uses EF Core.
- Use Dapper for runtime data access, not as the main schema migration mechanism.
- Run production database changes only after staging validation.

## Artifact Strategy

The pipeline should publish artifacts before deployment.

Recommended artifacts:

| Artifact | Source | Purpose |
| --- | --- | --- |
| Angular build output | Frontend build folder | Deploy static frontend files |
| API publish output | .NET publish folder | Deploy backend API |
| Database migration script or bundle | EF Core tooling | Review and apply schema changes |
| Test reports | Frontend and backend tests | Build validation evidence |

The same artifact should move from staging to production. Avoid rebuilding separately for each environment.

## Environment Strategy

Use at least two environments before production usage:

| Environment | Purpose |
| --- | --- |
| Local lab | Learn Jenkins and validate pipeline structure |
| Staging | Test deployment and database changes before production |
| Production | Real users and real data |

Production deployments should require a manual approval step later.

## Decisions to Capture Later

- Are frontend and backend in one repository or separate repositories?
- Which package manager does Angular use?
- Which .NET SDK version does the API use?
- Where is SQL Server hosted?
- How will EF Core migrations be executed?
- Which external provider will host the frontend?
- Which external provider will host the API?
- Will deployment use Docker, zip deploy, SSH copy, IIS, cloud CLI, or another method?

## First Sample Pipeline Plan

The first sample pipeline should be intentionally small. Its purpose is to prove Jenkins can read a `Jenkinsfile` from Git and execute stages.

Detailed plan: [Jenkins Basic Pipeline Plan](jenkins-basic-pipeline-plan.md).

Recommended repository:

```text
jenkins-basic-pipeline
```

Recommended files:

```text
jenkins-basic-pipeline
  Jenkinsfile
  docs
    pipeline-notes.md
```

Recommended stages:

```text
checkout
validate environment
print repository information
simulate build
simulate test
archive simple artifact
```

This pipeline should not deploy anything. It should only prove that Jenkins, GitHub or Gitea, credentials, and pipeline execution work together.

## First Real Pipeline Shape

Detailed full-stack sample plan: [Sample Angular, .NET, and SQL Server Pipeline Plan](sample-angular-dotnet-sqlserver-pipeline-plan.md).

```text
checkout
restore or install dependencies
build
test
publish artifacts
deploy to staging
run smoke tests
promote to production
```

## Ready to Continue Criteria

This chapter is ready for first implementation after:

- Jenkins can run a basic manual job.
- Jenkins can check out at least one GitHub or Gitea repository.
- The first sample repository is selected.
- The first credential method is selected.
- The Angular package manager is known.
- The .NET SDK version is known.
- The real repository layout is known or a sample layout is selected.
