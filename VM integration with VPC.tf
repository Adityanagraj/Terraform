#########################################################################################################################
Here we will be creating our VPC with with our own Subnetwork and attaching it to our OS with Public-IP and Startup Script
#########################################################################################################################

provider "google" {
  project     = <project_ID>
  region      = <region>
  credentials = <example.json>
}
resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.gravity.id
  secondary_ip_range {
    range_name    = "tf-test-secondary-range-update1"
    ip_cidr_range = "192.168.10.0/24"
  }
}

resource "google_compute_network" "gravity" {
  name = "gravity"
  auto_create_subnetworks = false
}

resource "google_compute_instance" "tftestos1" {
  name         = "tftestos1"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"
  description = "lauched from tf"

  tags = ["test", "os1"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }
network_interface {
    network = "gravity"
    subnetwork=google_compute_subnetwork.network-with-private-secondary-ip-ranges.id
    access_config {}
}

metadata_startup_script = "sudo apt update && sudo apt install apache2 && sudo systemctl start apache2 && echo yippe  > /var/www/html/index.html "
depends_on = [
    google_compute_network.gravity,
  ]

}
