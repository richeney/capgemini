# Azure Backup / Terraform

## Steps

1. Install terraform (or run in Cloud Shell which has terraform pre-installed)
1. `terraform init`
1. `terraform plan`
1. `terraform apply -auto-approve`
1. Running `terraform plan` again at this point will show no planned changes. 
1. Trigger the backup in the portal
1. Restore in place using the portal
    * Effectively restores from snapshot to new timestamped disk
    * Uses set and attach for OS and data disk swaps
1. `terraform plan` now believes that changes are required to the VM resource

## Edited terraform plan output

```bash
<snip>
      ~ storage_os_disk {                                                                                                                                                              caching                   = "ReadWrite"
            create_option             = "FromImage"
            disk_size_gb              = 30
            managed_disk_id           = "/subscriptions/2ca40be1-7e80-4f2b-92f7-06b2123a68cc/resourceGroups/capgemini-test/providers/Microsoft.Compute/disks/capgemini-osdisk-20190612-144118"
            managed_disk_type         = "Standard_LRS"
          ~ name                      = "capgemini-osdisk-20190612-144118" -> "capgemini-os"                                                                                           os_type                   = "Linux"
            write_accelerator_enabled = false
        }
    }
Plan: 0 to add, 1 to change, 0 to destroy.
```

## Issue

The default restore in place create the timestemped versions of the os and data disks, and then disk swaps the VM.  Declarative systems such as ARM templates, Ansible and Terraform will see these as changes and would revert the disk attachment back to the original if that terraform plan is then applied.

## Suggestion

Provide a toggle option / boolean argument to allow the restore in place to force the original disk names.

* check that the VM is deallocated
* rename the existing OS and data disk(s) to the timestamped naming convention
  * may have to be a move / clone
* restore from snapshot to the original disk name(s)

Include tooltip explanaton, mentioning declarative comfig management tools. Include a warning if there is a clone step as the restore would be slower.
