# External Provider Deployment

This chapter will document how Jenkins publishes to an external internet provider or hosting service.

No deployment is configured at this stage. This chapter defines the deployment model before choosing a provider.

## Purpose

Separate build, artifact publishing, and deployment so the pipeline can evolve safely.

## Deployment Principle

The pipeline should build once and deploy the same artifact to each environment.

Recommended flow:

```text
checkout
build
test
publish artifacts
deploy to staging
run smoke tests
approve production
deploy to production
```

Avoid rebuilding separately for staging and production. Different environments should use different configuration, not different builds.

## Current Deployment Context

The application stack is:

- Angular 22 frontend.
- C# backend API.
- SQL Server database.
- EF Core migrations.
- Dapper runtime data access.

The deployment target will be an external internet provider or hosting service, but the provider is not selected yet.

## Artifact Inputs

Deployment should consume artifacts produced by the CI pipeline. The deployment pipeline should not rebuild the application for each environment.

Expected artifact inputs from the full-stack pipeline:

| Artifact | Example Pattern | Deployment Role |
| --- | --- | --- |
| Frontend artifact | `frontend/dist/**` | Deploy Angular static files or frontend bundle |
| Backend artifact | `artifacts/api/**` | Deploy published C# API output |
| Database artifact | `artifacts/database/**` | Review or apply EF Core migration output |
| Test reports | Future test report paths | Prove build quality before deployment |

These artifacts are first defined in [Sample Angular, .NET, and SQL Server Pipeline Plan](../04-pipelines/sample-angular-dotnet-sqlserver-pipeline-plan.md).

## Deployment Boundary

The first deployment design should separate three responsibilities:

```text
CI pipeline -> creates artifacts
staging deployment -> deploys and validates artifacts
production promotion -> deploys the same approved artifacts
```

This makes staging and production consistent. Environment-specific values should come from configuration and credentials, not from rebuilding the application.

## Provider Selection Criteria

Choose the external provider based on these questions:

- Can it host the Angular frontend?
- Can it host the C# API?
- Can it provide or connect to SQL Server?
- Does it support staging and production environments?
- Does it support secure deployment credentials?
- Does it support rollback?
- Does it provide logs and monitoring?
- Does it fit the expected budget?
- Does it require Windows hosting, Linux hosting, containers, or a managed platform?

## Deployment Options

| Option | Good For | Notes |
| --- | --- | --- |
| Azure App Service | C# API and web apps | Strong fit for .NET and deployment slots |
| Azure Static Web Apps | Angular frontend | Good if frontend is separate from API |
| Azure SQL Database | Managed SQL Server | Good managed option for SQL Server |
| VPS provider | Flexible hosting | More manual operations responsibility |
| Docker host | Containerized deployment | Good if the app is packaged as containers |
| Kubernetes | Larger production setups | Too much for the first learning phase |
| IIS server | Windows hosting | Useful if the target is Windows/IIS |

Azure is a strong candidate for this stack, but the documentation should stay provider-neutral until the hosting target is chosen.

## Environment Model

Use at least staging and production for a production-like setup.

| Environment | Purpose | Deployment Rule |
| --- | --- | --- |
| Lab | Learn Jenkins and validate pipelines | Manual and experimental |
| Staging | Validate release candidate | Automatic or semi-automatic |
| Production | Serve real users | Manual approval required |

## Angular Deployment Plan

Frontend deployment should eventually include:

```text
build Angular production bundle
publish frontend artifact
deploy artifact to frontend host
run frontend smoke check
```

Information to define later:

- Frontend hosting provider.
- Angular build output folder.
- Environment configuration strategy.
- CDN or static hosting need.
- Custom domain and HTTPS.

Frontend deployment should consume the frontend artifact from the full-stack pipeline.

Do not hard-code backend API URLs in the Jenkinsfile. Use the selected provider's configuration model or environment-specific configuration files generated safely during deployment.

## C# API Deployment Plan

Backend deployment should eventually include:

```text
publish API
publish API artifact
deploy artifact to API host
configure environment variables
run API smoke check
```

Information to define later:

- API hosting provider.
- .NET runtime version.
- Deployment method.
- Environment variable strategy.
- Health check endpoint.
- Logging destination.

Backend deployment should consume the published API artifact from the full-stack pipeline.

Connection strings, API keys, and provider secrets must come from Jenkins credentials, provider secrets, or another approved secret store. They must not be committed to Git.

## SQL Server and Migration Plan

Database deployment must be controlled separately from application deployment.

Recommended production-like path:

```text
generate EF Core migration output
review migration output
apply migration to staging
run staging smoke tests
approve production
apply migration to production
deploy application artifact
```

Rules:

- Do not run production migrations without review.
- Do not store production connection strings in Git.
- Keep staging and production database credentials separate.
- Plan rollback before changing production schema.

Database deployment should consume the database artifact from the full-stack pipeline. The first database artifact should be reviewable, such as an idempotent SQL script or EF Core migration bundle.

Production database migration should not be the first automated deployment task. Start by generating and reviewing migration artifacts, then apply to staging, then consider production with approval.

## Smoke Test Plan

After deployment, Jenkins should eventually verify that the application is alive.

Smoke checks can include:

- Frontend URL returns success.
- API health endpoint returns success.
- API can connect to SQL Server.
- A safe read-only database check succeeds.
- Application version matches the deployed artifact.

Smoke tests should start small and become stricter over time.

Recommended first smoke tests:

| Target | Smoke Test |
| --- | --- |
| Frontend | Main route returns a successful response |
| API | Health endpoint returns success |
| Database | API health check confirms database connectivity |
| Version | Reported version matches deployed artifact version |

## Rollback Strategy

Rollback must be planned before production deployment.

Possible rollback approaches:

- Redeploy the previous artifact.
- Swap deployment slots, if supported by the provider.
- Revert configuration changes.
- Restore database backup only when absolutely necessary.
- Use forward-only database fixes when rollback is unsafe.

Database rollback is harder than application rollback, so database changes should be smaller and reviewed carefully.

## Deployment Pipeline Evolution

Build deployment in stages:

1. Archive artifacts only.
2. Deploy frontend artifact to a temporary or staging target.
3. Deploy backend artifact to a staging target.
4. Run basic smoke checks.
5. Add database migration artifact review.
6. Apply database migration to staging.
7. Add manual approval before production.
8. Promote the same artifacts to production.

Do not skip directly from first build to production deployment.

## Decisions to Capture Later

- Which provider will host the Angular frontend?
- Which provider will host the C# API?
- Where will SQL Server run?
- Will the app deploy as files, containers, or managed services?
- Will staging and production exist from the start?
- What is the rollback method?
- What credentials does Jenkins need for deployment?
- What smoke tests prove deployment success?

## Ready to Continue Criteria

This chapter is ready for implementation planning when:

- The full-stack sample pipeline artifact strategy is accepted.
- The external provider is selected.
- The Angular hosting target is selected.
- The C# API hosting target is selected.
- The SQL Server hosting target is selected.
- Staging and production environment rules are defined.
- Deployment credentials are identified but not written in source code.
- Rollback expectations are documented.
