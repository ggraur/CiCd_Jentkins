# Jenkins Learning Documentation

This documentation is organized as a learning path that can evolve into a production-ready CI/CD setup.

The current phase is documentation and planning only. No software is installed until the installation chapter is reviewed for real execution.

## Chapters

0. [Open Decisions](00-decisions/open-decisions.md)
1. [Strategy and Infrastructure](01-strategy/strategy-and-infrastructure.md)
2. [Ubuntu VM and Jenkins Installation](02-installation/ubuntu-vm-and-jenkins-installation.md)
3. [GitHub and Gitea Integration](03-github-gitea/github-and-gitea-integration.md)
4. [Angular and .NET Pipelines](04-pipelines/angular-dotnet-pipelines.md)
   - [Jenkins Basic Pipeline Plan](04-pipelines/jenkins-basic-pipeline-plan.md)
   - [Sample Angular App Pipeline Plan](04-pipelines/sample-angular-app-pipeline-plan.md)
   - [Sample .NET API Pipeline Plan](04-pipelines/sample-dotnet-api-pipeline-plan.md)
   - [EF Core and SQL Server Validation Plan](04-pipelines/efcore-sqlserver-validation-plan.md)
   - [Sample Angular, .NET, and SQL Server Pipeline Plan](04-pipelines/sample-angular-dotnet-sqlserver-pipeline-plan.md)
5. [Jenkins Build Agents](05-agents/jenkins-build-agents.md)
6. [Credentials and Hardening](06-security/credentials-and-hardening.md)
7. [Backup and Restore](07-backup-restore/backup-and-restore.md)
8. [External Provider Deployment](08-deployment/external-provider-deployment.md)
   - [Serve the Documentation Site](serve/serve-documentation-site.md)
9. [Production Readiness Checklist](09-production-readiness/production-readiness-checklist.md)

## Recommended Reading Order

Start with the strategy chapter, then install the infrastructure, then connect source control, then build real pipelines for the Angular and C# stack.

## Documentation Status

Current documentation progress estimate: **100% complete** for the learning-lab planning/documentation base.

Estimated remaining work for this documentation baseline: **0%**.

Provider-specific and real-project details remain for a later phase after the external provider and real repository structure are known.

| Area | Status | Estimate | Remaining Work |
| --- | --- | --- | --- |
| Structure and index | Complete baseline | 100% | Keep links updated as new documents appear |
| Open decisions | Complete baseline | 100% | Later provider-specific decisions remain tracked |
| Strategy and infrastructure | Complete baseline | 100% | Review only if lab constraints change |
| Installation planning | Complete baseline | 100% | Review before executing commands |
| GitHub and Gitea | Complete baseline | 100% | Use the decided lab sequence when Jenkins exists |
| Pipelines | Complete baseline | 100% | Add final real-project paths after repo layout is known |
| Agents | Complete baseline | 100% | Revisit Windows agent only if required |
| Security | Complete baseline | 100% | Add provider-specific credentials later |
| Backup and restore | Complete baseline | 100% | Add exact commands during implementation phase |
| Deployment | Complete baseline | 100% | Provider-specific deployment remains future work |
| Documentation site serving | Complete baseline | 100% | Use the serve guide for local preview and strict build |
| Production readiness | Complete baseline | 100% | Use checklist during implementation and review |

The remaining work belongs to future implementation, provider selection, and real-project integration, not to this documentation baseline.

## Decision Status Summary

Current high-priority decision state:

| Decision | Status | Direction |
| --- | --- | --- |
| Jenkins host OS | Decided | Ubuntu Server LTS |
| First sample repository | Decided | `jenkins-basic-pipeline` |
| VM platform | Decided | Hyper-V if available, otherwise VirtualBox or VMware |
| VM network mode | Decided | Bridged adapter first, NAT with port forwarding fallback |
| Jenkins installation style | Decided | Jenkins LTS in Docker |
| Gitea location | Decided | Same Ubuntu VM for lab, separate VM/server later |
| GitHub access method | Decided | HTTPS token first, SSH later |
| Gitea access method | Decided | HTTPS token first, SSH later |
| First trigger method | Decided | Manual, polling, Gitea webhook, GitHub webhook later |

## Remaining Future Details

These are intentionally outside the completed learning-lab baseline:

- External provider selection.
- Real Angular and C# repository layout.
- Real Angular package manager.
- Real .NET SDK version.
- Real EF Core project paths and DbContext name.
- Exact deployment method for the selected provider.

## Learning Phases

| Phase | Chapters | Goal |
| --- | --- | --- |
| Planning | 0-1 | Track open decisions, decide architecture, stack assumptions, and open questions |
| Infrastructure | 2 | Prepare the Ubuntu VM and Jenkins installation plan |
| Source control | 3 | Plan GitHub, Gitea, credentials, polling, and webhooks |
| CI pipelines | 4 | Plan Angular 22, C# API, SQL Server, and artifact flow |
| Execution model | 5 | Decide controller, Linux agent, and possible Windows agent usage |
| Security and recovery | 6-7 | Plan credentials, hardening, backup, and restore |
| Delivery | 8 | Plan staging, production, provider deployment, smoke tests, and rollback |
| Readiness | 9 | Validate what is required before production usage |

The files use descriptive names instead of generic `README.md` files so each chapter is clear when opened in the editor.
