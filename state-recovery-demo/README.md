# Terraform State Recovery Demo

## Overview

This demo investigates how Terraform handles Azure infrastructure resources that are deleted outside Terraform while their resource instances remain recorded in Terraform state.

The lab uses **standalone Terraform resource blocks**, rather than modules, to establish a baseline for resource recovery behavior before investigating the same problem in a modular configuration.

## Objectives

- Understand how Terraform detects externally deleted Azure resources during refresh.
- Observe the proposed recovery plan when an individual resource is deleted.
- Observe the proposed recovery plan when an entire resource group is deleted.
- Examine how Terraform state, configuration, dependencies, and outputs behave during recovery.
- Establish a baseline for comparison with the modular Terraform configuration in the parent issue.

## Lab Architecture

The demo manages 30 Terraform resource instances across two Azure resource groups.

| Resource type | Count |
|---|---:|
| Azure resource groups | 2 |
| Virtual networks | 4 |
| Subnets | 8 |
| Network security groups | 4 |
| Network security rules | 8 |
| Subnet–NSG associations | 4 |
| **Total** | **30** |

The resources are distributed across two resource groups:

- `tf-state-recovery-rg1`: two VNets, four subnets, two NSGs, four security rules, and two subnet–NSG associations.
- `tf-state-recovery-rg2`: two VNets, four subnets, two NSGs, four security rules, and two subnet–NSG associations.

The lab is deployed in the `centralindia` Azure region.

## Prerequisites

- Terraform CLI
- Azure CLI
- An Azure subscription with permissions to manage the lab resources
- An authenticated Azure CLI session
- Git, if working with the repository

Authenticate with Azure:

```powershell
az login
az account show
```

Verify that the active subscription is the intended lab subscription before running Terraform commands.

## Initialize the Lab

From the `state-recovery-demo` directory:

```powershell
terraform init
terraform validate
terraform plan
```

Review the configuration and plan before creating any resources.

If the baseline infrastructure has not yet been deployed, create it using the reviewed plan:

```powershell
terraform apply
```

Confirm the infrastructure and state inventory before proceeding with either deletion scenario.

## Scenario 1 — Individual NSG Deleted Outside Terraform

### Objective

Investigate how Terraform recovers when one Azure Network Security Group is deleted outside Terraform while its Terraform state entry and related configuration remain.

### Procedure

1. Back up the Terraform state.
2. Verify the active Azure subscription.
3. Delete `tf-state-recovery-nsg1` directly in Azure, leaving its resource group intact.
4. Run:

   ```powershell
   terraform plan -out="plan"
   terraform show plan > plan.txt
   ```

5. Review the proposed changes.
6. Apply the reviewed saved plan.
7. Run `terraform plan` again to verify the resulting configuration.

### Observed Result

Terraform proposed recreating four resource instances:

- NSG `nsg1`
- Its inbound security rule
- Its outbound HTTPS security rule
- Its subnet–NSG association

The reviewed plan proposed four additions, with no changes or destructions.

The plan was applied successfully, and a subsequent Terraform plan reported that no changes were required.

### Finding

In this scenario, Terraform detected the missing NSG and related resource instances and successfully restored the intended infrastructure from the configuration.

## Scenario 2 — Entire Resource Group Deleted Outside Terraform

### Objective

Investigate how Terraform behaves when an entire resource group and its dependent Azure resources are deleted externally while their resource addresses remain in Terraform state.

### Procedure

1. Back up the Terraform state before making changes.
2. Verify the active Azure subscription.
3. Delete `tf-state-recovery-rg1` directly in Azure.
4. Leave `tf-state-recovery-rg2` untouched as the control resource group.
5. Run:

   ```powershell
   terraform plan -out="plan2"
   terraform show .\plan2 > .\plan2.txt
   ```

6. Inspect the plan and the Terraform state inventory.
7. Do not apply the plan until the experiment's next steps have been reviewed.

### Observed Result

Terraform successfully generated a plan proposing:

```text
Plan: 15 to add, 0 to change, 0 to destroy.
```

The proposed additions were:

| Resource type | Count |
|---|---:|
| Resource group | 1 |
| Virtual networks | 2 |
| Subnets | 4 |
| Network security groups | 2 |
| Network security rules | 4 |
| Subnet–NSG associations | 2 |
| **Total** | **15** |

Terraform also proposed updating outputs whose resource IDs would become known after the resources were recreated.

A subsequent `terraform state list` still showed all 30 resource instances, including the resources associated with the deleted resource group.

### Finding

Terraform successfully generated a recovery plan for the entire deleted resource group and its dependent resources.

The state inventory retained the resource addresses even though the corresponding Azure resources had been deleted externally. The saved plan proposed recreating the missing resources without proposing changes to or destruction of the resources in the control resource group.

**Important:** The Scenario 2 recovery plan was generated and inspected but was not applied as part of this experiment.

## Key Findings

1. Terraform state can continue to contain resource addresses after the corresponding Azure resources are deleted outside Terraform.
2. During planning, Terraform refreshes its view of the infrastructure and can propose recreating missing resources when the configuration remains evaluable.
3. In the individual NSG deletion scenario, the recovery plan was applied successfully and a subsequent plan was clean.
4. In the whole resource group deletion scenario, Terraform successfully generated a plan to recreate the missing resource group and its dependent resources.
5. The standalone configuration provides a baseline for investigating recovery behavior independently of module-output evaluation problems.

## Relationship to the Parent Issue

This demo is a sub-issue of the broader Terraform Azure state-recovery investigation.

The parent issue concerns an existing **modular Terraform networking configuration**. Following external deletion of Azure resources, the resource-group module can return an empty `resource_group_names` output during refresh. Downstream modules may then encounter invalid-index errors when evaluating their inputs.

That situation differs from this standalone demo, where resource arguments are defined directly in resource blocks and Terraform successfully generated a recovery plan.

The next investigation will reproduce the whole-resource-group deletion scenario using the existing modular configuration and determine how to recover while preserving the current module interfaces and structure.

## Safety and Cleanup

- Always verify the active Azure subscription before deleting resources.
- Back up Terraform state before recovery experiments.
- Review saved plans before applying them.
- Do not apply a recovery plan until its proposed changes are understood.
- Keep state backups and binary plan files out of source control unless they have been reviewed and intentionally approved for inclusion.
- Clean up lab resources only after confirming that they are no longer required for the investigation.

## Current Status

- [x] Baseline standalone configuration established
- [x] Scenario 1: individual NSG deletion investigated
- [x] Scenario 1: recovery applied and clean plan verified
- [x] Scenario 2: whole resource group deletion investigated
- [x] Scenario 2: recovery plan generated and inspected
- [ ] Document and review the experimental findings
- [ ] Investigate the equivalent failure in the modular parent configuration