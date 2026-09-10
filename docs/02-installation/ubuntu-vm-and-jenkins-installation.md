# Ubuntu VM and Jenkins Installation

This chapter will contain the step-by-step installation path for the first Jenkins learning environment.

No installation is performed at this stage. This chapter is the completed planning base that will be reviewed later when the lab is installed.

## Purpose

Create a working Jenkins instance on an Ubuntu Server VM that can later evolve into a production-like environment.

## Installation Strategy

The recommended installation path is:

```text
Windows development machine
-> Ubuntu Server VM
-> Docker
-> Jenkins LTS container
-> Jenkins first-time setup
-> GitHub and Gitea integration
```

This keeps the learning setup simple, clean, and close to a production-style architecture.

## Decisions for the First Lab

| Area | Decision | Reason |
| --- | --- | --- |
| Jenkins host OS | Ubuntu Server | Best default for Jenkins, Docker, Git, and automation |
| Jenkins installation style | Docker container | Easy to recreate, backup, and evolve |
| Access from Windows | Browser to VM IP address | Keeps Jenkins as a server process |
| Source code access | GitHub and Gitea | Avoids dependency on local folders |
| Initial build location | Jenkins controller or same VM | Acceptable for small learning builds |
| Future build location | Dedicated agents | Better production direction |

Related plugin guidance: [Popular Jenkins Plugins](popular-jenkins-plugins.md).

## What We Are Not Doing Yet

- Installing Ubuntu.
- Installing Docker.
- Running Jenkins.
- Creating real Jenkins jobs.
- Connecting real repositories.
- Publishing to an external provider.
- Exposing Jenkins to the internet.

The current goal is documentation and decision preparation only.

## VM Planning

Recommended VM settings for the first lab:

| Resource | Minimum | Preferred |
| --- | --- | --- |
| CPU | 2 cores | 4 cores |
| RAM | 4 GB | 8 GB |
| Disk | 40 GB | 80 GB or more |
| Network | NAT with port forwarding | Bridged adapter |
| Operating system | Ubuntu Server LTS | Ubuntu Server LTS |

Use bridged networking if possible. It makes the VM behave like another machine on the network and makes Jenkins easier to access from Windows.

Decision: use bridged networking first. Use NAT with port forwarding only if bridged networking is not available or not stable.

Example future network shape:

```text
Windows machine: 192.168.1.20
Ubuntu VM:       192.168.1.50
Jenkins URL:     http://192.168.1.50:8080
```

## Network Mode Decision

Preferred option: bridged networking.

| Mode | Use When | Result |
| --- | --- | --- |
| Bridged adapter | The network allows the VM to appear as another machine | Windows, Jenkins, and Gitea can communicate more naturally |
| NAT with port forwarding | Bridged is blocked or unstable | Requires explicit forwarding for Jenkins and SSH ports |

Why bridged is preferred:

- The Ubuntu VM gets its own network IP address.
- Jenkins is easier to open from the Windows browser.
- Gitea webhooks are easier to reason about on the local network.
- SSH access to the VM is simpler.
- The setup feels closer to a small production server.

Fallback NAT port forwarding plan:

| Host Port | Guest Port | Purpose |
| --- | --- | --- |
| `2222` | `22` | SSH into the Ubuntu VM |
| `8080` | `8080` | Jenkins web UI |
| `50000` | `50000` | Future Jenkins inbound agents, if needed |
| `3000` | `3000` | Gitea web UI, only if Gitea runs on the VM |

If NAT is used, every service that must be reached from Windows needs a port forwarding rule.

## VM Software Options

Any of these can work for the learning lab:

| Tool | Recommendation | Notes |
| --- | --- | --- |
| Hyper-V | Prefer if available | Native on Windows Pro/Enterprise and works well for Ubuntu Server labs |
| VirtualBox | Good fallback | Free and common, but networking can need extra care |
| VMware Workstation Player or Pro | Good fallback | Stable general option for Windows hosts |

Choose one VM platform and keep notes about the exact configuration used.

Decision: use Hyper-V if it is available on the Windows machine. If Hyper-V is not available or causes conflicts, use VirtualBox or VMware.

## Recommended VM Choice for This Lab

For this learning path, prefer this setup unless a blocker appears:

| Item | Recommended Value |
| --- | --- |
| VM platform | Hyper-V if available; otherwise VirtualBox or VMware |
| Guest OS | Ubuntu Server LTS |
| CPU | 4 cores if available |
| RAM | 8 GB if available |
| Disk | 80 GB if available |
| Network | Bridged adapter |
| Access method | SSH from Windows terminal and browser access to Jenkins |

The VM should be treated as a small server, not as a second desktop machine.

## Host Machine Preparation Notes

Before installation, confirm these items on the Windows development machine:

- Enough free disk space for the VM.
- Virtualization is enabled in BIOS or UEFI.
- A VM platform is selected.
- The Windows firewall will allow browser access to the VM if needed.
- Git remains installed on Windows for development work.
- VS Code remains the main editor for application code and documentation.

