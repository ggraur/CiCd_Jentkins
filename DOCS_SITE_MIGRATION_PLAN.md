# Documentation Style and Site Migration Plan

This file tracks what must be done to make the Jenkins documentation follow the same style as the EF Core Induction and EF Identity documentation, and later serve the Markdown files as a documentation site.

## Current Situation

The Jenkins learning-lab documentation baseline is complete as Markdown content.

Current status:

- Documentation content baseline: complete.
- Markdown structure: organized by chapters.
- Markdown linting: clean at the time of creation.
- Site publishing setup: created with MkDocs Material.
- Local comparison with `postout`: done.
- Site technology reference: MkDocs Material.
- Style comparison with EF Core Induction: partially inferred through `postout`.
- Style comparison with EF Identity: not done yet.
- Strict MkDocs build: passed.
- Serve instructions page: created.
- Root `serve/README.md`: created with operational serve/build instructions.

## Local Reference: `postout`

The local repository at `C:\Users\graurg\CSO_Gitea_Repo\postout` already uses the same documentation-site model described for EfCoreInduction.

Observed structure:

```text
postout
  docs
  mkdocs.yml
  requirements-docs.txt
  scripts
    docs.ps1
  site
  theme_overrides
    partials
      header.html
      copyright.html
```

Observed site stack:

- MkDocs.
- MkDocs Material.
- Pinned Python dependencies in `requirements-docs.txt`.
- PowerShell helper script at `scripts/docs.ps1`.
- Strict build mode.
- Explicit navigation in `mkdocs.yml`.
- Custom CSS under `docs/styles`.
- Theme overrides under `theme_overrides`.
- Generated static output under `site`.

This gives us enough information to prepare this Jenkins documentation for the same style without guessing the site generator.

## Important Requirement

Before changing the documentation style, collect the reference sources:

- GitHub link to the EF Core Induction documentation folder.
- GitHub link to the EF Identity documentation folder or repository.
- Confirmation of how EF Core Induction serves Markdown as a site.

The `postout` repository strongly indicates the site technology should be MkDocs Material. The GitHub references are still useful to confirm exact style conventions before final uniformization.

## Goal

Make this repository ready to publish the Markdown documentation as a site using the same structure and style conventions as the EF Core Induction documentation.

The target result should include:

- Consistent file naming.
- Consistent folder naming.
- Consistent chapter ordering.
- Consistent heading style.
- Consistent navigation structure.
- Site-compatible internal links.
- Optional front matter if the reference site requires it.
- A site configuration file if the reference project uses one.
- A local preview command if the reference project supports it.
- A future deployment path for the documentation site.

## Target Site Structure

Based on `postout`, this repository should later add:

```text
CiCd_Jentkins
  docs
  mkdocs.yml
  requirements-docs.txt
  scripts
    docs.ps1
  theme_overrides
    partials
      header.html
      copyright.html
  site
```

The `site` folder is generated output and should not be edited manually.

## Target Site Configuration

The future `mkdocs.yml` should include the same style of configuration used by `postout`:

- `site_name`.
- `site_description`.
- `site_author`.
- Material theme.
- `theme_overrides` custom directory.
- Navigation features.
- Search plugin.
- Markdown extensions.
- Strict mode support.
- Explicit `nav` structure.
- Optional custom CSS.

The future `requirements-docs.txt` should start with pinned versions, following `postout`:

```text
mkdocs==1.6.1
mkdocs-material==9.7.7
```

## Migration Phases

### Phase 1: Inspect Reference Documentation

Compare this repository with the EF Core Induction and EF Identity documentation.

Check:

- Folder structure.
- Markdown file naming.
- Index or landing page naming.
- Navigation file or site configuration.
- Front matter format.
- Heading hierarchy.
- Table style.
- Code block style.
- Link style.
- Image or asset folder conventions.
- Tone and writing style.
- How pages are ordered in the site.

Output of this phase:

- A short comparison summary.
- A list of style differences.
- A list of required changes for this Jenkins documentation.

### Phase 2: Decide the Site Technology

Decision based on `postout`: use MkDocs Material.

Decision rule:

```text
Use MkDocs Material unless the direct EF Core Induction reference proves a different requirement.
```

Output of this phase:

- Selected site technology.
- Required config files.
- Required package/dependency files.
- Local preview command.
- Build command.
- Publish/deploy command or workflow.

### Phase 3: Normalize Documentation Structure

Align this repository with the reference structure.

Potential changes:

- Rename `docs/index.md` if the reference expects another landing file name.
- Add or change navigation metadata.
- Add front matter to pages if required.
- Create an assets folder if the reference uses one.
- Standardize folder numbering if the reference has a different convention.
- Standardize file names and page titles.

Current local preference:

- Keep descriptive Markdown file names.
- Avoid generic `README.md` files inside chapter folders.

If the reference site requires `README.md`, document the tradeoff before changing this convention.

### Phase 4: Normalize Page Style

Apply the same writing and Markdown conventions used by EF Identity and EF Core Induction.

Check every page for:

