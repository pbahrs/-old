#Define the providers to use
provider "ibm" {
  softlayer_username = "${var.slusername}"
  softlayer_api_key = "${var.slapikey}"
}

#Create file storage
resource "ibm_storage_file" "fs_single_scaled" {
  type = "Performance"
  datacenter = "${var.datacenter}"
  capacity = "20"
  iops = "100"
}

#Create multiple VMs
resource "ibm_compute_vm_instance" "single_scaled_vm_instances" {
  count = "${var.vm_count}"
  os_reference_code = "${var.osrefcode}"
  hostname = "${format("CTU17-single-scaled-%02d", count.index + 1)}"
  domain = "${var.domain}"
  datacenter = "${var.datacenter}"
  file_storage_ids = ["${ibm_storage_file.fs_single_scaled.id}"]
  network_speed = 10
  cores = 1
  memory = 1024
  disks = [25, 10]
  ssh_key_ids = ["${var.sshkeyid}"]
  local_disk = false
  private_vlan_id = "${var.privatevlanid}"
  public_vlan_id = "${var.publicvlanid}"
}
#Define variables
variable slusername {
  description = "sl user name"
}
variable slapikey {
  description = "sl api key"
}
variable sshkeyid
  description = "ssh public key"
}
variable osrefcode {
  description = "operating system reference code for VMs"
}
variable datacenter {
  description = "location to deploy"
}
variable domain {
  description = "domain of the VMs"
}
variable vm_count {
  description = "number of VMs"
}
variable privatevlanid {
description = "private VLAN"
}
variable publicvlanid {
  description = "public VLAN"
}

