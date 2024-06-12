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
- [Environment Variables](#environment-variables)
    - [Env Var Command](#env-command)
    - [Setting and Unsetting Env Vars](#setting-and-unsetting-env-vars)
    - [Printing Env Vars](#printing-env-vars)
    - [Scoping op Env Vars](#scoping-of-env-vars)
    - [Persisting Env Vars in Gitpod](#persisting-env-vars-in-gitpod)
- [Refactor AWS CLI](#refactor-aws-cli)
    - [AWS CLI Installation](#aws-cli-installation)
- [Terraform Basics](#terraform-basics)
    - [Terraform Registry](#terraform-registry)
    - [Terraform Console](#terraform-console)
        - [Terraform Init](#terraform-init)
        - [Terraform Plan](#terraform-plan)
        - [Terraform Apply](#terraform-apply)
        - [Terraform Destroy](#terraform-destroy)
        - [Terraform Lock Files](#terraform-lock-files)
        - [Terraform State Files](#terraform-state-files)
        - [Terraform Directory](#terraform-directory)


## Semantic Versioning

This project uses semantic versioning for its tagging. 
[semver](https://semver.org/)

The general format:

**MAJOR.MINOR.PATCH**, increments e.g. `1.0.1`
1. **`MAJOR`** version when you make incompatible API changes
2. **`MINOR`** version when you add functionality in a backward compatible manner
3. **`PATCH`** version when you make backward compatible bug fixes

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

## Environment Variables

### Env Command

We can list out all Environment Variables (Env Var) using the `env` command.

We can filter specific env vars using the grep e.g. `env | grep AWS_`

### Setting and Unsetting Env Vars

In the terminal we can set an env var using `export HELLO='world'`

In the terminal we can unset the env var using `unset HELLO`

We can set an env var temporarily when just running a command

```sh
HELLO='world' .bin/print_message
```

Within a bash script we can set env without writing export e.g. 

```sh
#!/user/bin/env bash

HELLO='world'

echo $HELLO
```

### Printing Env Vars

We can print an env var using echo e.g. `echo $HELLO`

### Scoping of Env Vars

When you open up a new terminal in VSCode, it will not be aware of env vars that you have ste in another window.

If you want the Env Vars to persist across all future bash terminals that are open, you need to set env vars in your bash profile. e.g. `.bash_profile`

### Persisting Env Vars in Gitpod

We can persist env vars into gitpod by storing them in Gitpod Secret Storage.

```sh
gp env HELLO='world'
```

All future workspaces launched will set the env vars for all bash terminals opened in those workspaces

## Refactor AWS CLI

In order to simplify our setup for the AWS CLI Installation, we will update the environment variable to match the previously established one in the [`gitpod.yml`](.gitpod.yml) file. 

This is how these commands are initially executed in Gitpod:
```yaml
before: |
  cd /workspace
  curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
  unzip awscliv2.zip
  sudo ./aws/install
  cd $THEIA_WORKSPACE_ROOT
```

Now, instead of duplicating this code in various places, we can simply reference our newly created script like this:

```yaml
before: |
  source .bin/install_aws_cli
```

This approach not only simplifies our workflow but also ensures consistency and ease of maintenance.

The AWS CLI Installation commands are stored in the bash script - [`./bin/install_aws_cli`](./bin/install_aws_cli)

### AWS CLI Installation

[AWS CLI Getting Started Install](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html) | [AWS CLI Env Vars](https://docs.aws.amazon.com/cli/v1/userguide/cli-configure-envvars.html)

We can check if our AWS credentials is configured correctly by running the following command:

```sh
aws sts get-caller-identity
```

To set env vars, use the following commands:

```sh
export AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
export AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
export AWS_DEFAULT_REGION='us-west-2'
```

To set env vars in Gitpod:

```sh
gp env AWS_ACCESS_KEY_ID='AKIAIOSFODNN7EXAMPLE'
gp env AWS_SECRET_ACCESS_KEY='wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY'
gp env AWS_DEFAULT_REGION='us-west-2'
```

If it is succesful, you should see a JSON payload return that looks like this:

```json
{
    "UserId": "AIEAVUO15ZPVHJ5WIJ5KR",
    "Account": "123456789012",
    "Arn": "arn:aws:iam::123456789012:user/terraform-beginner-bootcamp"
}
```

We will need to generate AWS CLI credits from IAM User in order to use the AWS CLI.

## Terraform Basics

### Terraform Registry

Terraform sources their providers and modules from the Terraform registry which is located at [registry.terraform.io](https://registry.terraform.io/)

- **Providers** is an interface to APIs that will allow you to create resources in terraform.
- **Modules** are a way to make large amounts of terraform code modular, portable, and sharable.

[Random Provider](https://registry.terraform.io/providers/hashicorp/random/latest/docs)

### Terraform Console

We can see a list of all the Terraform commands by simply typing `terraform`.

#### Terraform Init

At the start of a new  terraform project, we will run `terraform init` to download the binaries for the terraform providers that we will use in this project.

#### Terraform Plan

`terraform plan`

This will generate out a changeset about the state of our infrastructure and what will be changed.

We can output this changeset ie. "plan" to be passed to an apply, but often you can just ignore outputting.

#### Terraform Apply

`terraform apply`

This will run a plan and pass the changeset to be executed by terraform. Apply should prompt us for a `yes` or `no`.

If we want to automatically approve an apply, we can provide the auto approve flag e.g. `terraform apply --auto-approve`

#### Terraform Destroy

`teraform destroy` 

This will destroy resources.

You can also use the auto approve flag to skip the approve prompt e.g. `terraform apply --auto-approve`


#### Terraform Lock Files

[`.terraform.lock.hcl`](.terraform.lock.hcl) contains the locked versioning for the providers or modules that should be used with this project.

The Terraform Lock File should be committed to your Version Control System (VSC) e.g. Github

#### Terraform State Files

`.terraform.tfstate` contains information about the current state of your infrastructure.

This file **should not be commited** to your VCS.

This file can contain sensitive data.

If you lose this file, you lose knowing the state of your infrastructure.

`.terraform.tfstate.backup` is the previous state file state.

#### Terraform Directory

`.terraform` directory contains binaries of terraform providers.