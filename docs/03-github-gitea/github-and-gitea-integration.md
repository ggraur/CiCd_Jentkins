# GitHub and Gitea Integration

This chapter will document how Jenkins connects to GitHub and Gitea.

## Purpose

Make GitHub and Gitea the source of truth for builds instead of using local developer-machine folders.

## Current Documentation Goal

This chapter is still documentation-only. No repositories, tokens, SSH keys, Jenkins jobs, webhooks, or polling schedules are created yet.

The goal is to define the decisions and the future implementation order before touching the real Jenkins environment.

## Steps to Follow

The next work should follow this order.

### 1. Confirm the Lab Infrastructure

Before connecting GitHub or Gitea, confirm the base environment:

- Ubuntu Server VM exists.
- Jenkins is installed and reachable from the Windows browser.
- Jenkins has an administrator user.
- Jenkins has the suggested plugins installed.
- Jenkins can run a simple manual job.

Do not connect real repositories before Jenkins is stable and reachable.

### 2. Decide Where Gitea Will Run

Choose one option for the learning lab:

| Option | Recommendation | Reason |
| --- | --- | --- |
| Gitea on Windows local machine | Good for a fast start | Uses the current development machine |
| Gitea on the same Ubuntu VM as Jenkins | Good compact lab | Keeps services together while learning |
| Gitea on a separate VM | Best production-like option | Separates source control from CI/CD |

Decision: start with Gitea on the same Ubuntu VM as Jenkins for the learning lab, then move Gitea to a separate VM or server when the lab becomes more production-like.

Why this is the proposed learning choice:

- It keeps the first lab compact.
- Jenkins and Gitea can communicate inside the same VM or local network.
- It makes local Gitea webhooks easier to test.
- It avoids depending on the Windows development machine as a server.
- It still allows a clean migration to a separate Git server later.

Production direction: separate Gitea from Jenkins. Source control and CI/CD are different responsibilities and should not depend on the same machine in a serious environment.

## Gitea Location Plan

Use this plan to understand how each option affects Jenkins integration.

| Location | Example URL from Windows | Example URL from Jenkins | Best Use |
| --- | --- | --- | --- |
| Windows local machine | `http://localhost:3000` or `http://WINDOWS_IP:3000` | `http://WINDOWS_IP:3000` | Fast testing if Gitea already exists on Windows |
| Same Ubuntu VM as Jenkins | `http://VM_IP:3000` | `http://localhost:3000` or `http://VM_IP:3000` | Recommended first learning lab |
| Separate VM or server | `http://GITEA_IP:3000` | `http://GITEA_IP:3000` | Best production-like direction |

For the first lab, prefer the same Ubuntu VM as Jenkins if resources allow it. If the VM becomes slow or the lab needs more production separation, move Gitea to a separate VM later.

## Gitea Network Requirements

Jenkins must be able to reach Gitea using the same URL configured in Jenkins jobs.

Required checks later:

- Windows browser can open Gitea.
- Jenkins VM can reach Gitea.
- Gitea can reach Jenkins if webhooks are used.
- The selected Gitea URL is stable.
- The selected Jenkins URL is stable.

If Gitea runs on the same Ubuntu VM as Jenkins, expected local lab URLs are:

```text
Jenkins from Windows: http://VM_IP:8080
Gitea from Windows:   http://VM_IP:3000
Gitea from Jenkins:   http://localhost:3000 or http://VM_IP:3000
```

For Jenkins job configuration, prefer the URL that will remain stable if Gitea later moves to another VM. A local DNS name such as `gitea.lab.local` can be introduced later.

### 3. Create Test Repositories

Create small repositories before using the real application repositories.

Recommended learning repositories:

- `jenkins-basic-pipeline`
- `sample-angular-app`
- `sample-dotnet-api`
- `sample-angular-dotnet-sqlserver`

These repositories help validate Jenkins without risking the real project.

### 4. Connect Jenkins to GitHub

Start with GitHub because it is usually the easiest external Git provider to test.

Initial approach:

1. Create a GitHub token or SSH key for Jenkins.
2. Store it in Jenkins credentials.
3. Create a Pipeline job.
4. Configure the job to read a `Jenkinsfile` from GitHub.
5. Run the pipeline manually.
6. Add polling or webhooks later.

