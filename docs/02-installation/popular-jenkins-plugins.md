# Popular Jenkins Plugins

This chapter documents popular Jenkins plugins and which ones are useful for the Jenkins CI/CD learning lab.

## Purpose

Jenkins plugins extend the base Jenkins controller with source control, pipeline, credentials, build tools, notifications, reporting, security, and deployment capabilities.

The goal is not to install every popular plugin. The goal is to install the minimum set that supports the learning path and then add more only when a real need appears.

## Plugin Strategy

Recommended approach:

1. Start with the Jenkins suggested plugins.
2. Confirm Git and Pipeline support work.
3. Add only plugins required by the next learning step.
4. Keep a list of installed plugins.
5. Review plugin health, maintenance, and security warnings before production use.

Avoid installing many plugins just because they are popular. Each plugin increases maintenance and security surface.

## Essential Plugins for the Learning Lab

| Plugin | Purpose | Priority |
| --- | --- | --- |
| Git plugin | Checkout Git repositories from GitHub and Gitea | Essential |
| Pipeline | Run Jenkins pipelines as code | Essential |
| Pipeline: Stage View | Visualize pipeline stages | Essential |
| Credentials Binding | Use Jenkins credentials safely in pipelines | Essential |
| Workspace Cleanup | Clean workspaces before or after builds | Recommended |
| Timestamper | Add timestamps to console logs | Recommended |
| AnsiColor | Improve colored console output readability | Recommended |

## Source Control Plugins

| Plugin | Purpose | Notes |
| --- | --- | --- |
| Git plugin | Git checkout support | Required for GitHub and Gitea repositories |
| GitHub plugin | GitHub integration features | Useful when GitHub webhooks and status checks are added |
| GitHub Branch Source | GitHub multibranch pipeline support | Useful later for PR and branch-based CI |
| Gitea plugin | Gitea integration | Evaluate after basic Git checkout works |

For the first lab, plain Git checkout is enough. Provider-specific plugins can come later.

## Pipeline Plugins

| Plugin | Purpose | Notes |
| --- | --- | --- |
| Pipeline | Core pipeline support | Required |
| Pipeline: Groovy | Groovy execution support for Jenkinsfiles | Usually included with Pipeline |
| Pipeline: Stage View | Stage visualization | Useful for learning |
| Pipeline Utility Steps | Common helper steps | Useful later for file, JSON, and artifact handling |
| Blue Ocean | Alternative pipeline visualization | Optional; useful for learning, but not required |

Blue Ocean is helpful visually, but it is not required for production-style pipelines.

## Credentials and Security Plugins

| Plugin | Purpose | Notes |
| --- | --- | --- |
| Credentials | Store credentials in Jenkins | Usually installed by default |
| Credentials Binding | Bind credentials to pipeline steps | Required for safe token usage |
| Matrix Authorization Strategy | Fine-grained permissions | Useful when multiple users exist |
| Role-based Authorization Strategy | Role-based access control | Useful for production-like setups |

Start simple with Jenkins users and credentials. Add advanced authorization only when access control becomes necessary.

## Build Tool Plugins

| Plugin | Purpose | Notes |
| --- | --- | --- |
| NodeJS | Manage Node.js installations for Angular builds | Useful for Angular 22 pipelines |
| Docker Pipeline | Use Docker from Jenkins pipelines | Useful if Docker builds or deploys are selected |
| MSBuild | Build legacy Windows/.NET Framework projects | Only needed if Windows build agent becomes necessary |
| Warnings Next Generation | Publish static analysis warnings | Useful later for quality reporting |

For the current stack, NodeJS may be useful for Angular. Modern .NET can often use the .NET SDK installed directly on the Linux agent without a dedicated Jenkins plugin.

## Test and Reporting Plugins

| Plugin | Purpose | Notes |
| --- | --- | --- |
| JUnit | Publish test result reports | Useful for frontend and backend tests |
| HTML Publisher | Publish generated HTML reports | Useful later for coverage or custom reports |
| Cobertura | Coverage reporting | Use only if the project generates compatible reports |
| JaCoCo | Java coverage reporting | Not required for this stack unless Java appears later |