- One clear H1 title.
- Predictable H2/H3 hierarchy.
- Consistent intro paragraph.
- Consistent purpose section.
- Consistent tables.
- Consistent callouts or notes.
- Consistent code fence languages.
- No broken internal links.
- No hard tabs.
- One final newline.

Potential standard page template:

```markdown
# Page Title

Short page purpose.

## Purpose

What this page is for.

## Context

What the reader needs to know.

## Steps or Decisions

The actual content.

## Validation

How to confirm the page or process is correct.

## Next Steps

What to read or do next.
```

The final template should be based on the reference projects.

### Phase 5: Add Site Navigation

Create or update site navigation according to the selected site technology.

Navigation should include:

- Open decisions.
- Strategy and infrastructure.
- Ubuntu VM and Jenkins installation.
- GitHub and Gitea integration.
- Pipelines.
- Agents.
- Security.
- Backup and restore.
- Deployment.
- Production readiness.

Pipeline subpages should remain grouped under the pipeline chapter.

Expected MkDocs navigation shape:

```yaml
nav:
  - Home: index.md
  - Decisions:
      - Open Decisions: 00-decisions/open-decisions.md
  - Strategy:
      - Strategy and Infrastructure: 01-strategy/strategy-and-infrastructure.md
  - Installation:
      - Ubuntu VM and Jenkins Installation: 02-installation/ubuntu-vm-and-jenkins-installation.md
  - Source Control:
      - GitHub and Gitea Integration: 03-github-gitea/github-and-gitea-integration.md
  - Pipelines:
      - Angular and .NET Pipelines: 04-pipelines/angular-dotnet-pipelines.md
      - Jenkins Basic Pipeline Plan: 04-pipelines/jenkins-basic-pipeline-plan.md
      - Sample Angular App Pipeline Plan: 04-pipelines/sample-angular-app-pipeline-plan.md
      - Sample .NET API Pipeline Plan: 04-pipelines/sample-dotnet-api-pipeline-plan.md
      - EF Core and SQL Server Validation Plan: 04-pipelines/efcore-sqlserver-validation-plan.md
      - Sample Angular, .NET, and SQL Server Pipeline Plan: 04-pipelines/sample-angular-dotnet-sqlserver-pipeline-plan.md
```

### Phase 6: Add Local Preview and Build Documentation

After the site technology is selected, document:

- Install dependencies.
- Run local preview.
- Build static site.
- Validate links.
- Validate generated output.

Expected commands should follow the `postout` pattern:

```powershell
.\scripts\docs.ps1 -Command Serve
.\scripts\docs.ps1 -Command Build
.\scripts\docs.ps1 -Command Serve -Port 8602 -SkipInstall
```

The script should create `.venv-docs`, install pinned dependencies, serve locally, and build in strict mode.

### Phase 7: Add Site Publishing Plan

Later, decide where the documentation site will be served.

Possible options:

- GitHub Pages.
- Gitea Pages or static hosting, if available.
- External static hosting provider.
- Internal web server.
- Same provider selected for the application documentation.

Publishing should happen only after the local site build works.

## Style Uniformization Checklist

- Compare with EF Core Induction folder structure.
- Compare with EF Identity page style.
- Decide whether current descriptive file names can remain.
- Decide whether numbered folders should remain.
- Add required front matter if needed.
- Normalize all page titles.
- Normalize all intro sections.
- Normalize all `Purpose` sections.
- Normalize tables.
- Normalize code fences.
- Normalize note/callout style.
- Normalize internal links.
- Add navigation configuration.
- Add `mkdocs.yml`.
- Add `requirements-docs.txt`.
- Add `scripts/docs.ps1`.
- Add `theme_overrides` if header/footer customization is needed.
- Add `docs/styles` if custom CSS is needed.
- Add local preview instructions.
- Add build instructions.
- Add publish instructions.
- Validate markdownlint.
- Validate site build.
- Validate internal links.

## Required Changes for This Repository

Based on `postout`, this repository still needs:

- `mkdocs.yml` exists at repository root.
- `requirements-docs.txt` exists at repository root.
- `scripts/docs.ps1` exists at repository root.
- `theme_overrides` exists with Jenkins-specific header and footer partials.
- `docs/styles/cso.css` exists.
- All documentation pages are included in `mkdocs.yml` navigation.
- `docs/serve/serve-documentation-site.md` exists with local serve and build instructions.
- `serve/README.md` exists with root-level operational serve/build instructions.
- Strict MkDocs build has passed.
- Generated `site` output is ignored and must not be edited manually.

## Required Inputs From the Reference Projects

Capture these before editing the current docs for site style:

| Input | Needed For |
| --- | --- |
| EF Core Induction GitHub folder URL | Match structure and publishing method |
| EF Identity GitHub folder URL | Match style and page conventions |
| Site generator/config file | Reuse the same publishing approach |
| Navigation example | Build matching docs navigation |
| Page template example | Normalize all Markdown pages |
| Local preview command | Test the documentation site locally |
| Build command | Generate the static site |

## Recommended Next Action

The next action is to review the generated site locally and then compare page style with EF Identity if exact visual or writing conventions still need to be matched.
