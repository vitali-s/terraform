resource "google_compute_network" "network-1" {
  name                    = "network-1"
  description             = "Main VPC Network"
  auto_create_subnetworks = false
  routing_mode            = "REGIONAL"
}

resource "google_compute_subnetwork" "subnet-1-1" {
  name          = "subnet-1-1"
  description   = "Subnetwork"
  ip_cidr_range = "${cidrsubnet("10.0.0.0/8", 12, 1)}"
  network       = "${google_compute_network.network-1.name}"
}

resource "google_compute_subnetwork" "subnet-1-2" {
  name          = "subnet-1-2"
  description   = "Subnetwork"
  ip_cidr_range = "${cidrsubnet("10.0.0.0/8", 12, 2)}"
  network       = "${google_compute_network.network-1.name}"
}

resource "google_compute_subnetwork" "subnet-1-3" {
  name          = "subnet-1-3"
  description   = "Subnetwork"
  ip_cidr_range = "${cidrsubnet("10.0.0.0/8", 12, 3)}"
  network       = "${google_compute_network.network-1.name}"
}
