provider "azurerm" {
  features {}
}

provider "hcp" {}

data "hcp_packer_image" "ubuntu_server_jammy" {
  bucket_name     = "ubuntu-server-jammy"
  channel         = "latest"
  cloud_provider  = "azure"
  region          = "East US"
}

variable "prefix" {
  default = "u2204lts"
}

resource "azurerm_resource_group" "ubuntu_22_04_lts" {
  name     = "${var.prefix}-resources"
  location = "East US"
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.ubuntu_22_04_lts.location
  resource_group_name = azurerm_resource_group.ubuntu_22_04_lts.name
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.ubuntu_22_04_lts.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = azurerm_resource_group.ubuntu_22_04_lts.location
  resource_group_name = azurerm_resource_group.ubuntu_22_04_lts.name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

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
