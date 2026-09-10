# Jenkins Plugin Installation Checklist

This checklist turns the plugin strategy into an installation-ready list for the first Jenkins setup.

## Purpose

Use this document during Jenkins setup to decide which plugins to install, which plugins to postpone, and which installed plugins must be recorded for future maintenance.

## First Setup Plugin Decision

During the Jenkins first-time setup wizard, choose:

```text
Install suggested plugins
```

After the suggested plugins finish installing, compare the installed list with the checklist below.

## Install or Confirm Immediately

These plugins are required for the first useful company-style Jenkins setup.

| Plugin | Required For | Status |
| --- | --- | --- |
| Git plugin | GitHub and Gitea checkout | To confirm |
| Pipeline | Jenkinsfile-based pipelines | To confirm |
| Pipeline: Stage View | Pipeline stage visibility | To confirm |
| Credentials | Jenkins credential storage | To confirm |
| Credentials Binding | Safe credential use in pipelines | To confirm |

Do not continue to GitHub or Gitea integration until these are available.

## Install After the First Manual Pipeline Works

These plugins improve daily build operation and troubleshooting.

| Plugin | Required For | Status |
| --- | --- | --- |
| Workspace Cleanup | Clean repeatable workspaces | To install later |
| Timestamper | Easier log troubleshooting | To install later |
| AnsiColor | More readable console output | To install later |
| Pipeline Utility Steps | Reusable pipeline helper steps | To install later |
| JUnit | Test result publishing | To install later |

Install these after the first `jenkins-basic-pipeline` job can run manually.

## Install Before Angular Pipeline Work

These plugins support the Angular 22 sample and future frontend pipeline.

| Plugin | Required For | Status |
| --- | --- | --- |
| NodeJS | Managed Node.js installation for Angular builds | To install later |

If Node.js is installed directly on the Linux agent instead of managed by Jenkins, document that decision before skipping the NodeJS plugin.

## Install When Team Access Is Needed

These plugins are useful when Jenkins is used by more than one person or team.

| Plugin | Required For | Status |
| --- | --- | --- |
| Matrix Authorization Strategy | Fine-grained permissions | Wait |
| Role-based Authorization Strategy | Team-based roles | Wait |
| GitHub Branch Source | Multibranch and pull request pipelines | Wait |
| Gitea plugin | Gitea-specific integration beyond plain Git checkout | Wait |

Do not add these until the user and repository model is clearer.

## Install Only After Deployment Target Is Selected

These plugins depend on the selected provider or deployment style.

| Plugin | Required For | Status |
| --- | --- | --- |
| SSH Agent | SSH-based deployment | Wait |
| Publish Over SSH | Copy artifacts to servers | Wait |
| Docker Pipeline | Docker image build and registry flow | Wait |
| Azure Credentials | Azure deployment | Wait |
| Kubernetes CLI | Kubernetes deployment | Wait |
| Email Extension | Email notifications | Wait |
| Microsoft Teams Notification | Teams notifications | Wait |
| Slack Notification | Slack notifications | Wait |

Do not install deployment, cloud, or notification plugins before the deployment provider and communication channel are selected.

## Plugins to Avoid in the First Setup

Avoid these during the first Jenkins setup unless a specific requirement appears:

- Cloud-provider plugins before the provider is selected.
- Kubernetes plugins before Kubernetes is selected.
- Windows/MSBuild plugins before a Windows build agent requirement exists.
- Multiple notification plugins before the communication channel is selected.
- Report plugins before the project generates compatible reports.
- UI-only plugins that do not support the learning path.

## Installed Plugin Record

When Jenkins is installed later, record the real installed plugins here.

| Plugin | Version | Why Installed | Installed During | Keep/Remove Decision |
| --- | --- | --- | --- | --- |
| To be recorded | To be recorded | To be recorded | To be recorded | To be recorded |

## Plugin Review Questions

Before installing any plugin, answer:

- What current problem does this plugin solve?
- Is it required for the next learning step?
- Is it maintained and compatible with the Jenkins LTS version?
- Does it add security or maintenance risk?
- Can the same result be achieved with an existing plugin or normal Jenkinsfile step?

## Next Steps

1. Use this checklist during Jenkins first-time setup.
2. Confirm the core plugins after suggested plugin installation.
3. Install operational plugins only after the first manual pipeline works.
4. Record the real installed plugin list.
5. Review plugins again before production-like usage.