For Angular and .NET, start with basic test execution. Add report publishing when the test output format is known.

## Notification Plugins

| Plugin | Purpose | Notes |
| --- | --- | --- |
| Email Extension | Send email notifications | Useful in production-like environments |
| Slack Notification | Send Slack messages | Only if Slack is used |
| Microsoft Teams Notification | Send Teams messages | Useful if Teams is the team communication tool |

Notifications should come after pipelines are stable. Early noisy notifications are not useful.

## Deployment Plugins

| Plugin | Purpose | Notes |
| --- | --- | --- |
| SSH Agent | Use SSH credentials in pipelines | Useful for deployment to Linux servers |
| Publish Over SSH | Copy artifacts to SSH targets | Useful for simple server deployment, but evaluate security carefully |
| Docker Pipeline | Build and push Docker images | Useful if Docker deployment is selected |
| Kubernetes CLI | Deploy to Kubernetes | Only if Kubernetes becomes the provider target |
| Azure Credentials | Store Azure service principal credentials | Useful if Azure becomes the provider target |

Deployment plugins should be selected only after the external provider is chosen.

## Recommended First Plugin Set

Install or confirm this set first:

Installation checklist: [Jenkins Plugin Installation Checklist](jenkins-plugin-installation-checklist.md).

| Plugin | Reason |
| --- | --- |
| Git plugin | Required for GitHub and Gitea checkout |
| Pipeline | Required for Jenkinsfiles |
| Pipeline: Stage View | Useful for seeing stage progress |
| Credentials Binding | Required for safe token usage |
| Workspace Cleanup | Keeps builds clean |
| Timestamper | Makes logs easier to debug |
| AnsiColor | Improves console readability |

Optional for early learning:

- Blue Ocean.
- NodeJS.

Wait until later:

- Docker Pipeline.
- Role-based Authorization Strategy.
- Deployment-specific plugins.
- Notification plugins.

## Recommended Company Plugin Baseline

A company Jenkins setup usually needs more than the learning-lab minimum, but it should still avoid installing plugins without a clear purpose.

Recommended enterprise baseline:

| Category | Plugin | Why a Company Needs It | Install Priority |
| --- | --- | --- | --- |
| Source control | Git plugin | Standard Git checkout for all repositories | 1 |
| Source control | GitHub plugin | GitHub integration, webhooks, and status checks | 2 |
| Source control | GitHub Branch Source | Multibranch pipelines and pull request workflows | 2 |
| Source control | Gitea plugin | Better self-hosted Gitea integration when needed | 3 |
| Pipeline | Pipeline | Jenkinsfile-based CI/CD | 1 |
| Pipeline | Pipeline: Stage View | Stage visibility for build troubleshooting | 1 |
| Pipeline | Pipeline Utility Steps | Common reusable pipeline operations | 2 |
| Credentials | Credentials | Central credential storage | 1 |
| Credentials | Credentials Binding | Safe credential usage in pipelines | 1 |
| Security | Matrix Authorization Strategy | Fine-grained access control | 3 |
| Security | Role-based Authorization Strategy | Team/role permission model | 3 |
| Operations | Timestamper | Easier audit and debugging in logs | 2 |
| Operations | Workspace Cleanup | Cleaner and more repeatable builds | 2 |
| Operations | AnsiColor | Readable console output | 2 |
| Build tools | NodeJS | Managed Node.js for Angular builds | 2 |
| Build tools | Docker Pipeline | Docker image build and registry workflows | 4 |
| Testing | JUnit | Publish test results from CI | 2 |
| Reporting | HTML Publisher | Publish coverage or generated reports | 3 |
| Quality | Warnings Next Generation | Static analysis and compiler warning reporting | 3 |
| Notifications | Email Extension | Email notifications for important pipeline states | 4 |
| Notifications | Microsoft Teams Notification | Team notifications if Teams is used | 4 |
| Deployment | SSH Agent | SSH-based deployment and server access | 4 |
| Deployment | Publish Over SSH | Simple artifact copy to servers | 4 |
| Cloud | Azure Credentials | Azure deployment credentials if Azure is selected | 5 |
| Cloud | Kubernetes CLI | Kubernetes deployments if Kubernetes is selected | 5 |

