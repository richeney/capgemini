# Steps

1. terraform init
1. terraform plan
1. terraform apply -auto-approve
1. Trigger the backup in the portal
1. Change the Instant Restore retention in the backup policy
    * From the default 2 days to max of 5 days
    * Note that it does not affect Terraform plan
    * Not an argument for the current Terraform provider type
1. Restore in place
    * Effectively restores to new disk names and does OS and Data Disk Swaps
1. `terraform plan` now shows changes required to the VM resource
