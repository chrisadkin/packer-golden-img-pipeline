# Packer Image Build Instructions
## Building An AWS AMI Image

For building an AMI image and pushing it to a HCP Packer registry follow [this HashiCorp tutorial](https://developer.hashicorp.com/packer/tutorials/hcp-get-started/hcp-push-image-metadata)

## Building An Azure Image

1. Create HCP Packer registry
   Go to the HashiCorp Cloud Platform portal. After logging in, you will find Packer under "Services" in the left navigation menu.

   You must enable the HCP Packer registry before Packer can publish build metadata to it. Click the Create a registry button after clicking on the Packer link under "Services" in the left navigation.
   This only needs to be done once.

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/create_hcp_packer_registry.png?raw=true">

2. Create HCP service principal and set the HCP_CLIENT_ID and HCP_SECRET environment variables

   In HCP Packer, go to Access control (IAM) in the left navigation menu, then select the Service principals tab.

   Create a service principal named packer with the Contributor role.

   Once you create the service principal, click the service principal name to view its details. From the detail page, click + Generate key to create a client ID and secret.

   Copy and save the client ID and secret; you will not be able to retrieve the secret later. You will use these credentials in the next step.
   
<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/create_hcp_service_principal.png?raw=true">
 
3. Once you generate the keys for the service principal, set the client ID and secret as environment variables so that Packer can authenticate with HCP. 
   In your terminal, set an environment variable for the client ID:
```   
$ export HCP_CLIENT_ID=
$ export HCP_SECRET=
```

   __Note__

   If the service principal created is assopciated with a HCP project, a ```HCP_PROJECT_ID``` environment variable will also need to be set, set this to the id (a Guid) of the 
   project, this can be found via Project Settings on the vertical menu bar of the main screen that appears when you first login.      

4. Clone this repo:
```
git clone https://github.com/chrisadkin/packer-golden-img-pipeline
```

5. Log into Azure with the CLI:
```
$ az login
```
   
6. Create an Azure service principal:   
```
$ az ad sp create-for-rbac --role Contributor --scopes /subscriptions/<subscription_id> --query "{ client_id: appId, client_secret: password, tenant_id: tenant }
```
   Note the client id, client secret and tenant id that result from this.

7. Create a resource group:
```
$ az group create -l eastus -n hcp_packer_golden_img 
```

8. Change directory to packer-golden-img-pipeline

9. Review the Packer template
```   
source "azure-arm" "ubuntu_server_22_04_lts" {
  azure_tags = {
    dept = "Engineering"
    task = "Image deployment"
  }
  client_id                         = "${var.client_id}"
  client_secret                     = "${var.client_secret}"
  image_offer                       = "0001-com-ubuntu-server-jammy"
  image_publisher                   = "canonical"
  image_sku                         = "22_04-lts"
  location                          = "East US"
  managed_image_name                = "ubuntu-server-jammy"
  managed_image_resource_group_name = "hcp_packer_golden_img"
  os_type                           = "Linux"
  subscription_id                   = "${var.subscription_id}"
  tenant_id                         = "${var.tenant_id}"
  vm_size                           = "Standard_DS2_v2"
}

build {
  hcp_packer_registry {
    bucket_name = "ubuntu-server-jammy"
    description = "Sample packer file for an Azure VM golden image"

    bucket_labels = {
      "owner"          = "platform-team"
      "os"             = "Ubuntu",
      "ubuntu-version" = "Focal 22.04",
    }

    build_labels = {
      "build-time"   = timestamp()
      "build-source" = basename(path.cwd)
    }
  }

  sources = ["source.azure-arm.ubuntu_server_22_04_lts"]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; {{ .Vars }} sudo -E sh '{{ .Path }}'"
    inline          = ["apt-get update", "apt-get upgrade -y", "apt-get -y install nginx", "/usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
    inline_shebang  = "/bin/sh -x"
  }
}
```

__Note__

The ```hcp_packer_registry``` block, it is this when used in conjunction with the ```HCP_``` environment variables which result in the image's metadata being stored
in the HCP Packer registry.

10. Using the text editor of your choice, open the ```variables.pkrvars.hcl``` file and replace the value placeholders in angular brackets with your own client, subscription and tenant id values:
```
client_id       = "<Your service principal client id goes here>"
client_secret   = "<Your service principal client secret goes here>"
subscription_id = "<Your Azure subscription id goes here>"
tenant_id       = "<Your Azure tenant id goes here>"
```
    
11. Install the packer plugins:
```
$ packer init
```

13. Build the image:
```
$ packer build -var-file=variables.pkrvars.hcl .
```      
    
14. Once the build has completed a series of messages similiar to the following should be visible at the end of the packer output:

``` 
==> Builds finished. The artifacts of successful builds are:
--> azure-arm.ubuntu_server_22_04_lts: Azure.ResourceManagement.VMImage:

OSType: Linux
ManagedImageResourceGroupName: hcp_packer_golden_img
ManagedImageName: ubuntu-server-jammy
ManagedImageId: /subscriptions/12345ee6-d7cb-8ebf-b9c2-123e456fcb78/resourceGroups/hcp_packer_golden_img/providers/Microsoft.Compute/images/ubuntu-server-jammy
ManagedImageLocation: East US

--> azure-arm.ubuntu_server_22_04_lts: Published metadata to HCP Packer registry packer/ubuntu-server-jammy/iterations/01HDP4DSTJT49TPA4DYPGRYDS0
``` 

15. Go back into the HCP console and check the contents of your HCP Packer registry:

<img style="float: left; margin: 0px 15px 15px 0px;" src="https://github.com/chrisadkin/packer-golden-img-pipeline/blob/main/png_images/hcp_packer_registry.png?raw=true">
