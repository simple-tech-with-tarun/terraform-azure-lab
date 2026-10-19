# Terraform Azure Lab
<sub>🛡️ © 2026 Tarun Bansal · Simple Tech With Tarun. All rights reserved, except where otherwise stated. See the <a href="https://github.com/simple-tech-with-tarun/simple-tech-with-tarun/blob/main/COPYRIGHT.md">Copyright & Intellectual Property Notice</a>.</sub>

A hands-on collection of Terraform projects for provisioning, configuring, and managing Microsoft Azure infrastructure using Infrastructure as Code (IaC).

This repository builds on Terraform fundamentals and Azure networking to explore reusable modules, integrated deployments, resource dependencies, network security, compute, storage, infrastructure lifecycle management, and Terraform state recovery.

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
├── integrated-environment/
│   └── Multi-resource Azure environment
├── state-recovery-demo/
│   └── Terraform state-recovery experiments
└── state-recovery-demo_2/
    └── Recovery dependency-handling investigation
```

## What You'll Find Here

### 1. Terraform Exercises

The `terraform/` directory contains standalone Azure configurations for practising Terraform language features and resource relationships.

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

The goal is to understand module inputs and outputs, resource relationships, module composition, and how reusable components support different deployment scenarios.

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

The lab models networking across Central India and East US, with workload and management subnets.

Local `.auto.tfvars` files supply environment-specific values and should remain excluded from version control unless reviewed and sanitized.

### 4. Terraform State Recovery

The `state-recovery-demo/` and `state-recovery-demo_2/` directories contain experiments investigating Terraform behaviour when Azure resources are deleted outside Terraform while their addresses remain in state.

The investigation explores:

- Missing resource groups and dependent data-source lookups
- Invalid-index errors caused by missing resource information
- How broad module-level `depends_on` can defer data-source evaluation
- Avoiding unnecessary changes to healthy resources during recovery
- Separating recovery resources from control resources
- Using `moved` blocks to preserve Terraform resource addresses
- Validating recovery configurations with Terraform plans

#### Investigation Result

The recovery configuration was separated into recovery and control module instances, and `moved` blocks were introduced to preserve existing resource addresses.

The final plan completed successfully:

```text
Plan: 7 to add, 0 to change, 0 to destroy.
```

The plan identified the recovery resources for creation while preserving the healthy control resources.

**Recovery status:** The plan has not been applied. The recreation of Azure resources and post-apply Terraform state verification remain pending.

See [ROADMAP.md](ROADMAP.md) for the recovery plan, safety boundaries, and next steps.

## Terraform and Azure Workflow

Terraform provides a declarative way to define Azure infrastructure.

```text
Terraform Configuration
        |
        v
    AzureRM Provider
        |
        v
    terraform init
        |
        v
  terraform validate
        |
        v
    terraform plan
        |
        v
    Review Changes
        |
        v
   terraform apply
        |
        v
  Azure Infrastructure
```

Always review the plan before applying changes. Use the appropriate working directory, backend, variables, and Azure authentication for each environment.

## Current Project Status

### Completed Work

- Developed standalone Terraform exercises for Azure resources and Terraform language features.
- Built reusable modules for networking, compute, public IP addresses, resource groups, and storage.
- Composed reusable modules into a multi-resource environment.
- Tested Storage Account network access from an approved subnet.
- Verified Blob endpoint DNS resolution, connectivity, and login-based authentication during the Storage Account access test.
- Investigated Terraform state recovery after externally deleted Azure resources.
- Separated recovery and control module instances to limit dependency-related side effects.
- Added `moved` blocks to preserve existing Terraform resource addresses.
- Validated the recovery approach with a successful Terraform plan.

### Current Focus

The next step is to apply and verify the reviewed state-recovery configuration.

The remaining work includes:

- Confirming the current Azure resource inventory and active subscription.
- Reviewing the current Terraform state and backing it up before state operations.
- Rechecking the recovery configuration and plan.
- Applying the reviewed changes only after confirming the intended target environment.
- Verifying the recreated resource groups and networking resources.
- Confirming that Terraform state matches the actual Azure environment.
- Running a follow-up plan to check for unexpected changes.

A successful plan is not proof that resources have been recreated. Azure recovery remains incomplete until the changes have been applied and verified.

See [ROADMAP.md](ROADMAP.md) for the detailed procedure and acceptance criteria.

## Safety and Configuration

Before running any lab:

- Confirm the active Azure subscription and deployment scope.
- Review resource names, locations, and expected costs.
- Inspect `terraform plan` before applying changes.
- Do not commit credentials, private keys, state files, or sensitive variable values.
- Keep environment-specific variable files out of version control unless reviewed and sanitized.
- Treat saved Terraform plan files as potentially sensitive and environment-specific.
- Back up Terraform state before performing recovery or state-management operations.
- Verify cleanup after temporary lab deployments.

Azure resources can incur charges. Destroy lab resources when they are no longer required, after verifying that doing so is safe.

## Related Learning Projects

This repository is part of a broader Terraform and Azure learning path.

- **Terraform Fundamentals** — core Terraform syntax, expressions, functions, variables, locals, and outputs.
- **Azure Networking** — foundational Azure networking concepts and services.
- **Azure Landing Zone Lab** — enterprise-oriented Azure architecture within a single subscription.
- **Terraform CICD** — a separate repository for Terraform automation and pipeline development.

These projects have separate scopes. CI/CD implementation is not part of this repository.

## Goal

Build practical experience designing, composing, validating, troubleshooting, and recovering Azure infrastructure with Terraform while keeping configurations reusable, understandable, and maintainable.

---

> **🛡️ Copyright & Intellectual Property**
>
> © 2026 Tarun Bansal · Simple Tech With Tarun. All rights reserved, except where otherwise stated.
>
> This repository may contain original technical documentation, tutorials, source code, Terraform configurations, scripts, diagrams, and other materials created and published by Tarun Bansal under the GitHub identity **Simple Tech With Tarun**.
>
> Public availability does not automatically grant permission to reproduce, republish, redistribute, or commercially exploit original materials. Please review the [Copyright & Intellectual Property Notice](https://github.com/simple-tech-with-tarun/simple-tech-with-tarun/blob/main/COPYRIGHT.md) before reusing such materials.
>
> Any explicit repository-level or file-level license governs the materials it covers. Third-party content and contributions remain subject to their respective ownership rights, licenses, and applicable terms.