#################################################################################################################################################################################
Here we will be creating our VPC with with our own Subnetwork,Firewall and attaching it to our OS with Public-IP and Startup Script To install apache2 server to host your website
##################################################################################################################################################################################

provider "google" {
  project     = <project_ID>
  region      = <region>
  credentials = <example.json>
}
resource "google_compute_firewall" "firewallforhttpssh" {
  name    = "firewallforhttpssh"
  network     = google_compute_network.gravity.name
  description = "Creates firewall rule targeting tagged instances"

  allow {
    protocol  = "tcp"
    ports     = ["80", "22"]
  }
  target_tags = ["http","ssh"]
}
resource "google_compute_subnetwork" "network-with-private-secondary-ip-ranges" {
  name          = "test-subnetwork"
  ip_cidr_range = "10.2.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.gravity.id
  #secondary_ip_range {
   # range_name    = "tf-test-secondary-range-update1"
    #ip_cidr_range = "192.168.10.0/24"
  #}
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

  tags = ["http","ssh","http-server"]

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

metadata_startup_script = "#!/bin/bash \n sudo apt update && sudo apt install apache2 -y && sudo systemctl start apache2 && echo yippe from terraform  > /var/www/html/index.html "
depends_on = [
    google_compute_network.gravity,
  ]

}
