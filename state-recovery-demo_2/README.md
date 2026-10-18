# Terraform State Recovery: Dependency and Data Source Evaluation

## Overview

This lab investigates Terraform behavior when an Azure resource group is deleted outside Terraform while Terraform state continues to track the resource group and its dependent resources.

The experiment focuses on module dependencies, data-source evaluation, state reconciliation, and preventing unnecessary changes to unaffected infrastructure.

## Objectives

- Understand the difference between Terraform state and actual Azure infrastructure.
- Observe how Terraform handles externally deleted resources.
- Investigate how module-level `depends_on` affects data-source evaluation.
- Understand why unaffected resources can be included in replacement plans.
- Evaluate direct resource-name inputs as an alternative to module-output references.
- Explore `moved` blocks when reorganizing module instances.

## Lab Scenario

Two resource groups were used:

| Resource group | Purpose |
|---|---|
| `tf-mod-recovery-rg1` | Recovery target; manually deleted in Azure |
| `tf-mod-recovery-rg2` | Control environment; expected to remain unchanged |

Each environment contained a virtual network, subnets, a network security group, and subnet-to-NSG associations.

The baseline infrastructure was created successfully, and a subsequent Terraform plan reported no changes.

A baseline state snapshot was saved before the deletion:

```powershell
terraform state pull > .\baseline-state.json
```

The RG1 resource group was then deleted manually through the Azure Portal, leaving Terraform state with references to resources that no longer existed in Azure.

## Investigation

### 1. Broad module-level dependency

The association module originally depended on both the subnet and network security group modules:

```hcl
depends_on = [
  module.azurerm_subnet,
  module.azurern_network_security_group
]
```

This dependency helped Terraform order association operations after the dependent infrastructure.

However, it also affected data sources inside the association module. Terraform deferred data-source reads until apply when their dependencies had pending changes.

As a result, data-source lookups for RG2 could also be deferred even though RG2's infrastructure still existed.

The plan consequently lacked some association IDs during planning and proposed unnecessary replacement of the RG2 associations.

### 2. Removing the broad dependency

Removing the module-level `depends_on` allowed Terraform to evaluate data sources during planning.

The RG2 lookups succeeded, but the RG1 lookups failed because the subnet and network security group had been deleted along with RG1.

This demonstrated the opposite problem: the recovery-target data sources needed to wait until the missing infrastructure was recreated.

### 3. Direct resource-name inputs

The association module accepts names directly:

```hcl
variable "association" {
  type = map(object({
    subnet_name                 = string
    network_security_group_name = string
    virtual_network_name        = string
    resource_group_name         = string
  }))
}
```

This design avoids unnecessary references to resource-group and virtual-network module outputs.

**Finding:** Direct names reduce module-output coupling, but they do not, by themselves, solve the data-source evaluation timing problem caused by a broad `depends_on`.

### 4. Splitting recovery and control associations

The association configuration was split into two module instances:

- `module.association_recovery` manages associations for RG1 and retains the dependency needed to defer lookups until recovery resources are available.
- `module.association_control` manages associations for RG2 without the same explicit module-level dependency, allowing its data sources to be evaluated during planning.

This separates the recovery dependency graph from the unaffected control environment.

### 5. Preserving resource addresses with `moved` blocks

Splitting a module changes Terraform resource addresses. Without state migration, existing resources can appear to be removed from the old addresses and created at the new ones.

Declarative `moved` blocks were added to map the original association addresses to the new module instances.

This allowed Terraform to recognize the existing associations under their new addresses rather than treating the refactoring as resource replacement.

## Successful Plan Result

The final diagnostic plan completed successfully with:

```text
Plan: 7 to add, 0 to change, 0 to destroy.
```

The seven planned additions corresponded to rebuilding the missing RG1 environment and its dependent resources, including its subnet-to-NSG associations.

The existing RG2 associations were recognized at their moved addresses and were not unnecessarily destroyed and recreated.

**Important:** This result confirms the behavior of the plan, not the successful recreation of the infrastructure. The plan was not applied as part of this investigation.

## Key Lessons

1. Terraform state records Terraform's understanding of resource identity; it does not guarantee that the corresponding infrastructure still exists.
2. Deleting a resource outside Terraform can leave stale state entries and cause dependent data-source lookups to fail.
3. Module-level `depends_on` can affect data sources inside a module, not just the resource operations that motivated the dependency.
4. Deferred data-source evaluation can reduce the information Terraform has available during planning.
5. Direct input names reduce unnecessary coupling to other modules' outputs but do not eliminate dependency-ordering concerns.
6. Separating recovery resources from unaffected resources can make dependency behavior more precise.
7. `moved` blocks preserve resource identity when module structures and resource addresses change.
8. Always inspect the full plan before applying recovery changes, especially when the plan includes resources that were not intentionally modified.

## Final Status

- [x] Baseline infrastructure created and checked.
- [x] Baseline state snapshot saved.
- [x] External deletion scenario reproduced.
- [x] Effects of module-level `depends_on` investigated.
- [x] Direct-name input approach evaluated.
- [x] Recovery and control associations separated.
- [x] Resource address migration validated using `moved` blocks.
- [x] Final plan verified with no unnecessary destroys.
- [ ] Infrastructure recovery applied (not required to complete the planning investigation).
- [ ] README committed and pushed.
- [ ] GitHub issue closed.
- [ ] Working branch merged or otherwise closed out.

## Conclusion

The investigation demonstrated that reliable recovery planning requires more than simply recreating missing resources. Terraform's dependency graph determines when data sources can be evaluated, and those timing decisions can affect unrelated resources in the same module.

Separating recovery dependencies from unaffected resources, while preserving resource identity with `moved` blocks, produced a plan that targeted the missing environment without unnecessary destruction of the control environment.

This lab is complete as a planning and dependency-graph investigation. Applying the recovery plan is a separate operational decision.