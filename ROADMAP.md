# Terraform Azure Lab — Roadmap

## Purpose

Track the current state of the `terraform-azure-lab` repository and identify the next implementation steps.

The repository builds on the completed Terraform Fundamentals and Azure Networking learning projects. The focus here is on reusable modules, integrated deployments, advanced Terraform behaviour, and state recovery.

## Current State

- [x] Standalone Terraform exercises
- [x] Reusable modules for core Azure resources
- [x] Multi-resource integrated environment
- [x] Storage Account network access test
- [ ] Recover from Azure auto-delete and reconcile Terraform state
- [ ] Verify the recovery with a clean, reviewed Terraform plan

## Next Stage: Terraform State Recovery

### Problem

Azure auto-delete removed resource groups and their networking resources, while Terraform state continued to reference the resource addresses.

During refresh, the resource group's `resource_group_names` output became empty. This caused invalid-index errors in dependent VNet and NSG module configuration.

### Intended outcome

- Terraform state accurately reflects the Azure resources that exist.
- Required resource groups and networking resources can be recreated using the existing configuration.
- Existing module keys and interfaces are preserved.
- Terraform validation and planning complete successfully.
- The final plan contains no unexpected changes.

### Approach to decide

Evaluate whether to use:

1. A small, dedicated recovery configuration with a limited number of resources.
2. The existing `integrated-environment` configuration.

Prefer the smallest safe setup that demonstrates the recovery problem clearly without introducing unrelated changes.

### Scope boundaries

- No unrelated module refactoring.
- No new Azure features.
- No changes to the auto-delete policy.
- No CI/CD implementation in this repository.

### Working procedure

1. Inspect the current branch, configuration, state, and actual Azure resources.
2. Create a dedicated feature branch.
3. Back up the existing state before any state operations.
4. Determine which resources exist in Azure and which addresses remain in state.
5. Choose the appropriate state reconciliation or recreation strategy.
6. Make the smallest necessary configuration changes.
7. Run formatting, validation, and planning checks.
8. Apply changes only after reviewing the plan and confirming the target subscription.
9. Verify the resulting resources and Terraform state.
10. Document the outcome and close the recovery task when acceptance criteria are met.

**Safety note:** Do not delete, import, or manipulate state addresses until the current state has been backed up and the real Azure resource inventory has been checked.

## Future Improvements

After completing state recovery, consider these improvements in order of priority:

- [ ] Add sanitized example variable files for the integrated environment.
- [ ] Review tracked generated artifacts, including saved Terraform plan files.
- [ ] Document how to configure Azure authentication and each environment.
- [ ] Add more advanced Terraform exercises where they add learning value.
- [ ] Improve validation and reproducibility for the existing modules and environments.

These are proposed follow-up tasks, not completed work.

## Related Repositories

- `Terraform Fundamentals` — Terraform language, expressions, and functions.
- `Azure Networking` — Azure networking fundamentals and practical exercises.
- `Azure Landing Zone Lab` — enterprise architecture concepts within a single subscription.
- `Terraform CICD` — separate workstream for CI/CD.

## Resume Point

Start with **Terraform State Recovery**. First establish the current Azure and Terraform state, then decide whether a small dedicated setup is safer and clearer than using the integrated environment.

Do not assume the resources have already been recreated or that the Azure environment is clean; verify the current status before proceeding.