### 5. Connect Jenkins to Gitea

After GitHub works, connect Gitea.

Initial approach:

1. Confirm Jenkins can reach the Gitea URL from the Ubuntu VM.
2. Create a Gitea token or SSH key for Jenkins.
3. Store it in Jenkins credentials.
4. Create a Pipeline job from a Gitea repository.
5. Run the pipeline manually.
6. Add a Gitea webhook when the network path is stable.

### 6. Choose the Trigger Strategy

Start simple and evolve gradually.

Recommended order:

1. Manual pipeline runs.
2. Git polling from Jenkins.
3. Gitea webhooks inside the local network.
4. GitHub webhooks only when Jenkins has a secure reachable URL.

Do not expose Jenkins directly to the internet just to test GitHub webhooks.

### 7. Move to Real Stack Pipelines

After repository checkout works, move to the real stack:

- Angular 22 frontend pipeline.
- C# API pipeline.
- EF Core migration strategy.
- SQL Server validation.
- Artifact publishing.

The detailed implementation belongs in [Angular and .NET Pipelines](../04-pipelines/angular-dotnet-pipelines.md).

### 8. Add Deployment Later

Deployment should come after checkout, build, and test are stable.

The future deployment flow should be:

```text
checkout
build
test
publish artifacts
deploy to staging
run smoke tests
promote to production
```

The deployment provider is not selected yet, so this chapter should stay provider-neutral for now.

## Git Provider Roles

GitHub and Gitea should both be part of the learning path, but they should have clear roles.

| Provider | Learning Role | Production-Like Role |
| --- | --- | --- |
| GitHub | Learn cloud Git workflows, pull requests, tokens, and external integrations | Public or private cloud repositories with CI status checks |
| Gitea | Learn self-hosted Git, local network webhooks, and private internal repositories | Internal source control for private services or lab infrastructure |

Recommended initial direction:

- Use GitHub first for a simple external repository checkout.
- Use Gitea second to learn self-hosted Git and local webhooks.
- Use both with small test repositories before connecting the real Angular and C# repositories.

## Repository Model

Use separate repositories for learning topics. This makes failures easier to understand and avoids mixing too many concepts in one place.

Recommended repositories:

| Repository | Provider | Purpose |
| --- | --- | --- |
| `jenkins-basic-pipeline` | GitHub or Gitea | Minimal Jenkinsfile and checkout validation |
| `sample-angular-app` | GitHub or Gitea | Angular 22 pipeline practice |
| `sample-dotnet-api` | GitHub or Gitea | C# API build, test, and publish practice |
| `sample-angular-dotnet-sqlserver` | GitHub or Gitea | Full-stack pipeline practice with database concerns |
| `jenkins-lab-docs` | GitHub or Gitea | Documentation and architecture notes |

The real application repositories should only be connected after the sample repositories prove that Jenkins can authenticate, check out code, run builds, and publish artifacts.

## Sample Repository Integration Matrix

Each sample repository should prove a different part of the Jenkins learning path.

| Repository | First Provider | Main Validation | Related Plan |
| --- | --- | --- | --- |
| `jenkins-basic-pipeline` | GitHub first | Git checkout, Jenkinsfile loading, stages, artifact archive | [Jenkins Basic Pipeline Plan](../04-pipelines/jenkins-basic-pipeline-plan.md) |
| `sample-angular-app` | GitHub or Gitea | Node.js, package manager, Angular test/build, frontend artifact | [Sample Angular App Pipeline Plan](../04-pipelines/sample-angular-app-pipeline-plan.md) |
| `sample-dotnet-api` | GitHub or Gitea | .NET SDK, restore, build, test, publish, backend artifact | [Sample .NET API Pipeline Plan](../04-pipelines/sample-dotnet-api-pipeline-plan.md) |
| `sample-angular-dotnet-sqlserver` | Gitea after GitHub basics | Full-stack coordination and separated artifacts | [Sample Angular, .NET, and SQL Server Pipeline Plan](../04-pipelines/sample-angular-dotnet-sqlserver-pipeline-plan.md) |