The Windows machine should be used for development. Jenkins should use GitHub or Gitea to get source code.

## Ubuntu Installation Planning

When the installation is performed later, the Ubuntu setup should follow these decisions:

| Area | Decision |
| --- | --- |
| Installation type | Minimal Ubuntu Server installation |
| User account | Non-root administrator user |
| SSH | Enabled for administration |
| Updates | Apply operating system updates after first boot |
| Static access | Prefer stable IP or DHCP reservation |
| Desktop UI | Not required |

Avoid installing unnecessary packages during the first setup. Start small and add tools only when Jenkins needs them.

## Expected Services and Ports

| Service | Port | Purpose |
| --- | --- | --- |
| SSH | 22 | Admin access to the Ubuntu VM |
| Jenkins web UI | 8080 | Jenkins browser interface |
| Jenkins inbound agent port | 50000 | Future inbound Jenkins agents |
| Gitea web UI | 3000 | Only if Gitea runs in the lab |
| HTTP reverse proxy | 80 | Future friendly access URL |
| HTTPS reverse proxy | 443 | Future secure access URL |

For the first lab, only SSH and Jenkins web UI are required.

Decision: run Gitea on the same Ubuntu VM as Jenkins during the learning lab if the VM has enough resources. This keeps the lab compact while still using Git instead of Windows shared folders.

If Gitea runs on the same VM, port `3000` becomes part of the lab access plan. If NAT is used instead of bridged networking, add a port forwarding rule for Gitea.

## Future Command Groups

These command groups will be documented in full before execution. They are listed here only as planning categories.

| Command Group | Purpose |
| --- | --- |
| Ubuntu update commands | Bring the VM up to date |
| Docker installation commands | Install and enable Docker |
| Jenkins volume commands | Create persistent Jenkins storage |
| Jenkins container commands | Start Jenkins LTS |
| Validation commands | Confirm Docker and Jenkins are running |
| Log commands | Troubleshoot startup problems |

Commands should be copied into the documentation only after the installation path is reviewed.

## Future Commands Reference

The commands below are placeholders for the future installation guide. They are not meant to be run during the documentation phase.

> Do not run these commands yet. They are included only to prepare the future installation guide.

### Ubuntu Update Commands

Purpose:

```text
Update package metadata and apply operating system updates after Ubuntu Server is installed.
```

Future commands:

```sh
sudo apt update
sudo apt upgrade -y
sudo reboot
```

Future validation after reboot:

```sh
hostnamectl
ip addr
```

What to record later:

- Ubuntu version.
- VM hostname.
- VM IP address.
- Whether the Windows machine can reach the VM after reboot.

### Docker Installation Commands

Purpose:

```text
Install Docker Engine on the Ubuntu VM so Jenkins can run as a container.
```

Future commands:

```sh
sudo apt update
sudo apt install -y ca-certificates curl gnupg
sudo install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg \
  | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
sudo chmod a+r /etc/apt/keyrings/docker.gpg
```

```sh
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
  | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
```

```sh
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
sudo systemctl enable docker
sudo systemctl status docker
docker --version
```

Optional future command if the selected admin user should run Docker without `sudo`:

```sh
sudo usermod -aG docker $USER
```

After adding the user to the `docker` group, sign out and sign back in before testing Docker without `sudo`.

What to record later:

- Docker version.
- Docker installation method.
- Whether Docker starts automatically.
- Whether the admin user can run Docker commands.

### Jenkins Storage Commands

Purpose:

```text
Create persistent storage so Jenkins configuration survives container recreation.
```

Future commands:

```sh
docker volume create jenkins_home
docker volume inspect jenkins_home
```

What to record later:

- Docker volume name.
- Whether the lab uses a Docker volume or host directory.
- Backup method for the Jenkins storage.

### Jenkins Container Commands

Purpose:

```text
Start Jenkins LTS and expose only the ports needed for the lab.
```

Future commands:

```sh
docker pull jenkins/jenkins:lts-jdk17
```

```sh
docker run --name jenkins-local \
  --detach \
  --restart unless-stopped \
  --publish 8080:8080 \
  --publish 50000:50000 \
  --volume jenkins_home:/var/jenkins_home \
  jenkins/jenkins:lts-jdk17
```

Future command to retrieve the first administrator password:

```sh
docker exec jenkins-local cat /var/jenkins_home/secrets/initialAdminPassword
```

What to record later:

- Jenkins image tag.
- Container name.
- Published ports.
- Jenkins URL from the Windows browser.
- Whether the initial setup screen appears.

### Validation Commands

Purpose:

```text
Confirm each installation layer works before moving to the next layer.
```

Future commands:

```sh
docker ps
docker logs jenkins-local --tail 100
```

```sh
curl -I http://localhost:8080
```

Future validation from the Windows browser:

```text
http://VM_IP_ADDRESS:8080
```

Expected result:

- Jenkins initial setup screen opens.
- Jenkins asks for the initial administrator password.
- Docker shows the `jenkins-local` container as running.

