# Cloud Forensics mini-lab

Spin on chvancooten's CloudLabsAD (https://github.com/chvancooten/CloudLabsAD/) but with a Wazuh single stack instead of Elastic.

## Install instructions

To paraphrase M. Van Cooten's original README

    Clone the repo to your Azure cloud shell.
    Copy `terraform.tfvars.example` to `terraform.tfvars` in the Terraform directory, and configure the variables appropriately.
    In the same directory, run `terraform init`
    When you're ready to deploy, run `terraform apply` (or `terraform apply --auto-approve` to skip the approval check).

    Once done with the lab, run `terraform destroy`
