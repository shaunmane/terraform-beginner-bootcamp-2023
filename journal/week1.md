# Terraform Beginner Bootcamp 2023 - Week 1 

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
$terraform -var user_uuid="my-user_id"
```

### Var-file flag

To set lots of variables, it is more convenient to specify their values in a variable definitions file (with a filename ending in either `.tfvars`or `.tfvars.json`) and then specify that file on the command line with `-var-file`:

```sh
$terraform apply -var-file="testing.tfvars"
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
$terraform import aws_s3_bucket.bucket bucket-name
```

[Terraform Import](https://developer.hashicorp.com/terraform/cli/import)
[AWS S3 Bucket Import](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket#import)

### Fix Manual Configuration

If someone goes and deletes or modifies cloud resources manually through Clickops.

By running Terraform plan, we attempt to put our infrastructure back into expected state fixing Configuration Drift