### Troubleshooting Commands

Purpose:

```text
Collect enough information to diagnose failed startup, network, or container problems.
```

Future commands:

```sh
ip addr
ss -tulpn
docker ps -a
docker logs jenkins-local --tail 200
df -h
free -h
sudo ufw status
```

Common troubleshooting checks:

- Confirm the VM has an IP address.
- Confirm port `8080` is published by Docker.
- Confirm Jenkins did not exit after startup.
- Confirm the Windows machine can reach the VM IP address.
- Confirm no firewall is blocking access.

## Future Installation Phases

### Phase 1: Prepare the VM

Goal: create a clean Ubuntu Server VM reachable from the Windows machine.

Planned actions:

1. Choose the VM platform.
2. Download Ubuntu Server LTS.
3. Create the VM.
4. Assign CPU, memory, and disk.
5. Configure bridged networking or port forwarding.
6. Install Ubuntu Server.
7. Create a non-root admin user.
8. Enable SSH.
9. Confirm the Windows machine can reach the VM.

### Phase 2: Prepare Docker

Goal: make the VM ready to run Jenkins as a container.

Planned actions:

1. Update Ubuntu packages.
2. Install Docker.
3. Enable Docker at startup.
4. Confirm Docker runs successfully.
5. Decide how Jenkins data will be stored.

### Phase 3: Run Jenkins

Goal: start Jenkins LTS with persistent storage.

Planned actions:

1. Create a Jenkins data volume.
2. Run the Jenkins LTS container.
3. Publish the Jenkins web port.
4. Publish the future agent port.
5. Confirm Jenkins is running.
6. Open Jenkins from the Windows browser.
7. Retrieve the initial administrator password.

### Phase 4: Complete Jenkins Setup

Goal: finish the first Jenkins configuration.

Planned actions:

1. Unlock Jenkins with the initial password.
2. Install suggested plugins.
3. Create the administrator user.
4. Confirm the Jenkins URL.
5. Confirm Jenkins can run a simple manual job.

### Phase 5: Prepare for Git Integration

Goal: make Jenkins ready to connect to GitHub and Gitea.

Planned actions:

1. Confirm Git is available to Jenkins.
2. Confirm Jenkins can reach GitHub.
3. Confirm Jenkins can reach Gitea.
4. Prepare credentials for GitHub.
5. Prepare credentials for Gitea.
6. Continue in [GitHub and Gitea Integration](../03-github-gitea/github-and-gitea-integration.md).

## Documentation Notes to Capture During Installation

When installation happens later, record these values:

- VM platform used.
- Ubuntu version.
- VM CPU, RAM, and disk.
- Network mode.
- VM IP address.
- Jenkins URL.
- Jenkins container name.
- Jenkins Docker volume name.
- Installed Jenkins version.
- Installed plugin list.
- Any errors and how they were fixed.

## Future Step-by-Step Documentation Outline

The installation guide should eventually be written in this exact order.

### 1. Select the VM Platform

Document:

- Selected VM software.
- Version installed.
- Why it was selected.
- Any Windows-specific requirements.

### 2. Download Ubuntu Server LTS

Document:

- Ubuntu version.
- ISO source.
- Checksum verification decision.

### 3. Create the VM

Document:

- VM name.
- CPU allocation.
- RAM allocation.
- Disk size.
- Network mode.
- Whether clipboard or shared folders are enabled.

Shared folders are not required for Jenkins source code access.

### 4. Install Ubuntu Server

Document:

- Username created.
- SSH enabled or not.
- Disk layout selected.
- Any packages selected during install.

### 5. Validate Network Access

Document:

- VM IP address.
- Whether Windows can reach the VM.
- Whether SSH works.
- Whether the VM can reach the internet.

### 6. Install Docker

Document:

- Docker installation method.
- Docker version.
- Whether Docker starts automatically.
- Which user can run Docker commands.

### 7. Start Jenkins LTS

Document:

- Jenkins image used.
- Container name.
- Docker volume name.
- Published ports.
- Jenkins URL from Windows.

### 8. Complete Jenkins First-Time Setup

Document:

- Jenkins version.
- Plugin installation option selected.
- Administrator username.
- Jenkins URL configured.

Do not document passwords or secrets.

### 9. Validate the First Jenkins Job

Document:

- Job name.
- Job type.
- Command used.
- Expected console output.
- Any error and how it was fixed.

### 10. Prepare for GitHub and Gitea

Document:

- Whether Jenkins can reach GitHub.
- Whether Jenkins can reach Gitea.
- Which credential method will be used first.
- Whether triggers will start as manual, polling, or webhook.

## Initial Installation Checklist

- Ubuntu Server VM exists.
- VM network is reachable from the Windows machine.
- Docker is installed in the VM.
- Jenkins container is running.
- Jenkins UI opens from Windows.
- Initial administrator password is retrieved.
- Suggested plugins are installed.
- Administrator user is created.
