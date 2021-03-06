terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.61.0"
    }
  }
}

provider "google" {
  credentials = file("cred-gcp.json")
  project     = "silken-realm-307723"
  region      = var.region
  zone      = var.zone
  }

resource "google_compute_address" "vm_stage_ip" {
  name = "stageip"
  }
# Create VM for staging
resource "google_compute_instance" "vm_stage" {
  name = "stage"
  machine_type = var.machine_type // 2vCPU, 2GB RAM
  
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = "true"
    initialize_params {
      size = "10"
      type = "pd-balanced" // Available options: pd-standard, pd-balanced, pd-ssd
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  # Startup script - update, install python3 (for Ansible) 
  metadata_startup_script = "sudo apt-get update; sudo apt-get install python3 -y"

  network_interface {
  network = "default"

  access_config {
    nat_ip = google_compute_address.vm_stage_ip.address
    }
  }

  metadata = {
    ssh-keys = "root:${file("/root/.ssh/id_rsa.pub")}" // Copy ssh public key
    }
  }  

# Static IP VM for Ansible
output "stage_ip" {
 value = google_compute_instance.vm_stage.network_interface.0.access_config.0.nat_ip
}

resource "google_compute_address" "vm_prod_ip" {
  name = "prodip"
  }

# Create VM for Production
resource "google_compute_instance" "vm_prod" {
  name = "prod"
  machine_type = var.machine_type // 2vCPU, 2GB RAM
  
  allow_stopping_for_update = true

  boot_disk {
    auto_delete = "true"
    initialize_params {
      size = "10"
      type = "pd-balanced" // Available options: pd-standard, pd-balanced, pd-ssd
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  # Startup script - update, install python3(for Ansible) 
  metadata_startup_script = "sudo apt-get update; sudo apt-get install python3 -y"

  metadata = {
    ssh-keys = "root:${file("/root/.ssh/id_rsa.pub")}" // Copy ssh public key
    }

  network_interface {
  network = "default"

  access_config {
    nat_ip = google_compute_address.vm_prod_ip.address
    }
  }
}  

# Static IP VM for Ansible
output "prod_ip" {
 value = google_compute_instance.vm_prod.network_interface.0.access_config.0.nat_ip
}

# Waiting_30s 
resource  "time_sleep" "wait_30_seconds" {
  depends_on = [google_compute_instance.vm_prod]
  create_duration = "30s"
}

# Add IP address in inventory file 
resource "null_resource" "ansible_hosts_provisioner" {
   depends_on = [time_sleep.wait_30_seconds]
  provisioner "local-exec" {
    interpreter = ["/bin/bash" ,"-c"]
    command = <<EOT
      cat <<EOF >./inventory/hosts
[stage] 
$(terraform output stage_ip)
[prod]
$(terraform output prod_ip)
EOF
      export ANSIBLE_HOST_KEY_CHECKING=False
    EOT
  }
}

#resource "time_sleep" "wait_10_seconds" {
  #depends_on = [null_resource.ansible_hosts_provisioner]
  #create_duration = "10s"
#}

# run playbook on created VM
resource "null_resource" "ansible_playbook_provisioner" {
  depends_on = [time_sleep.wait_30_seconds]
  provisioner "local-exec" {
    command = "sleep 10;ansible-playbook -u root --vault-password-file 'vault_pass' --private-key '/root/.ssh/id_rsa' -i ./inventory/hosts main.yml"
  }
}