# Terraform

- [Terraform](#terraform)
  - [Configuration](#configuration)
  - [Define Resource](#define-resource)
  - [Apply configuration](#apply-configuration)
  - [Validate syntax](#validate-syntax)
  - [Formatting](#formatting)
  - [State management](#state-management)
  - [Variables](#variables)
    - [Input variables](#input-variables)
    - [Output variables](#output-variables)
  - [Workspaces](#workspaces)
  - [Tips and Tricks](#tips-and-tricks)
    - [Regions](#regions)
    - [Zones](#zones)
    - [Projects](#projects)
    - [Machine types](#machine-types)
  - [Best Practices](#best-practices)
    - [Code](#code)
    - [Configure terraform](#configure-terraform)
  - [References](#references)

## Configuration

* Define providers connections in connections.tf
* Run to download plugins and dependencies:
```
terraform init
```
* Plugins are stored in: .terraform/plugins folder

## Define Resource

* Define resources, for example
```
resource "google_compute_network" "development_network" {
  name = "development network"
  auto_create_subnetworks = true
}
```
* Check if you resource specification exists, and determine a diff
```
terraform plan

# output
Plan: 1 to add, 0 to change, 0 to destroy.
```

## Apply configuration

```
terraform apply
```

## Validate syntax
Validate the syntax of the terraform files
```
terraform validate
```

## Formatting
Format Terraform files according to Terraform style conventions
```
terraform fmt
```

## State management
There are certain advanced scenarios, when you need to control terraform state.
```
terraform state show <resource>
```

refresh state:
```
terraform state refresh
```

mark resource tainted, and allow to recreate resource
```
terraform taint <resource>
```

## Variables

Typically variables defined in: variables.tf file.

There are multiple variables types:
* Input
* Output
* Local
* Data (kind of variables, should be more considered as data source)

### Input variables

Example:
```
variable "availability_zone_names" {
  type    = list(string)
  default = ["us-west-1a"]
}
```

Type restrictions allows to define type as
* string
* number
* bool

There are also complex type constructors:
* list(<TYPE>)
* set(<TYPE>)
* map(<TYPE>)
* object({<ATTR NAME> = <TYPE>, ... })
* tuple([<TYPE>, ...])

Variables is loaded in following order:
* Environment variables
* The terraform.tfvars file, if present.
* The terraform.tfvars.json file, if present.
* Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
* Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Enterprise workspace.)


### Output variables

Allows to return value, for example
```
output "instance_ip_addr" {
  value       = aws_instance.server.private_ip
  description = "The private IP address of the main server instance."
}
```

## Workspaces

Each backend stores information information in terraform state (not every backend supports workspaces). Workspaces allows to have multiple states associated with configuration.

it will allow to track dev/stage/integration and other environments differently:
```
terraform workspace
```

Currently supported by: AzureRM, Consul, GCS, Local, Manta, Postgres, Remote, S3

Terraform workspace is available as variable, for example:
```
${terraform.workspace == "default" ? 1 : 2}"
```


## Tips and Tricks

### Regions
Check regions
```
# list regions
gcloud compute regions list

# check regions
gcloud compute regions describe us-west1
```

### Zones
Check zones
```
# list zones
gcloud compute zones list

# filter zones by region
gcloud compute zones list --filter=region:us-west1

# describe zone
gcloud compute zones describe us-west1-a
```

### Projects

```
# list projects
gcloud projects list
```

### Machine types
```
# filter machine types by zone
gcloud compute machine-types list --filter=zone:us-west1-a --format="table[box,title=Machine-Types](NAME, CPUS:sort=1, MEMORY_GB:sort=2, DESCRIPTION)"

# list images
gcloud compute images list
gcloud compute images list --no-standard-images
gcloud compute images list --format="table[box,title=IMAGES](NAME, PROJECT:sort=1, diskSizeGb)"

gcloud compute images describe cos-cloud/cos-69-10895-242-0
```

## Best Practices

### Code

It is recommended to use [pre-commit](https://pre-commit.com/) for pre-commit hooks, and configure following hooks:
```
- repo: git://github.com/antonbabenko/pre-commit-terraform
  rev: v1.11.0
  hooks:
    - id: terraform_validate_with_variables
    - id: terraform_fmt
    - id: terraform_docs
```
Note: on Windows works only from bash terminal

### Configure terraform

Configure terraform backend to store terraform state, for example:

```
terraform {
  backend "consul" {
    address = "demo.consul.io"
    scheme  = "https"
    path    = "example_app/terraform_state"
  }
}
```

There are many backends supported: artifactory, azurerm, consul, etcd, etcdv3, gcs, http, manta, pg, s3, swift, terraform enterprise

## References

* [Terraform CLI Reference](https://www.terraform.io/docs/commands/cli-config.html)
* [Hashicorp Best Practices](https://github.com/hashicorp/best-practices)
* [GCP Provider](https://www.terraform.io/docs/providers/google/index.html)
