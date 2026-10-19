# Terraform Azure Lab — Roadmap
<sub>🛡️ © 2026 Tarun Bansal · Simple Tech With Tarun. All rights reserved, except where otherwise stated. See the <a href="https://github.com/simple-tech-with-tarun/simple-tech-with-tarun/blob/main/COPYRIGHT.md">Copyright & Intellectual Property Notice</a>.</sub>
## Purpose

Track the current state of the `terraform-azure-lab` repository and identify the next implementation steps.

This repository builds on the completed Terraform Fundamentals and Azure Networking learning projects. Its focus is reusable Terraform modules, integrated Azure deployments, advanced Terraform behaviour, dependency management, and state recovery.

## Current State

- [x] Standalone Terraform exercises
- [x] Reusable modules for core Azure resources
- [x] Multi-resource integrated environment
- [x] Storage Account network access testing
- [x] Investigate Terraform state recovery after Azure resources are deleted externally
- [x] Separate recovery and control resources to isolate dependency handling
- [x] Preserve existing Terraform resource addresses using `moved` blocks
- [x] Validate the recovery approach with a successful Terraform plan
- [ ] Apply the reviewed recovery plan to Azure
- [ ] Verify recreated resources and reconcile Terraform state
- [ ] Confirm a follow-up plan contains no unexpected changes

## Completed Investigation: Terraform State Recovery

### Problem

Azure auto-delete removed resource groups and their networking resources while Terraform state continued to reference their resource addresses.

During refresh and planning, the missing resource groups caused dependent data-source lookups and module configuration to fail. An empty `resource_group_names` output also resulted in invalid-index errors in dependent VNet and NSG configuration.

A broad module-level `depends_on` introduced another problem: Terraform deferred data-source reads for the entire association module, including lookups for healthy resources. This could cause unnecessary changes to resources that did not require recovery.

### Approach

The recovery configuration separates affected resources from healthy control resources:

- `module.association_recovery` handles associations belonging to the recovery target.
- `module.association_control` handles associations belonging to the healthy control environment.
- Dependencies are scoped to the recovery module rather than applied broadly to all association resources.
- `moved` blocks preserve existing Terraform resource addresses when resources move to the new module instances.
- The child association module remains unchanged.

### Validation Result

The final Terraform plan completed successfully:

```text
Plan: 7 to add, 0 to change, 0 to destroy.
```

The plan identified the recovery resources for creation while preserving the healthy control resources through Terraform address moves.

**Important:** The plan was reviewed but not applied. The recreation of Azure resources and post-apply Terraform state verification remain pending.

## Next Stage: Apply and Verify Recovery

### Intended Outcome

- Required resource groups and networking resources are recreated where necessary.
- Terraform state accurately reflects the actual Azure environment.
- Existing module keys and interfaces are preserved.
- The final plan contains no unexpected changes.
- Post-apply verification confirms that Azure resources and Terraform state are consistent.

### Working Procedure

1. Inspect the current branch, working tree, configuration, Terraform state, and actual Azure resources.
2. Confirm the active Azure subscription and deployment scope.
3. Back up the current Terraform state before any state operations.
4. Verify which resources exist in Azure and which resource addresses remain in state.
5. Review the recovery configuration and `moved` blocks.
6. Run `terraform fmt -check`, `terraform validate`, and `terraform plan` in the appropriate working directory.
7. Review the complete plan and confirm the target subscription before applying.
8. Apply only after the plan and target environment have been verified.
9. Verify the recreated Azure resources and resulting Terraform state.
10. Run a follow-up plan to confirm there are no unexpected changes.
11. Document the result and close the recovery task when the acceptance criteria are met.

### Safety Boundaries

- Do not delete, import, or manipulate state addresses without a current backup and a verified Azure resource inventory.
- Do not apply a saved plan without confirming that it is current and targets the intended subscription.
- Do not assume that a successful plan means resources have been recreated.
- Avoid unrelated module refactoring and Azure feature additions.
- Do not change the Azure auto-delete policy as part of this task.
- CI/CD implementation remains outside this repository's scope.

## Future Improvements

After completing and verifying state recovery, consider these improvements in priority order:

- [ ] Add sanitized example variable files for the integrated environment.
- [ ] Review tracked generated artifacts, including saved Terraform plan files.
- [ ] Document Azure authentication and environment configuration.
- [ ] Add advanced Terraform exercises where they provide clear learning value.
- [ ] Improve validation and reproducibility for existing modules and environments.

These are proposed follow-up tasks, not completed work.

## Related Repositories

- `Terraform Fundamentals` — Terraform language, expressions, functions, and core concepts.
- `Azure Networking` — Azure networking fundamentals and practical exercises.
- `Azure Landing Zone Lab` — enterprise architecture concepts within a single subscription.
- `Terraform CICD` — a separate workstream for CI/CD.

## Resume Point

**Start by verifying the current Azure environment and reviewing the recovery plan before applying anything.**

The investigation and planning stage is complete. The next milestone is to apply the reviewed changes safely, verify the recreated resources and Terraform state, and confirm that a subsequent plan contains no unexpected changes.

Do not assume the resources have already been recreated or that the Azure environment is clean; verify the current status before proceeding.

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