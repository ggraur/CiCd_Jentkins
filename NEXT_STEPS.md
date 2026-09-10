# Jenkins Learning Lab - Next Steps

This file tracks the next steps that remain after completing the documentation baseline in `docs`.

## Current Status

The learning-lab planning and documentation baseline is complete.

Current completion for the documentation baseline: **100%**.

No software has been installed yet. The next phase is implementation, starting with the Ubuntu VM and Jenkins installation.

## Baseline Decisions Already Made

- Jenkins host OS: Ubuntu Server LTS.
- Jenkins installation style: Jenkins LTS in Docker.
- VM platform: Hyper-V if available; otherwise VirtualBox or VMware.
- VM network mode: bridged adapter first; NAT with port forwarding as fallback.
- Gitea location for the lab: same Ubuntu VM as Jenkins, then separate VM/server later.
- GitHub access method: HTTPS token first, SSH later.
- Gitea access method: HTTPS token first, SSH later.
- Trigger strategy: manual first, polling second, Gitea webhook third, GitHub webhook later.
- First sample repository: `jenkins-basic-pipeline`.
- Artifact strategy: build once, publish separate frontend, backend, and database artifacts.
- Production deployment rule: manual approval before production.

## Next Phase: Implementation Preparation

Before implementation, there is one documentation quality step if the docs must be served as a site: review [DOCS_SITE_MIGRATION_PLAN.md](DOCS_SITE_MIGRATION_PLAN.md).

The site migration plan tracks how to align this documentation with the EF Core Induction and EF Identity style before publishing Markdown as a site.

Before installing anything, review these documents:

1. [docs/index.md](docs/index.md)
2. [docs/00-decisions/open-decisions.md](docs/00-decisions/open-decisions.md)
3. [docs/02-installation/ubuntu-vm-and-jenkins-installation.md](docs/02-installation/ubuntu-vm-and-jenkins-installation.md)
4. [docs/02-installation/popular-jenkins-plugins.md](docs/02-installation/popular-jenkins-plugins.md)
5. [docs/02-installation/jenkins-plugin-installation-checklist.md](docs/02-installation/jenkins-plugin-installation-checklist.md)
6. [docs/03-github-gitea/github-and-gitea-integration.md](docs/03-github-gitea/github-and-gitea-integration.md)
7. [docs/04-pipelines/jenkins-basic-pipeline-plan.md](docs/04-pipelines/jenkins-basic-pipeline-plan.md)
8. [DOCS_SITE_MIGRATION_PLAN.md](DOCS_SITE_MIGRATION_PLAN.md)

## Documentation Site Migration Step

- Use `C:\Users\graurg\CSO_Gitea_Repo\postout` as the local reference for the EfCoreInduction-style documentation site model.
- Get the EF Core Induction GitHub documentation folder link if exact confirmation is still needed.
- Get the EF Identity GitHub documentation folder link if page-style comparison is still needed.
- Use MkDocs Material as the selected site technology unless the direct reference proves otherwise.
- MkDocs Material scaffold has been added in this repository.
- `mkdocs.yml` has been added.
- `requirements-docs.txt` has been added.
- `scripts/docs.ps1` has been added.
- `theme_overrides` and `docs/styles` have been added.
- Strict site build has passed.
- Documentation serve instructions have been added at `docs/serve/serve-documentation-site.md`.
- Root operational serve instructions have been added at `serve/README.md`.
- Next site task: serve locally and review the generated site in the browser.

## Implementation Step 1: Confirm Host Readiness

- Confirm whether Hyper-V is available on the Windows machine.
- Confirm virtualization is enabled in BIOS or UEFI.
- Confirm available disk space for the Ubuntu VM.
- Confirm available RAM and CPU for the VM.
- Confirm whether bridged networking is allowed on the current network.

## Implementation Step 2: Create the Ubuntu VM

- Create the Ubuntu Server LTS VM.
- Assign CPU, RAM, and disk according to the installation plan.
- Configure bridged networking if possible.
- Enable SSH during or after installation.
- Confirm Windows can reach the VM.

## Implementation Step 3: Install Docker and Jenkins

- Update Ubuntu packages.
- Install Docker.
- Create the Jenkins Docker volume.
- Run Jenkins LTS in Docker.
- Open Jenkins from the Windows browser.
- Complete the first-time Jenkins setup.
- Install suggested plugins.
- Compare installed plugins with the plugin installation checklist.
- Create the administrator user.

## Implementation Step 4: Add Gitea to the Lab

- Run Gitea on the same Ubuntu VM if resources allow it.
- Expose Gitea on port `3000`.
- Confirm Windows can open Gitea.
- Confirm Jenkins can reach Gitea.
- Prepare to move Gitea to a separate VM/server later if needed.

## Implementation Step 5: Prepare Git Credentials

- Create a GitHub token for Jenkins with minimal permissions.
- Create a Gitea token for Jenkins with minimal permissions.
- Store credentials in Jenkins using the documented names.
- Do not store tokens in source code or Jenkinsfiles.
- Add SSH keys later after the first checkout pipelines work.

## Implementation Step 6: Create the First Sample Repository

- Create `jenkins-basic-pipeline` in GitHub first.
- Add a minimal `Jenkinsfile`.
- Add `docs/pipeline-notes.md`.
- Run the first Jenkins Pipeline job manually.
- Confirm checkout, stages, and artifact archive work.
- Recreate or mirror the same repository in Gitea.

## Implementation Step 7: Add Trigger Evolution

- Start with manual Jenkins runs.
- Add polling after manual runs work.
- Add Gitea webhook after Jenkins and Gitea networking is stable.
- Add GitHub webhook only after Jenkins has a secure reachable HTTPS URL.

## Implementation Step 8: Continue Sample Pipelines

- Create `sample-angular-app`.
- Create `sample-dotnet-api`.
- Create EF Core and SQL Server validation flow.
- Create `sample-angular-dotnet-sqlserver` full-stack sample.
- Keep deployment disabled until artifacts and tests are stable.

## Remaining Future Decisions

These are intentionally not closed yet because they depend on the real project or external provider:

- External provider selection.
- Angular hosting target.
- C# API hosting target.
- SQL Server hosting target.
- Real repository layout.
- Angular package manager.
- .NET SDK version.
- EF Core DbContext and project paths.
- Exact deployment method.

## Resume Point

When returning to this project, start here:

1. Open this file.
2. Review the baseline decisions.
3. Open [docs/02-installation/ubuntu-vm-and-jenkins-installation.md](docs/02-installation/ubuntu-vm-and-jenkins-installation.md).
4. Begin with **Implementation Step 1: Confirm Host Readiness**.
