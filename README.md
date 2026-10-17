> ⚠️ **COPYRIGHT & USAGE NOTICE**
>
> © 2026 Tarun Bansal · Simple Tech With Tarun. All rights reserved, except where otherwise stated.
>
> This repository may contain original technical documentation, tutorials, source code, Terraform configurations, scripts, diagrams, and other materials created and published by Tarun Bansal under the GitHub identity **Simple Tech With Tarun**.
>
> Public availability does not automatically grant permission to reproduce, republish, redistribute, or commercially exploit original materials. Please review the [Copyright & Intellectual Property Notice](https://github.com/simple-tech-with-tarun/simple-tech-with-tarun/blob/main/COPYRIGHT.md) before reusing such materials.
>
> Any explicit repository-level or file-level license governs the materials it covers. Third-party content and contributions remain subject to their respective ownership rights, licenses, and applicable terms.
>
> ---

# Terraform Azure Lab

A hands-on collection of Terraform projects for provisioning, configuring, and managing Microsoft Azure infrastructure using Infrastructure as Code (IaC).

This repository builds on Terraform fundamentals and Azure networking to explore reusable modules, resource dependencies, multi-resource deployments, network security, compute, storage, and infrastructure lifecycle management through practical labs.

The focus is on understanding how Terraform configurations work together to manage real Azure resources—not simply creating individual resources in isolation.

## Repository Structure

```text
terraform-azure-lab/
├── terraform/
│   └── Standalone Terraform exercises
├── module-exercise/
│   ├── environments/
│   │   ├── dev/
│   │   └── storage_account/
│   └── modules/
│       ├── azurerm_resource_group/
│       ├── azurerm_virtual_network/
│       ├── azurerm_subnet/
│       ├── azurerm_network_security_group/
│       ├── azurerm_subnet_nsg_association/
│       ├── azurerm_virtual_network_peering/
│       ├── azurerm_linux_virtual_machine/
│       ├── azurerm_public_ip/
│       └── azurerm_storage_account/
└── integrated-environment/
    └── Multi-resource Azure environment
```

## What You'll Find Here

### 1. Terraform Exercises

The `terraform/` directory contains a standalone Azure configuration used to practise Terraform language features and resource relationships.

Topics include:

- Azure Resource Groups
- Virtual Networks and Subnets
- Storage Accounts
- Variables, locals, and outputs
- `for_each` and `for` expressions
- Map transformations and `merge()`
- Input validation and conditional expressions
- Resource dependencies
- Lifecycle configuration and ignored tag changes

### 2. Reusable Terraform Modules

The `module-exercise/` directory contains reusable modules and focused environment configurations.

The modules cover:

- Resource Groups
- Virtual Networks
- Subnets
- Network Security Groups
- Subnet-to-NSG associations
- Virtual Network Peering
- Linux Virtual Machines
- Public IP Addresses
- Storage Accounts

The goal is to understand module inputs and outputs, resource relationships, module composition, and how reusable components can support different deployment scenarios.

### 3. Integrated Azure Environment

The `integrated-environment/` directory combines reusable modules to deploy a broader Azure environment.

The configuration covers:

- Resource Groups across multiple regions
- Virtual Networks and Subnets
- Network Security Groups and subnet associations
- Virtual Network Peering
- Linux Virtual Machines
- Public IP resources
- Shared variables, locals, and tags
- Explicit and implicit resource dependencies
- Input validation and conditional configuration

The current lab configuration models networking across Central India and East US, with workload and management subnets.

Local `.auto.tfvars` files supply environment-specific values and are excluded from version control. Sanitized example configuration files can be added to help others reproduce the lab.

## Terraform and Azure Workflow

Terraform provides a declarative way to define Azure infrastructure.

```text
Terraform Configuration
        │
        ▼
    AzureRM Provider
        │
        ▼
   terraform init
        │
        ▼
  terraform validate
        │
        ▼
    terraform plan
        │
        ▼
   Review Changes
        │
        ▼
   terraform apply
        │
        ▼
 Azure Infrastructure
```

Always review the plan before applying changes. Use the appropriate working directory, backend, variables, and Azure authentication for each environment.

## Current Project Status

### Completed work

- Developed standalone Terraform exercises for Azure resources and Terraform language features.
- Built reusable modules for networking, compute, public IP addresses, resource groups, and storage.
- Composed reusable modules into a multi-resource environment.
- Tested Storage Account network access from an approved subnet.
- Verified Blob endpoint DNS resolution, connectivity, and login-based authentication during the Storage Account access test.

### Current focus

The remaining tracked recovery task concerns Terraform state and resources removed by Azure auto-delete.

The recovery work will focus on:

- Reconciling Terraform state with the actual Azure environment.
- Recreating the required resource groups and networking resources from the existing configuration.
- Preserving existing module interfaces and keys.
- Validating the result with a successful Terraform plan that contains no unexpected changes.

The recovery approach is still to be decided. A smaller, dedicated configuration may be preferable to using the full integrated environment for this exercise.

See [ROADMAP.md](ROADMAP.md) for the planned next steps.

## Safety and Configuration

Before running any lab:

- Confirm the active Azure subscription and deployment scope.
- Review resource names, locations, and expected costs.
- Inspect `terraform plan` before applying changes.
- Do not commit credentials, private keys, state files, or sensitive variable values.
- Keep environment-specific variable files out of version control unless they have been reviewed and sanitized.
- Treat saved Terraform plan files as potentially sensitive and environment-specific.
- Verify cleanup after temporary lab deployments.

Azure resources can incur charges. Destroy lab resources when they are no longer required, after verifying that doing so is safe.

## Related Learning Projects

This repository is part of a broader Terraform and Azure learning path.

- **Terraform Fundamentals** — core Terraform syntax, expressions, functions, variables, locals, and outputs.
- **Azure Networking** — foundational Azure networking concepts and services.
- **Azure Landing Zone Lab** — exploring enterprise-oriented Azure architecture within a single subscription.
- **Terraform CI/CD** — a separate repository for Terraform automation and pipeline development.

These projects have separate scopes; CI/CD implementation is not part of this repository.

## Goal

Build practical experience designing, composing, validating, troubleshooting, and recovering Azure infrastructure with Terraform, while keeping configurations reusable, understandable, and maintainable.