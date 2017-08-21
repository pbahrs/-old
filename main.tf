# Set privider to ibm cloud
provider "ibm" {
   
}

# Create an SSH key. The SSH key surfaces in the SoftLayer console under Devices > Manage > SSH Keys.

resource "ibm_compute_ssh_key" "single_scaled_key" {
  label = "${var.key_label}"
  notes = "${var.key_note}"
  public_key = "${var.public_key}"
}

# Create a private VLAN
resource "ibm_network_vlan" "single_scaled_VLAN1" {
   name = "singel_scaled_private_vlan"
   datacenter = "${var.datacenter}" 
   type = "PRIVATE"
   subnet_size = 8
}

#Create block storage
resource "ibm_storage_block" "bockStorage1" {
        type = "Performance"
        datacenter = "${var.datacenter}"
        capacity = 20
        iops = 100
        os_format_type = "Linux"
}

#Create VM
resource "ibm_compute_vm_instance" "single_scaled_vm_instances" {
  count          = "${var.vm_count}"
  hostname       ="${format("single_scaled-%02d", count.index + 1)}"
  domain         = "ibm.com"
  datacenter     = "${var.datacenter}"
  private_vlan_id  = "${ibm_network_vlan.single_scaled_VLAN1.id}"
  block_storage_ids = ["${ibm_storage_block.bockStorage1.id}"]
  network_speed     = 10 
  ssh_key_ids    = ["${ibm_compute_ssh_key.test_key_1.id}"]
  hourly_billing = true
  cores          = "1"
  memory         = "1024"
  disks          = ["25"]
  local_disk     = false
  private_network_only = true
}
