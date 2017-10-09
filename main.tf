#Define the providers to use
provider "ibm" {
  softlayer_username = “${var.slusername}“
  softlayer_api_key = “${var.slapikey}“
}

#Create file storage
resource "ibm_storage_file" " fs_single_scaled " {
  type = "Performance"
  datacenter = “${var.datacenter}”
  capacity = 20
  iops = 100
  hourly_billing = true
}

#Create multiple VMs
resource "ibm_compute_vm_instance" "single_scaled_vm_instances" {
  count = "${var.vm_count}"
  hostname ="${format("single_scaled-%02d", count.index + 1)}"
  domain =  “${var.domain}”
  datacenter     = "${var.datacenter}"
  file_storage_ids = ["${ibm_storage_file.fs_single_scaled.id}"]
  network_speed  = “10” 
  hourly_billing = “true”
  cores = "1"
  memory = "1024"
  disks = "25, 10"
  local_disk = “false”
  private_vlan_id = “${var.privatevlanid}”
  public_vlan_id = “${var.publicvlanid}”
}

# Define variables 
variable slusername {
  description = "Your Softlayer username."
}
variable slapikey {
  description = "Your Softlayer API Key."

}
variable datacenter {
  description = "The datacenter to create resources in."
}
variable domain {
  description = “domain of the VMs”
}
variable vm_count {
  description = "The number of VM instances to provision."
}
variable privatevlanid {
  description = "The ID of an existing private VLAN."
}
variable publicvlanid {
  description = "The ID of an existing public VLAN."
}

