# Terraform code for NLB and ASG

This repository contains an example IaC for deploying the folowing:

* ASG
* NLB
* other necessary resources

Features:
* ASG scales down all instances after 18:00 PM CET Mon-Fri
* ASG scales up all instances after 08:00 AM CET Mon-Fri
* ASG instances contain nginx installed at deploy time via user data
* nginx is listening on port 31555
* You can access the default nginx page from management IP on NLB port 80 
* eu-central-1 region only


## How to run
Prepreqs:
* terraform v1.0.10 installed 
* save your ssh public key under files/ssh.key
* configure your terraform backend accordingly in provider.tf
* variables.tf: set your public IP 
* variables.tf: set debug variable to true if needed
* run below commands

```
terraform init
terraform plan
terraform apply --auto-aprove
```