Recommended integration order:

1. Validate `jenkins-basic-pipeline` from GitHub.
2. Validate the same basic pipeline from Gitea.
3. Validate `sample-angular-app` from the provider chosen for frontend learning.
4. Validate `sample-dotnet-api` from the provider chosen for backend learning.
5. Validate `sample-angular-dotnet-sqlserver` after frontend, backend, and database plans are understood separately.

This order keeps each failure small enough to understand.

## First Test Repository: `jenkins-basic-pipeline`

The first repository should be minimal and safe. Its purpose is to validate Jenkins integration with GitHub or Gitea before touching real application code.

Repository goal:

```text
Prove that Jenkins can authenticate, check out a repository, read a Jenkinsfile, run stages, and produce a small artifact.
```

Recommended repository location:

| Option | Use When |
| --- | --- |
| GitHub first | You want to validate external Git provider access first |
| Gitea first | You want to validate local self-hosted Git first |
| Both | You want to compare GitHub and Gitea behavior with the same pipeline |

Recommended first choice: create it in GitHub first, then mirror or recreate it in Gitea after the first checkout works.

Recommended repository structure:

```text
jenkins-basic-pipeline
  Jenkinsfile
  docs
    pipeline-notes.md
  artifacts
    .gitkeep
```

The `artifacts` folder is only a placeholder for learning. Real generated artifacts should be produced by the pipeline, not manually committed.

Recommended Jenkins validation flow:

1. Create the repository.
2. Add a minimal `Jenkinsfile`.
3. Add a short notes file explaining the pipeline purpose.
4. Push the repository to GitHub or Gitea.
5. Create a Jenkins Pipeline job.
6. Configure Jenkins to read the `Jenkinsfile` from Git.
7. Run the job manually.
8. Confirm Jenkins checks out the repository.
9. Confirm all stages run.
10. Confirm a small artifact is archived.

This repository should not contain real application code, real secrets, deployment credentials, or database connection strings.

## Access Method Decision

Jenkins can access Git repositories by HTTPS tokens or SSH keys.

| Method | Best For | Notes |
| --- | --- | --- |
| HTTPS token | Quick setup and GitHub/Gitea API-style access | Easy to rotate, but token permissions must be controlled |
| SSH key | Production-style Git checkout | Good long-term option, requires key management |

Recommended path:

1. Start with HTTPS tokens for the first learning checkout.
2. Add SSH keys after the first pipelines work.
3. Prefer SSH keys or dedicated service tokens for production-like repositories.

Do not use a personal daily account password in Jenkins.

Decision:

- GitHub first access method: HTTPS token.
- Gitea first access method: HTTPS token.
- Later production-like method: SSH keys or dedicated service tokens.

Why HTTPS token first:

- Easier to create and revoke.
- Easier to test during the first Jenkins checkout.
- Works well for both GitHub and Gitea.
- Avoids early SSH key troubleshooting while learning Jenkins basics.

Why add SSH later:

- Common long-term Git automation pattern.
- Good for production-like checkout flows.
- Avoids token usage in Git remote URLs when configured correctly.

Token rules:

- Use a dedicated token for Jenkins.
- Limit access to test repositories first.
- Do not use a personal account password.
- Do not paste tokens into Jenkinsfiles.
- Rotate or remove tokens that are no longer used.

SSH key rules:

- Use a dedicated key pair for Jenkins.
- Do not reuse a personal SSH key.
- Store the private key only in Jenkins credentials or an approved secret store.
- Add the public key only to the required GitHub or Gitea repositories/accounts.

## Credential Planning

Create a naming standard before adding credentials to Jenkins.

Recommended credential IDs:

| Credential ID | Purpose |
| --- | --- |
| `github-token-ci` | GitHub HTTPS token for CI checkout |
| `github-ssh-ci` | GitHub SSH key for CI checkout |
| `gitea-token-ci` | Gitea HTTPS token for CI checkout |
| `gitea-ssh-ci` | Gitea SSH key for CI checkout |
| `external-provider-staging-deploy` | Future staging deployment provider credential |
| `external-provider-production-deploy` | Future production deployment provider credential |
| `sqlserver-ci-connection` | Future SQL Server validation or migration access |

