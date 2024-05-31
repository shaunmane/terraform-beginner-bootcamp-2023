# Terraform Beginner Bootcamp 2023 - Week 0 :cloud:

The purpose of week0 is to prepare for the upcoming project.

- **Setting Up Accounts**: Participants will set up multiple accounts during this period.
- **Objective**: Provide a solid business use case and a comprehensive technical overview.
- **End Goal**: By the end of the prep week, participants will be equipped and ready to commence the project.

## Table of Content
- [Semantic Versioning](#semantic-versioning)
- [Refactor Terraform CLI](#refactor-terraform-cli)
    - [Considerations with the Terraform CLI changes](#considerations-with-the-terraform-cli-changes)
    - [Refactoring to Bash Scripts](#refactoring-to-bash-scripts)
        - [Shebang Considerations](#shebang-considerations)
        - [Linux Permissions Considerations](#linux-permissions-considerations)
        - [Gitpod Lifecycle](#gitpod-lifecycle-before-init-command)
-         





## Semantic Versioning

This project uses semantic versioning for its tagging. 
[semver](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, increments e.g. `1.0.1`
1. **MAJOR** version when you make incompatible API changes
2. **MINOR** version when you add functionality in a backward compatible manner
3. **PATCH** version when you make backward compatible bug fixes

## Refactor Terraform CLI

First you will need to find out what Linux distribution you're using. This will help you in install terrafrom CLI as different distributions have different install instructions. 

[How to check Linux Distribution](https://opensource.com/article/18/6/linux-version) 

To view the distribution, run this command:

```sh
$ cat /etc/os-release
```

Which looks like this:

```
PRETTY_NAME="Ubuntu 22.04.4 LTS"
NAME="Ubuntu"
VERSION_ID="22.04"
VERSION="22.04.4 LTS (Jammy Jellyfish)"
VERSION_CODENAME=jammy
ID=ubuntu
ID_LIKE=debian
HOME_URL="https://www.ubuntu.com/"
SUPPORT_URL="https://help.ubuntu.com/"
BUG_REPORT_URL="https://bugs.launchpad.net/ubuntu/"
PRIVACY_POLICY_URL="https://www.ubuntu.com/legal/terms-and-policies/privacy-policy"
UBUNTU_CODENAME=jammy
```

### Considerations with the Terraform CLI changes

The Terraform CLI installation instructions have changed due to GPG keyring changes therefore we need to change the installation instructions on the gitpod.yml file. We need to refer to the latest CLI installation instructions via the Terraform Documentation and change the script.

[Install Terraform CLI](https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli)

### Refactoring to Bash Scripts

Since the new install instructions are longer, we created a bash script in order to simplify to simply the workflow on the [gitpod.yml](.gitpod.yml) file.

- This will keep the Gitpod Task file  tidy.
- Allow us to debug and manually execute Terraform CLI install easier.
- Allow better portability for other projects that might need the Terraform CLI. 

This bash script is located here: [./bin/install_terraform_cli](./bin/install_terraform_cli)

This simplified the setup from:

```yaml
init: |
    sudo apt-get update && sudo apt-get install -y gnupg software-properties-common curl
    curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
    sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
    sudo apt-get update && sudo apt-get install terraform
```

To this:

```yaml
init: |
    source ./bin/install_terraform_cli
```

#### Shebang Considerations

A [Shebang](https://en.wikipedia.org/wiki/Shebang_(Unix)) `#!` (pronounced Sha-bang) tells the bash script what program that will interpet the script. eg. `#!/bin/bash`

ChatGPT recommends this format for bash: `#!/usr/bin/env bash`

- For portability for different OS distributions.
- Will search the user's PATH for the bash executable.

When executing a bash script, we can use the shorthand notation `./` to execute the bash script. 

If we are using a script in `.gitpod.yml` we need to pount the script to a program to interpret it.

e.g. `source ./bin/install_terraform_cli`

#### Linux Permissions Considerations

In order to make our bash scripts executable we need to change linux permissions for the file to be executable at the user mode.

```sh
chmod u+x ./bin/install_terraform_cli
```

Alternatively:

```sh
chmod 744 ./bin/install_terraform_cli
```

[Chmod](https://en.wikipedia.org/wiki/Chmod)

#### Gitpod Lifecycle (Before, Init, Command)

We need to be careful when using the Init because it will not rerun if we restart an existing workspace.

| Scenario                          | Initialization   |
|-----------------------------------|------------------|
| When starting a new workspace     | `init`           |
| Launching an existing workspace   | No `init`        |

**Solution:**

Use either the `before` or `command` directive as shown below:


```yaml
before: |
     source ./bin/install_terraform_cli
```

[Gitpod Lifecycle](https://www.gitpod.io/docs/configure/workspaces/tasks)


