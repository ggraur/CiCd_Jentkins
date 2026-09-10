# Documentation Website

## Purpose

The documentation website uses MkDocs Material, following the same source and rendering model as EfCoreInduction. Markdown files under `docs/` are rendered as a searchable static site with shared navigation, header, and footer.

## Prerequisite

Install Python 3.12 or newer. The script creates an isolated `.venv-docs` environment and installs the pinned packages in `requirements-docs.txt`.

## Serve Locally

From the repository root, run:

```powershell
.\scripts\docs.ps1 -Command Serve

.\scripts\docs.ps1 -Command Build -SkipInstall

.\scripts\docs.ps1 -Command Serve -Port 8601 -SkipInstall
```

Open the site at `http://127.0.0.1:8601`.

Use an alternate port when `8000` is already in use:

```powershell
.\scripts\docs.ps1 -Command Serve -Port 8601
```

## Build

Create a static production site and validate the documentation strictly:

```powershell
.\scripts\docs.ps1 -Command Build
```

MkDocs writes generated output to `site/`. Do not edit generated files manually.

## Add a Document

1. Create the new Markdown file under `docs/`.
2. Add it to the `nav` section in `mkdocs.yml`.
3. Run the strict build command before committing.
