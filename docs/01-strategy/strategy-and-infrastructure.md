# Strategy and Infrastructure

This chapter defines the recommended Jenkins learning architecture and explains how it can evolve into a production-ready setup.

## Current Context

The current target stack is:

- Frontend: Angular 22.
- Backend: C# API.
- Data access: Entity Framework Core and Dapper.
- Database: SQL Server.
- Development machine: Windows.
- Source control: GitHub and Gitea.
- Deployment target: an external internet provider or hosting service.

Some infrastructure decisions are still open:

- Gitea can run on the local machine or inside a VM.
- Jenkins will publish to an external provider, but the exact provider is not selected yet.
- A Windows build agent may or may not be needed.
- The webhook strategy is not decided yet.

## Main Recommendation

Use an **Ubuntu Server VM** as the Jenkins environment.

Recommended base architecture:

```text
Windows development machine
  - VS Code
  - Git
  - Project source code

GitHub and/or Gitea
  - Source code repositories
  - Webhooks
  - Pull requests
  - Branches and tags

Ubuntu Server VM
  - Jenkins controller
  - Docker
  - Git
  - Build tools
  - Jenkins pipelines

External provider
  - Staging environment
  - Production environment
  - Published application
```

The most important rule is that Jenkins should not depend directly on source code stored only on the Windows machine. Jenkins should get code from GitHub or Gitea.

The correct flow is:

```text
Developer machine -> commit -> push -> GitHub or Gitea -> Jenkins -> build/test/publish
```

## Why Ubuntu Server

Ubuntu Server is the best default choice for learning Jenkins with a path toward production.

Benefits:

- Jenkins, Docker, Git, SSH, and automation tools are natural on Linux.
- The setup is closer to real CI/CD environments.
- Docker works cleanly on Linux.
- Scripts are usually easier to standardize.
- It avoids many Windows-specific path and permission issues.

Use a Windows VM only when the build requires Windows-specific tooling, such as:

- Legacy .NET Framework.
- Full Visual Studio build tools.
- Windows desktop applications.
- MSI or EXE installer creation.
- Windows-only PowerShell or COM automation.

For modern .NET, Node.js, Angular, Java, Python, Docker, APIs, and web applications, start with Ubuntu Server.

For the current Angular 22 and C# API stack, Ubuntu Server is still a good default for the Jenkins controller and Linux build agent. A Windows build agent should only be added if the build or deployment process requires Windows-only tools.

## VM Requirements

Minimum learning lab resources:

| Resource | Minimum | Preferred |
| --- | --- | --- |
| CPU | 2 cores | 4 cores |
| RAM | 4 GB | 8 GB or more |
| Disk | 40 GB | 80 GB or more |
| Network | NAT with port forwarding | Bridged adapter |

If Jenkins, Gitea, SQL Server containers, and build workloads run on the same VM, prefer the higher values.

## Learning Lab Phase

The first phase should be simple but realistic.

Install:

- Ubuntu Server VM.
- Docker.
- Jenkins LTS.
- Git.
- Optional local Gitea instance if you want a self-hosted Git server in the lab.

Practice:

- Manual Jenkins pipelines.
- Jenkins pipelines from a `Jenkinsfile`.
- GitHub repository checkout.
- Gitea repository checkout.
- Basic credentials.
- Basic build, test, and publish stages.

The goal is to understand the Jenkins workflow without adding too much infrastructure too early.

For this lab, Gitea can be placed in either location:

| Option | Use When | Notes |
| --- | --- | --- |
| Local Windows machine | You already have Gitea installed locally or want the fastest setup | Easier to start, but less production-like |
| Same Ubuntu VM as Jenkins | You want a compact lab environment | Good learning option, but resources are shared |
| Separate VM or server | You want a production-like separation | Best long-term direction |

Recommended path: start with Gitea where it is easiest to operate, then move toward a separate VM or server when the lab becomes more production-like.

## Production-Like Lab Phase

After the first pipelines work, make the lab closer to production.

Add:

- A fixed IP address or local DNS name for Jenkins.
- Reverse proxy with Nginx or Traefik.
- HTTPS, even with an internal certificate.
- Jenkins backup strategy.
- Webhooks from Gitea.
- GitHub integration through polling, a secure tunnel, or a public HTTPS endpoint.
- Separate Jenkins folders for learning, applications, infrastructure, and releases.
- Dedicated credentials for each Git provider.

Recommended Jenkins folder structure:

```text
Jenkins
  learning
  applications
  infrastructure
  releases
```

At this phase, start thinking of Jenkins as a controller. The controller should coordinate builds. Build agents should execute heavier work.

## Production-Ready Phase

A production-ready setup should separate responsibilities.

Target architecture:

```text
Jenkins controller
  - Schedules and coordinates jobs
  - Stores job configuration
  - Manages credentials
  - Shows build history

Linux build agent
  - Builds Node.js, .NET, Java, Python, Docker, and Linux workloads

Windows build agent
  - Used only when Windows-specific builds are required

GitHub and Gitea
  - Source code
  - Webhooks
  - Pull requests

Deployment targets
  - Docker registry
  - Staging server
  - Production server
  - Kubernetes
  - Cloud provider
  - External hosting provider
```

Production concerns:

- Role-based permissions.
- Backup and restore.
- Plugin update strategy.
- Jenkins LTS update strategy.
- Credential rotation.
- Audit logs.
- Build isolation.
- Separate development, staging, and production environments.

For the current stack, a production-ready deployment should eventually define:

- Where the Angular application is hosted.
- Where the C# API is hosted.
- Where SQL Server runs.
- How database migrations are executed.
- How connection strings and secrets are stored.
- Whether deployments go first to staging before production.

## GitHub and Gitea Strategy

