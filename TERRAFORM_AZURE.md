# Obtain The Terraform HCP Packer Datasource

The key component in a Terraform configuration that enables this is the ```hcp_packer_image``` datasource, this acts as the link between an image in the HCP Packer registry and the resource in the Terraform configuration used for creating the actual virtual machine.  

The code for the ```hcp_packer_image``` datasource block can be obtained via the HCP console.

For Azure, click on the image name in the registry:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_azure_image.png?raw=true">

and then click on "Use with Terraform":

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_azure_datasource.png?raw=true">

# Apply The Terraform Config

This section assumes that an Azure image has already been created per [these instructions](https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/PACKER.md)

1. Clone this repo unless this has already been done:
```
$ git clone https://github.com/chrisadkin/packer-golden-img-pipeline
```

2. Change directory to packer-golden-img-pipeline/terraform/azure:
```
$ cd packer-golden-img-pipeline/terraform/azure
```

3. Log into Azure:
```
$ az login
```

4. Open the ```main.tf``` file and note:

- the hcp_packer_image datasource at the top of the file
```
data "hcp_packer_image" "ubuntu_server_jammy" {
  bucket_name     = "ubuntu-server-jammy"
  channel         = "latest"
  cloud_provider  = "azure"
  region          = "East US"
}
```
- the ```azurerm_virtual_machine``` resource in which the image id is referred to:
```
resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = azurerm_resource_group.ubuntu_22_04_lts.location
  resource_group_name   = azurerm_resource_group.ubuntu_22_04_lts.name
  network_interface_ids = [azurerm_network_interface.main.id]
  vm_size               = "Standard_DS1_v2"
  
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    id = data.hcp_packer_image.ubuntu_server_jammy.cloud_image_id
  }
  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"
  }
  os_profile_linux_config {
    disable_password_authentication = false
  }
  tags = {
    environment = "staging"
  }
}
```

5. Install the terraform providers required by the congiguration:
```
$ terraform init
```   

6. Check the resources that the configuration will create:
```
$ terraform plan
```
   the tail of the output this rsults in should state the following:
```
   Plan: 5 to add, 0 to change, 0 to destroy.
```

7. Apply the configuration:
```
$ terraform apply -auto-approve
```
   the tail of the output from this should look like:
```
azurerm_resource_group.ubuntu_22_04_lts: Creating...
azurerm_resource_group.ubuntu_22_04_lts: Creation complete after 2s [id=/subscriptions/58844ee6-d1cb-4ebf-b9c2-378e143fcb40/resourceGroups/u2204lts-resources]
azurerm_virtual_network.main: Creating...
azurerm_virtual_network.main: Creation complete after 6s [id=/subscriptions/58844ee6-d1cb-4ebf-b9c2-378e143fcb40/resourceGroups/u2204lts-resources/providers/Microsoft.Network/virtualNetworks/u2204lts-network]
azurerm_subnet.internal: Creating...
azurerm_subnet.internal: Creation complete after 5s [id=/subscriptions/58844ee6-d1cb-4ebf-b9c2-378e143fcb40/resourceGroups/u2204lts-resources/providers/Microsoft.Network/virtualNetworks/u2204lts-network/subnets/internal]
azurerm_network_interface.main: Creating...
azurerm_network_interface.main: Still creating... [10s elapsed]
azurerm_network_interface.main: Creation complete after 12s [id=/subscriptions/58844ee6-d1cb-4ebf-b9c2-378e143fcb40/resourceGroups/u2204lts-resources/providers/Microsoft.Network/networkInterfaces/u2204lts-nic]
azurerm_virtual_machine.main: Creating...
azurerm_virtual_machine.main: Still creating... [10s elapsed]
azurerm_virtual_machine.main: Still creating... [20s elapsed]
azurerm_virtual_machine.main: Still creating... [30s elapsed]
azurerm_virtual_machine.main: Still creating... [40s elapsed]
azurerm_virtual_machine.main: Still creating... [50s elapsed]
azurerm_virtual_machine.main: Still creating... [1m0s elapsed]
azurerm_virtual_machine.main: Still creating... [1m10s elapsed]
azurerm_virtual_machine.main: Still creating... [1m20s elapsed]
azurerm_virtual_machine.main: Still creating... [1m30s elapsed]
azurerm_virtual_machine.main: Still creating... [1m40s elapsed]
azurerm_virtual_machine.main: Still creating... [1m50s elapsed]
azurerm_virtual_machine.main: Still creating... [2m0s elapsed]
azurerm_virtual_machine.main: Still creating... [2m10s elapsed]
azurerm_virtual_machine.main: Still creating... [2m20s elapsed]
azurerm_virtual_machine.main: Creation complete after 2m21s [id=/subscriptions/58844ee6-d1cb-4ebf-b9c2-378e143fcb40/resourceGroups/u2204lts-resources/providers/Microsoft.Compute/virtualMachines/u2204lts-vm]

Apply complete! Resources: 5 added, 0 changed, 0 destroyed.
```

8. Log into the Azure portal and check what virtual machines are present:
   
<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/azure_portal_vms.png?raw=true">

9. If the virtual machine is no longer required, remove it using the following command:
```
terraform destroy
```     