Credential rules:

- Store credentials only in Jenkins credentials or a dedicated secret manager.
- Do not place tokens, passwords, or connection strings in a `Jenkinsfile`.
- Use the minimum permissions required.
- Prefer dedicated automation identities over personal user accounts.

## Trigger Decision Matrix

The trigger strategy should evolve as the environment becomes more stable.

| Stage | Trigger | When to Use |
| --- | --- | --- |
| First learning jobs | Manual run | Best while learning Jenkins basics |
| Early repository integration | Poll SCM | Good when Jenkins is local and not reachable by webhooks |
| Local Gitea integration | Gitea webhook | Best when Gitea and Jenkins are on the same network |
| GitHub integration | GitHub webhook | Use only when Jenkins has a secure reachable URL |

Decision: start with manual runs, then add polling, then add local Gitea webhooks. GitHub webhooks come later only when Jenkins has a secure reachable URL.

Recommended trigger evolution:

| Order | Trigger | Purpose | Risk Level |
| --- | --- | --- | --- |
| 1 | Manual run | Learn Jenkins and validate job configuration | Low |
| 2 | Poll SCM | Detect Git changes without exposing Jenkins externally | Low |
| 3 | Gitea webhook | Validate local event-driven CI inside the lab network | Medium |
| 4 | GitHub webhook | Validate external event-driven CI | Higher until HTTPS and hardening exist |

Manual run is the first trigger because it keeps early failures simple. If the pipeline fails, the cause is more likely to be job configuration, credentials, repository access, or Jenkinsfile logic, not webhook networking.

Polling is acceptable during learning because Jenkins stays local and does not need to be reachable from the internet.

Gitea webhook should be the first real webhook because Gitea and Jenkins can communicate inside the lab network.

GitHub webhook should wait until Jenkins has HTTPS, authentication, firewall rules, and a deliberate exposure strategy.

## Network Questions to Answer Later

Before implementing GitHub or Gitea integration, answer these questions:

- What is the Jenkins URL from the Windows machine?
- What is the Jenkins URL from Gitea?
- What is the Gitea URL from Jenkins?
- Will Gitea run on Windows, the Jenkins VM, or a separate VM?
- Will Jenkins have a stable IP address?
- Will local DNS names be used, such as `jenkins.lab.local` and `gitea.lab.local`?
- Will GitHub access use polling first or a secure tunnel?

## Future Implementation Checklist

Use this checklist when the documentation phase is complete and installation begins.

- Jenkins is running and reachable.
- A test GitHub repository exists.
- A test Gitea repository exists.
- GitHub credential strategy is selected.
- Gitea credential strategy is selected.
- Jenkins credential IDs are created.
- Jenkins can manually check out a GitHub repository.
- Jenkins can manually check out a Gitea repository.
- A minimal `Jenkinsfile` runs from GitHub.
- A minimal `Jenkinsfile` runs from Gitea.
- Polling is tested if webhooks are not ready.
- Gitea webhook is tested inside the local network.
- GitHub webhook is postponed until Jenkins has secure external reachability.

## Decisions to Make Before Implementation

Before creating real Jenkins credentials or jobs, decide:

- Where Gitea will run for the first lab.
- Whether the first GitHub connection uses HTTPS token or SSH key.
- Whether the first Gitea connection uses HTTPS token or SSH key.
- Which test repository will be connected first.
- Whether the first trigger will be manual or polling.
- Whether local DNS names will be used.

### Decision Priority

1. Gitea location.
2. First Git provider for `jenkins-basic-pipeline`.
3. GitHub credential method.
4. Gitea credential method.
5. First trigger method.
6. Local DNS name strategy.

## Ready to Continue Criteria

This chapter is ready for implementation when:

- The Jenkins installation chapter has a reviewed installation path.
- Jenkins is installed and reachable in the lab.
- At least one GitHub test repository exists.
- At least one Gitea test repository exists or the Gitea location is decided.
- Credential naming is accepted.
- The first trigger strategy is selected.

After these criteria are met, continue with the first checkout pipeline and then move to [Angular and .NET Pipelines](../04-pipelines/angular-dotnet-pipelines.md).
