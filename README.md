# Terraform Azure Lab

A hands-on collection of Terraform examples for provisioning, configuring, and managing Azure infrastructure using Infrastructure as Code.

This repository focuses on applying Terraform concepts to practical Azure scenarios, with an emphasis on reusable configurations, dependency management, networking, identity, security, and infrastructure lifecycle management.

## 📚 What You'll Find Here

- Terraform with Azure
- AzureRM provider
- Resource groups
- Virtual networks
- Subnets
- Network security groups
- Virtual machines
- Storage accounts
- Azure networking
- Managed identities
- Private endpoints
- Azure Key Vault
- Monitoring resources
- Resource dependencies
- Variables and outputs
- Terraform state
- Reusable configurations
- Infrastructure lifecycle management

## ☁️ Terraform + Azure

Terraform provides a declarative way to define Azure infrastructure.

A typical workflow looks like:

```text
Terraform Configuration
        │
        ▼
AzureRM Provider
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
Azure Resources