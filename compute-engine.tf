# get the latest cos cloud image
data "google_compute_image" "image" {
  name    = "cos-69-10895-242-0"
  project = "cos-cloud"
}

resource "google_compute_instance" "instance-1-1" {
  name         = "instance-1-1"
  description  = "Instance 1-1 description"
  machine_type = "f1-micro"
  zone         = "${data.google_compute_zones.zones.names[0]}"

  boot_disk {
    auto_delete = "true"

    initialize_params {
      size  = "10"
      type  = "pd-standard"
      image = "${data.google_compute_image.image.self_link}"
    }
  }

  network_interface {
    network    = "${google_compute_network.network-1.self_link}"
    subnetwork = "${google_compute_subnetwork.subnet-1-1.self_link}"

    access_config {}
  }

  scheduling {
    automatic_restart = false
    preemptible       = "${var.is_preemptible}"
  }

  metadata {
    type = "machine 1-1"
  }

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
