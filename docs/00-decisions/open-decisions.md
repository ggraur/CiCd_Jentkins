# Open Decisions

This document tracks decisions for the Jenkins learning lab and the later production-like evolution. The learning-lab baseline is now decided; provider-specific and real-project details remain open until the real environment is selected.

## Decision Status Legend

| Status | Meaning |
| --- | --- |
| Open | No final decision yet |
| Proposed | A direction exists, but it still needs review |
| Decided | The decision is accepted for the current phase |
| Revisit Later | Not needed now, but should be reviewed later |

## Current Open Decisions

| Decision | Current Status | Proposed Direction | Notes |
| --- | --- | --- | --- |
| VM platform | Decided | Use Hyper-V if available; otherwise use VirtualBox or VMware | Conditional decision keeps the lab practical on the Windows machine |
| Jenkins host OS | Decided | Ubuntu Server LTS | Current recommended direction |
| Jenkins installation style | Decided | Jenkins LTS in Docker | Good for learning and easier backup/recreate |
| VM network mode | Decided | Bridged adapter first, NAT with port forwarding as fallback | Bridged is easiest for Jenkins, Gitea, and Windows browser access |
| Gitea location | Decided | Start on the same Ubuntu VM as Jenkins for the learning lab, move to a separate VM/server later | Compact lab first, production-like separation later |
| GitHub access method | Decided | Start with HTTPS token, add SSH later | Token is easiest for the first checkout; SSH is good long term |
| Gitea access method | Decided | Start with HTTPS token for the lab, add SSH later | Same approach as GitHub unless Gitea SSH is easier in the selected setup |
| First trigger method | Decided | Manual first, polling second, Gitea webhook third, GitHub webhook later | Avoid exposing Jenkins externally too early |
| GitHub webhook strategy | Revisit Later | Use only after Jenkins has secure reachable HTTPS URL | Polling is acceptable for early learning |
| Gitea webhook strategy | Decided | Use local network webhook after Jenkins and Gitea can reach each other | Best first webhook candidate |
| Windows build agent | Revisit Later | Do not add unless proven necessary | Angular and modern .NET should build on Linux |
| Linux build agent | Decided | Add after first real pipelines are stable | Controller can run tiny learning jobs first |
| External provider | Open | Evaluate Azure, VPS, Docker host, Kubernetes, or IIS | Provider determines deployment method |
| Angular hosting target | Open | Decide with external provider | Could be static hosting, App Service, container, or web server |
| C# API hosting target | Open | Decide with external provider | Could be App Service, VM, container, IIS, or Kubernetes |
| SQL Server hosting | Open | Decide before deployment design | Could be managed SQL Server, VM SQL Server, or provider database |
| Staging database strategy | Decided | Use a separate staging database before production | Required before applying migrations automatically |
| Production database migration approval | Decided | Require manual approval | Production schema changes should be reviewed |
| EF Core DbContext and project paths | Open | Capture from the real backend repository | Needed for migration script or bundle commands |
| Real repository layout | Open | Support monorepo and multi-repo until confirmed | Needed before designing final Jenkinsfiles |
| Angular package manager | Open | Confirm npm, pnpm, or yarn | Needed for frontend pipeline commands |
| .NET SDK version | Open | Confirm from the real API project | Needed for backend build agent setup |
| First sample repository | Decided | `jenkins-basic-pipeline` | Best first repository to validate checkout and Jenkinsfile execution |
| EF Core migration execution | Decided | Generate/review first, apply to staging before production | Avoid blind production migrations |
| Artifact strategy | Decided | Build once, publish separate frontend/backend/database artifacts | Deployment should consume CI artifacts instead of rebuilding |
| Deployment method | Open | Build once, publish artifact, deploy same artifact | Exact mechanism depends on provider |
| Staging promotion strategy | Decided | Deploy CI artifacts to staging before production | Staging validates the release candidate |
| Production promotion strategy | Decided | Promote the same approved artifacts to production | Production should not rebuild from source separately |
| Production approval | Decided | Manual approval before production deployment | Required for production-like CI/CD |
| Backup frequency | Decided | Manual in learning, scheduled later | Restore testing matters more than backup creation alone |

## Decisions Already Accepted for Now

- Documentation is in English.
- Documentation files use descriptive names instead of generic `README.md` files.
- The current phase is documentation and planning only.
- Jenkins should get source code from GitHub or Gitea, not from a local Windows folder.
- Ubuntu Server is the preferred Jenkins environment.
- Jenkins installation style is Jenkins LTS in Docker.
- VM networking starts with bridged adapter and falls back to NAT with port forwarding.
- Gitea starts on the same Ubuntu VM as Jenkins for the learning lab.
- GitHub and Gitea access starts with HTTPS tokens, then evolves to SSH keys later.
- Trigger strategy starts manual, then polling, then local Gitea webhooks, then GitHub webhooks later.
- The real stack is Angular 22, C# API, EF Core, Dapper, and SQL Server.
- The first sample repository is `jenkins-basic-pipeline`.

## Remaining Open Items

These items are intentionally left open because they depend on the real project or external provider selection:

- External provider.
- Angular hosting target.
- C# API hosting target.
- SQL Server hosting.
- Real repository layout.
- Angular package manager.
- .NET SDK version.
- EF Core DbContext and project paths.
- Deployment method.

They do not block the learning-lab documentation baseline.

## Decision Priority

High-priority decisions unblock installation and first Git integration:

| Priority | Decision | Why It Matters |
| --- | --- | --- |
| 1 | VM platform | Required before creating the Ubuntu Server VM |
| 2 | VM network mode | Required so Windows, Jenkins, and Gitea can communicate |
| 3 | Jenkins installation style | Required before writing the final installation guide |
| 4 | Gitea location | Required before Gitea URLs and webhooks can be planned |
| 5 | First Git provider and credential method | Required for the first checkout pipeline |
| 6 | First trigger method | Required before deciding manual, polling, or webhook flow |

Medium-priority decisions unblock realistic pipeline design:

| Priority | Decision | Why It Matters |
| --- | --- | --- |
| 7 | Real repository layout | Required before designing final Jenkinsfiles |
| 8 | Angular package manager | Required for frontend install/test/build commands |
| 9 | .NET SDK version | Required for backend build agent setup |
| 10 | EF Core DbContext and project paths | Required for migration artifact commands |

Later decisions unblock deployment:

| Priority | Decision | Why It Matters |
| --- | --- | --- |
| 11 | External provider | Determines deployment tools and hosting model |
| 12 | Angular and API hosting targets | Determines artifact deployment steps |
| 13 | SQL Server hosting | Determines migration and connection strategy |
| 14 | Production approval and rollback | Required before production deployment |
| 15 | Backup frequency | Required before production readiness |

## Decision Review Order

Review decisions in this order before installation starts:

1. VM platform.
2. VM network mode.
3. Jenkins installation style.
4. Gitea location.
5. GitHub and Gitea access methods.
6. First trigger method.
7. First sample repository.
8. Real repository layout.
9. Angular package manager.
10. .NET SDK version.

Review these later, before deployment work starts:

1. External provider.
2. Angular hosting target.
3. C# API hosting target.
4. SQL Server hosting.
5. Artifact strategy.
6. Deployment method.
7. EF Core migration execution.
8. Staging database strategy.
9. Staging promotion strategy.
10. Production promotion strategy.
11. Production approval and rollback.

## How to Update This File

When a decision is made:

1. Change its status to `Decided`.
2. Replace the proposed direction with the selected choice.
3. Add a short reason in the notes column.
4. Update the related chapter if the decision changes the plan.
