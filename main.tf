resource "google_compute_instance" "demo" {
  count        = var.number_of_demo_instances
  name         = "web-instance-${count.index}"
  machine_type = "e2-small"
  zone         = "us-west1-a"
  metadata = {
   ssh-keys = "ubuntu:${file("/bitnami/jenkins/home/tf-key.pub")}"
}

  # boot disk specifications
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-1804-lts" 
    }
  }

  # networks to attach to the VM
  network_interface {
    network = "default"
    access_config {} // use ephemeral public IP
  }
}

resource "google_compute_firewall" "demo" {
  name    = "allow-gce-tcp-80"
  network = "default"
  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
  source_ranges = ["0.0.0.0/0"]
}

output "web_vm_ip" {
  value = [google_compute_instance.demo.*.network_interface.0.access_config.0.nat_ip]
}
