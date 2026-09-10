# Jenkins Build Agents

This chapter will document when and how to use Jenkins build agents.

No Jenkins agents are created at this stage. This chapter defines the decision model and the future implementation path.

## Purpose

Keep the Jenkins controller focused on orchestration and move heavier builds to agents when needed.

## Controller and Agent Concept

Jenkins should be understood as two different responsibilities:

| Component | Responsibility |
| --- | --- |
| Jenkins controller | Stores configuration, schedules jobs, manages credentials, and shows build history |
| Jenkins agent | Executes build steps, tests, packaging, and deployment tasks |

For the first learning lab, small builds can run on the same Ubuntu VM as Jenkins. For a production-like setup, builds should move to agents.

## Current Decision

Start with Ubuntu for Jenkins and the first build environment. Add a Windows agent only if the real pipeline requires Windows-only tooling.

## Why Start Without a Separate Agent

Starting without a separate agent keeps the learning path simpler.

This is acceptable when:

- Builds are small.
- Only one person is using the lab.
- The goal is to learn Jenkins basics.
- Pipelines are still manual or experimental.
- There is no production workload yet.

Move to separate agents when builds become slower, more frequent, or more important.

## Linux Agent Strategy

A Linux agent should be the first real agent for this project stack.

It can build:

- Angular 22 with Node.js.
- C# API with the .NET SDK.
- EF Core migration bundles or scripts.
- Docker images, if Docker deployment is selected later.
- General shell-based automation.

Recommended Linux agent labels:

| Label | Purpose |
| --- | --- |
| `linux` | General Linux workloads |
| `node` | Angular and frontend workloads |
| `dotnet` | C# API workloads |
| `docker` | Docker build workloads |

The same first Linux agent can have multiple labels while the lab is small.

## Windows Agent Decision

The development machine uses Windows, but this does not automatically require a Windows Jenkins agent.

Do not add a Windows agent at the beginning if:

- Angular builds work on Linux.
- The C# API uses modern .NET.
- Deployment does not require Windows-only tooling.
- SQL Server is external, hosted, or accessed over the network.

Add a Windows agent only if one of these becomes true:

- The project requires legacy .NET Framework.
- The build requires full Visual Studio.
- The deployment requires Windows-only IIS tooling.
- The pipeline must build MSI or EXE installers.
- The build uses COM, registry, Windows services, or desktop-specific automation.

Decision for now: Linux first, Windows later only if proven necessary.

## Agent Evolution Plan

Recommended path:

1. Run tiny learning jobs on the Jenkins controller.
2. Create the first Linux agent when Angular and .NET builds become real.
3. Move frontend and backend builds to the Linux agent.
4. Add a Docker-capable agent only if Docker image builds are needed.
5. Add a Windows agent only if Windows-only requirements appear.
6. Restrict production deployment jobs to trusted agents.

## Agent Security Rules

Agents can access source code and sometimes deployment credentials, so they must be treated as trusted machines.

Rules:

- Do not run trusted production deployment jobs on untrusted agents.
- Do not give every agent access to every credential.
- Use labels to control where jobs can run.
- Keep agent tools updated.
- Keep build workspaces clean when secrets or sensitive artifacts are used.
- Prefer dedicated deployment agents for production later.

## Future Agent Types

| Agent Type | Use Case | Priority |
| --- | --- | --- |
| Built-in controller executor | First learning jobs only | Temporary |
| Linux VM agent | Angular, .NET, Git, general builds | First real agent |
| Docker-capable Linux agent | Docker image build and push | Later, if Docker deployment is selected |
| Windows agent | Windows-only build or deploy tooling | Only if required |
| Deployment agent | Controlled staging or production deploys | Production-like phase |

## Questions to Answer Later

- Will Angular and .NET builds run inside Docker containers or directly on the agent?
- Will the external provider require a specific deployment tool?
- Will SQL Server deployment need a dedicated secure network path?
- Will production deployment require approval before running?
- Will build agents be long-running VMs or temporary containers?

## Future Implementation Checklist

- Confirm first pipelines are stable on the controller or first VM.
- Decide whether a separate Linux agent is needed.
- Choose the Linux agent machine or VM.
- Install required build tools on the agent.
- Add Jenkins agent credentials.
- Register the agent in Jenkins.
- Assign labels.
- Move Angular build to the agent.
- Move C# API build to the agent.
- Review whether a Windows agent is still needed.

## Planned Sections

- Controller versus agent responsibilities.
- Linux build agent for Angular, .NET, Docker, and general builds.
- Windows build agent decision criteria.
- Agent labels.
- Agent security.
- Docker-based agents.
- When to stop building on the controller.