Use both GitHub and Gitea in the learning environment.

Use GitHub to learn:

- Cloud Git workflows.
- Pull requests.
- GitHub webhooks.
- GitHub tokens.
- Branch protection.
- CI status checks.

Use Gitea to learn:

- Self-hosted Git.
- Internal webhooks.
- Private repositories.
- Local network CI/CD.
- Production-like internal source control.

Jenkins can work with both because both expose Git repositories.

Example repository URLs:

```text
https://github.com/user/project.git
http://gitea.lab.local/user/project.git
ssh://git@gitea.lab.local/user/project.git
```

For production-style access, use dedicated SSH keys or service tokens. Do not use a personal daily account directly for automation.

## Application Stack Strategy

The real application stack should be represented in the learning environment as early as possible.

Recommended CI flow for Angular 22:

```text
checkout
install dependencies
lint
test
build production bundle
publish frontend artifact
```

Recommended CI flow for the C# API:

```text
checkout
restore NuGet packages
build
run tests
publish API artifact
package deployment output
```

Recommended database flow for SQL Server:

```text
validate connection settings
run EF Core migrations in a controlled stage
run database smoke checks
deploy application after database readiness is confirmed
```

Use Dapper as application runtime data access, not as the main migration tool. EF Core migrations are usually the better fit for schema evolution if the project already uses EF Core.

## Deployment Strategy

Jenkins is expected to publish to an external internet provider or hosting service.

Because the provider is not selected yet, keep deployment generic at first:

```text
build
test
publish artifacts
deploy to staging
run smoke tests
promote to production
```

Provider-specific deployment can be added later for targets such as:

- Azure App Service.
- Azure VM.
- AWS EC2.
- VPS provider.
- Docker host.
- Kubernetes cluster.
- IIS server.

The first production-like rule should be: publish build artifacts first, then deploy those artifacts. Avoid rebuilding separately for each environment.

## Source Code Access Pattern

Jenkins should access code through Git, not through a shared folder from the Windows machine.

Recommended flow:

```text
Windows VS Code
  -> git commit
  -> git push
  -> GitHub or Gitea
  -> Jenkins webhook or polling
  -> Jenkins checkout
  -> build
  -> test
  -> publish
```

Avoid this as the main pattern:

```text
Jenkins -> shared folder on Windows machine -> build local files
```

Shared folders are acceptable for experiments, but they are not a good long-term CI/CD pattern because builds become tied to one developer machine.

## Network Strategy

Use bridged networking for the Ubuntu VM when possible.

Example:

```text
Windows machine: 192.168.1.20
Ubuntu VM:       192.168.1.50
Jenkins URL:     http://192.168.1.50:8080
```

This makes Jenkins behave like another machine on the network.

For a more production-like lab, later add:

```text
http://jenkins.lab.local
https://jenkins.lab.local
```

## Webhook Strategy

For Gitea on the same network:

```text
Gitea -> webhook -> Jenkins
```

This is straightforward because both systems can communicate inside the local network.

For GitHub with local Jenkins, choose one of these options:

- Use Jenkins polling while learning.
- Use a temporary secure tunnel, such as Cloudflare Tunnel or ngrok.
- Expose Jenkins through a secure HTTPS endpoint only when ready.

Do not expose Jenkins directly to the internet without authentication, HTTPS, firewall rules, and a hardening plan.

Current webhook decision: not selected yet.

Recommended path:

1. Start with manual pipeline runs.
2. Add polling for GitHub or Gitea if webhooks are not ready.
3. Add Gitea webhooks inside the local network.
4. Add GitHub webhooks only when Jenkins has a secure reachable URL.

## Windows Build Agent Decision

The development machine uses Windows, but that does not automatically mean Jenkins needs a Windows build agent.

Start without a Windows build agent if the application can be built with cross-platform tooling:

- Angular builds with Node.js on Linux.
- Modern .NET builds with the .NET SDK on Linux.
- EF Core migrations can run from the .NET SDK on Linux if the project and provider support it.
- SQL Server can be external, hosted, or containerized for testing.

Add a Windows build agent only if the pipeline requires:

- Full Visual Studio.
- .NET Framework instead of modern .NET.
- IIS-specific deployment tools from Windows.
- Windows-only scripts or installers.
- COM, registry, desktop, or Windows service build steps.

Decision for now: keep the Jenkins controller and first build agent on Ubuntu. Revisit the Windows agent decision when the first real Angular and C# API pipelines are designed.

## Documentation Structure

Use descriptive file names instead of generic `README.md` files.

Recommended structure:

```text
docs
  index.md
  01-strategy
    strategy-and-infrastructure.md
  02-installation
    ubuntu-vm-and-jenkins-installation.md
  03-github-gitea
    github-and-gitea-integration.md
  04-pipelines
    angular-dotnet-pipelines.md
  05-agents
    jenkins-build-agents.md
  06-security
    credentials-and-hardening.md
  07-backup-restore
    backup-and-restore.md
  08-deployment
    external-provider-deployment.md
  09-production-readiness
    production-readiness-checklist.md
```

## Recommended First Implementation Plan

1. Create an Ubuntu Server VM.
2. Configure bridged networking or stable port forwarding.
3. Install Docker on the Ubuntu VM.
4. Run Jenkins LTS.
5. Access Jenkins from the Windows browser.
6. Configure the first administrator user.
7. Install suggested plugins.
8. Add GitHub credentials.
9. Add Gitea credentials.
10. Create a first manual pipeline.
11. Create a first `Jenkinsfile` pipeline.
12. Connect a Gitea webhook.
13. Connect GitHub using polling or a temporary secure tunnel.
14. Add backup for Jenkins data.
15. Add a separate build agent when builds become heavier.