The first company baseline should focus on source control, pipelines, credentials, logs, workspace cleanup, Node.js, and test reporting. Deployment, cloud, and notification plugins should wait until the deployment target is known.

## Company Installation Order

Install company plugins in phases, not all at once.

### Phase 1: Core CI Foundation

Install during first setup or immediately after suggested plugins:

1. Git plugin.
2. Pipeline.
3. Pipeline: Stage View.
4. Credentials.
5. Credentials Binding.

Goal: Jenkins can check out repositories, read Jenkinsfiles, run stages, and use credentials safely.

### Phase 2: Daily Build Operations

Install after the first manual pipeline works:

1. Workspace Cleanup.
2. Timestamper.
3. AnsiColor.
4. Pipeline Utility Steps.
5. JUnit.

Goal: builds become easier to debug, cleaner, and more useful for teams.

### Phase 3: Project Stack Support

Install when Angular and .NET pipelines begin:

1. NodeJS.
2. HTML Publisher, if reports are generated.
3. Warnings Next Generation, if static analysis or compiler warning reports are needed.

Goal: Jenkins supports the real Angular 22 and C# API workflow.

Modern .NET usually does not require a Jenkins-specific .NET plugin. Prefer installing the .NET SDK on the Linux build agent and calling `dotnet` from the Jenkinsfile.

### Phase 4: Access Control and Team Usage

Install when more users or teams start using Jenkins:

1. Matrix Authorization Strategy or Role-based Authorization Strategy.
2. GitHub Branch Source, if GitHub pull request and branch pipelines are used.
3. Gitea plugin, if Gitea-specific integration is needed beyond plain Git checkout.

Goal: Jenkins can support teams, permissions, pull requests, and branch-based workflows.

### Phase 5: Deployment and Notifications

Install only after the external provider and deployment method are selected:

1. SSH Agent, if deployment uses SSH.
2. Publish Over SSH, if simple artifact copy is selected.
3. Docker Pipeline, if Docker image build/push is selected.
4. Azure Credentials, if Azure is selected.
5. Kubernetes CLI, if Kubernetes is selected.
6. Email Extension, Microsoft Teams Notification, or Slack Notification, depending on company communication tools.

Goal: Jenkins can deploy and notify without adding unnecessary plugins before the deployment model is known.

## Plugins to Avoid Installing Too Early

Avoid installing these until there is a confirmed use case:

- Kubernetes plugins before Kubernetes is selected.
- Azure plugins before Azure is selected.
- AWS plugins before AWS is selected.
- Legacy MSBuild plugins before a Windows build requirement exists.
- Multiple notification plugins before the team communication channel is selected.
- Report plugins before the project generates compatible reports.
- Large UI plugins only for visual preference.

## Company Plugin Review Checklist

Before installing a plugin in a company Jenkins instance, confirm:

- The plugin solves a current problem.
- The plugin is actively maintained.
- The plugin has no unresolved critical security warning.
- The plugin is compatible with the Jenkins LTS version.
- The plugin is needed by more than one job or a clearly important workflow.
- The plugin can be tested in the lab before production use.
- The plugin owner and purpose are documented.

## Plugin Maintenance Rules

- Install only plugins that support the current learning step.
- Prefer actively maintained plugins.
- Check plugin health before production use.
- Keep plugin versions documented.
- Test plugin updates before production use.
- Remove unused plugins.
- Do not use plugins to hide unclear pipeline design.

## Installation Timing

Recommended order:

1. Install suggested plugins during Jenkins first-time setup.
2. Confirm Git and Pipeline features are available.
3. Add Workspace Cleanup, Timestamper, and AnsiColor.
4. Add Pipeline Utility Steps and JUnit after the first manual pipeline works.
5. Add NodeJS before Angular pipeline work.
6. Add security/authorization plugins when more users or teams use Jenkins.
7. Add Docker Pipeline only if Docker image builds are selected.
8. Add deployment plugins only after the external provider is selected.

## Next Steps

1. During Jenkins setup, install suggested plugins.
2. Compare installed plugins with the recommended first plugin set.
3. Document the installed plugin list.
4. Add new plugins only when the next pipeline step requires them.
