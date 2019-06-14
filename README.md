# Azure Backup / Terraform

## Steps

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

## Edited output

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

The default restore in place create the timestemped versions of the os and data disks, and then disk swaps the VM.  Declarative systems such as ARM templates, Ansible and Terraform will see these as changes and could revert the disk attachment back to the original.

## Suggestion

Provide a toggle option / boolean argument to allow the restore in place to force the original disk names.

* check that the VM is deallocated
* rename the existing OS and data disk(s) to the timestamped naming convention
  * may have to be a move / clone
* restore from snapshot to the original disk name(s)

Include an explanaton of the behaviour, mentioning declarative comfig management tools. Include a warning if there is a clone step and it means that the restore is slower.
