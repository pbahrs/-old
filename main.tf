# Set privider to ibm cloud
provider "ibm" {  
}
# Create an SSH key.  
resource "ibm_compute_ssh_key" "single_scaled_key" {
  label = "${var.key_label}"
  notes = "${var.key_note}"
  public_key = "${var.public_key}"
}

# Declare an existing private VLAN
resource "ibm_network_vlan" "single_scaled_VLAN1" {
}

# Import the VLAN configuration
$ terraform import ibm_network_vlan.single_scaled_VLAN1 582446 {
}

# Create file storage
resource "ibm_storage_file" "fs_single_scaled" {
        type = "Performance"
        datacenter = "${var.datacenter}"
        capacity = 20
        iops = 100
}

#Create block storage
resource "ibm_storage_block" "bs_single_scaled" {
        type = "Performance"
        datacenter = "${var.datacenter}"
        capacity = 20
        iops = 100
        os_format_type = "Linux"
}

#Create VM - connect to VLAN and mount block and file storage
resource "ibm_compute_vm_instance" "single_scaled_vm_instances" {
  count          = "${var.vm_count}"
  hostname       ="${format("single_scaled-%02d", count.index + 1)}"
  domain         = "ibm.com"
  datacenter     = "${var.datacenter}"
  private_vlan_id  = "${ibm_network_vlan.single_scaled_VLAN1.id}"
  block_storage_ids = ["${ibm_storage_block.bs_single_scaled.id}"]
  file_storage_ids = ["${ibm_storage_file.fs_single_scaled.id}"]
  network_speed     = 10 
#  ssh_key_ids    = ["${ibm_compute_ssh_key.single_scaled_key.id}"]
  ssh_key_ids    = ${var.public_key}
  hourly_billing = true
  cores          = "1"
  memory         = "1024"
  disks          = ["25"]
  local_disk     = false
  private_network_only = true
}

# Define variables 
variable bxapikey {
  description = "Your Bluemix API Key."
}
variable slusername {
  description = "Your Softlayer username."
}
variable slapikey {
  description = "Your Softlayer API Key."
}
variable datacenter {
  description = "The datacenter to create resources in."
}
variable public_key {
  description = "Your public SSH key material."
}
variable key_label {
  description = "A label for the SSH key that gets created."
}
variable key_note {
  description = "A note for the SSH key that gets created."
}
variable vm_count {
  description = "The number of VM instances to provision."
}

Outputs
#output "ssh_key_id" {
  value = "${ibm_compute_ssh_key.single_scaled_key.id}"
}
