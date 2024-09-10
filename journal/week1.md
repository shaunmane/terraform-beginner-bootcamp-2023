# Terraform Beginner Bootcamp 2023 - Week 1 

## Fixing Tags

[How to Delete local and remote tags on Git](https://devconnected.com/how-to-delete-local-and-remote-tags-on-git/)

Locally delete a tag

```sh
$ git tag -d <tag_name>
```

Remotely delete a tag

```sh
$ git push --delete origin tagname
```

Checkout the commit that you want to retag by grabbing the `sha` from your Github history.

```sh
$ git checkout <SHA>
$ git tag M.M.P
$ git push --tags
$ git checkout main
```

## Root Module Structure 

Our root module structure is as follows:

```
PROJECT_ROOT
│
├── main.tf                 # everything else.
├── variables.tf            # stores the structure of input variables
├── terraform.tfvars        # the data of variables we want to load into our terraform project
├── providers.tf            # defined required providers and their configuration
├── outputs.tf              # stores our outputs
└── README.md               # required for root modules
```

[Standard Module Structure](https://developer.hashicorp.com/terraform/language/modules/develop/structure)

## Terraform and Input Variables

[Terraform Input Variables](https://developer.hashicorp.com/terraform/language/values/variables)

### Terraform Cloud Variables

In terraform we can set two kinds of variables:
- `Environment Variables` - those you would set in your bash terminal eg. AWS credentials
- `Terraform Variables` - those that you would set in your tfvars file

We can set Terraform Cloud variables to be sensitive so that they are not shown visibly in the UI.

### Loading Terraform Input Variables

### Var flag

We can use the `-var` flag to set an input variable on the command line or override a variable in the tfvars: 

```sh
$ terraform -var user_uuid="my-user_id"
```

### Var-file flag

To set lots of variables, it is more convenient to specify their values in a variable definitions file (with a filename ending in either `.tfvars`or `.tfvars.json`) and then specify that file on the command line with `-var-file`:

```sh
$ terraform apply -var-file="testing.tfvars"
```

### terraform.tfvars

This is the default file used to load terraform variables in bulk.

### auto.tfvars

A specific filename convention used to automatically load variable values without explicitly specifying the `-var-file` flag when running terraform apply or terraform plan.

### Order of Terraform Variables

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:
- Environment variables
- The `terraform.tfvars` file, if present.
- The `terraform.tfvars.json` file, if present.
- Any `*.auto.tfvars` or `*.auto.tfvars.json` files, processed in lexical order of their filenames.
- Any `-var` and `-var-file` options on the command line, in the order they are provided. (This includes variables set by an HCP Terraform workspace.)

## Dealing with Configuration Drift

## What happens if we lose our state file?

If you lose your statefile, you most likely have to tear down all your cloud infrastructure manually.

You can use terraform import but it won't work for all cloud resources. You need check the terraform providers documentation for which resources support import.

### Fix Missing Resources with Terraform Import

`Terraform import` is a command that allows you to import existing resources into your terraform configuration. This command will create a new state file with the existing resources.


```sh
$ terraform import aws_s3_bucket.bucket bucket-name
```

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and deletes or modifies cloud resources manually through Clickops.

By running Terraform plan, we attempt to put our infrastructure back into expected state fixing Configuration Drift

### Fix Using Terraform Refresh

```sh
$ terraform apply -refresh-only -auto-approve
```

## Terraform Modules

### Terraform Module Structure

It is recommended to place modes in a `modules` directory when locally developing modules but you can name it whatever you like.

### Passing Input Variables

We can pass input variables to our module.

The module has to declare the terraform variables in its own variables.tf

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
  user_uuid = var.user_uuid
  bucket_name = var.bucket_name
}
```

### Module Sources

Using the source, we can import the module from various places e.g. 
- Locally
- Github
- Terraform Registry

```tf
module "terrahouse_aws" {
  source = "./modules/terrahouse_aws"
}
```

[Module Sources](https://developer.hashicorp.com/terraform/language/modules/sources) 

## Considerations when using ChatGPT to write Terraform 

LLMs such as ChatGPT may not be trained on the latest documentation of information about Terraform. 

It may likely produce older examples that could be deprecated. Often affecting providers.

[S3 Bucket Upload deprecated](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/s3_bucket_object)

## Working with files in Terraform

### Fileexists function

This is a built in Terraform function to check the existance of a file.

```tf 
condition = fileexists(var.index_html_filepath)
```

[Fileexists](https://developer.hashicorp.com/terraform/language/functions/fileexists)

### Filemd5

The filemd5 function in Terraform calculates the MD5 hash of a file’s contents. This can be useful for various purposes, such as detecting changes to a file or ensuring that a file's content has not been altered.

```tf
resource "local_file" "index_html" {
  content  = file(var.index_html_filepath)
  filename = "index.html"
  
  # Use filemd5 to detect changes
  md5      = filemd5(var.index_html_filepath)
}
```

[Filemd5](https://developer.hashicorp.com/terraform/language/functions/filemd5)

### Path Variable

In Terraform, there is a special variable called `path` that allows us to reference local paths:
- path.module = get the path for the current module
- path.root = get the path for the root module

[Special Path Variable](https://developer.hashicorp.com/terraform/language/expressions/references#filesystem-and-workspace-info)

```tf
resource "aws_s3_object" "website_index" {
  bucket = aws_s3_bucket.website_bucket.bucket
  key    = "index.html"
  source = "${path.root}/public/index.html"
}
```

## Terraform Locals

Locals allow us to define local variables. It can be very useful for transforming data into another format and have it referenced as a variable.

```tf
locals {
  s3_origin_id = "myS3Origin"
}
```
[Local Values](https://developer.hashicorp.com/terraform/language/values/locals)

## Terraform Data Sources

This allows us to use source data from cloud resources.

This is useful for referencing cloud resources without importing them.

```tf 
data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}
```

[Terraform Data Sources](https://developer.hashicorp.com/terraform/language/data-sources)

## Working with JSON

We use the jsonencode to create the json policy inline in the hcl.

```tf
> jsonencode({"hello"="world"})
{"hello":"world"}
```

[jsonencode](https://developer.hashicorp.com/terraform/language/functions/jsonencode)

## Changing the Lifecycle of Resources

[Meta Arguments Lifecycle](https://developer.hashicorp.com/terraform/language/meta-arguments/lifecycle)

### Terraform Data 

Plain data values such as Local Values and Input Variables don't have any side-effects to plan against and so they aren't valid in `replace_triggered_by`. You can use `terraform_data`'s behavior of planning an action each time `input` changes to indirectly use a plain value to trigger replacement.

[Terraform_Data](https://developer.hashicorp.com/terraform/language/resources/terraform-data)

## Provisioners

Provisioners allow you to execute commands on compute instances for actions e.g. a AWS CLI command. 

They are not recommended for use by Hashicorp because Configuration Management tools such as Ansible are a better fit, but the functionality exists.

[Terraform Provisioners](https://developer.hashicorp.com/terraform/language/resources/provisioners/syntax)

### Local-exec

This will execute a command on the machine running the terraform command e.g. plan apply

```tf
resource "aws_instance" "web" {
  # ...

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ips.txt"
  }
}
```

[Local Execute](https://developer.hashicorp.com/terraform/language/resources/provisioners/local-exec)

### Remote-exec

This will execute commands on a machine which you target. You will need to provide credentials such as `SSH` to get into the machine.

```tf
resource "aws_instance" "web" {
  # ...

  # Establishes connection to be used by all
  # generic remote provisioners (i.e. file/remote-exec)
  connection {
    type     = "ssh"
    user     = "root"
    password = var.root_password
    host     = self.public_ip
  }

  provisioner "remote-exec" {
    inline = [
      "puppet apply",
      "consul join ${aws_instance.web.private_ip}",
    ]
  }
}
```

[Remote Execute](https://developer.hashicorp.com/terraform/language/resources/provisioners/remote-exec)

### Heredoc Strings

A heredoc (here document) string is a way of defining multi-line string literals in programming languages and configuration files. It's particularly useful when you need to include large blocks of text, such as configuration files, SQL queries, or JSON data, without having to escape newlines or quotation marks.

In Terraform, heredoc strings are represented using the `<<EOF` syntax (or similar delimiters). This syntax allows you to write a block of text without needing to escape special characters, and it automatically preserves newlines.

```tf
<<COMMAND
aws cloudfront create-invalidation \
--distribution-id ${aws_cloudfront_distribution.s3_distribution.id} \
--paths '/*'
    COMMAND
```

[Heredocs](https://developer.hashicorp.com/terraform/language/expressions/strings#heredoc-strings)

## For Each Expressions

For each allows us to enumerate over complex data types.

```sh
[for s in var.list : upper(s)]
```

This is mostly useful when you are creating multiples of a cloud resource and you want to reduce the amount of repetitive Terraform code.

```tf
resource "aws_iam_user" "the-accounts" {
  for_each = toset(["Todd", "James", "Alice", "Dottie"])
  name     = each.key
}
```

[For Each Expressions](https://developer.hashicorp.com/terraform/language/meta-arguments/for_each)

### Fileset Function 

This is used for enumerating a set of regular file names given a path and pattern. The path is automatically removed from the resulting set of file names and any result still containing path separators always returns forward slash (`/`) as the path separator for cross-system compatibility.

Takes two arguments - `fileset(path, pattern)`

```tf
resource "example_thing" "example" {
  for_each = fileset(path.module, "files/*")

  # other configuration using each.value
}
```

[fileset Function](https://developer.hashicorp.com/terraform/language/functions/fileset)