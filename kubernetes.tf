resource "google_container_cluster" "kube-1" {
  name                     = "kube-1"
  location                 = "${data.google_compute_zones.zones.names[0]}"
  initial_node_count       = 1
  remove_default_node_pool = true

  master_auth {
    password = "OTplVZML6YP52vWmUvi6iwYrXc3mu4XqfqltV2qj"
    username = "admin"
  }
}

resource "google_container_node_pool" "kube-1-node-pool" {
  name       = "kube-1-node-pool"
  location   = "${data.google_compute_zones.zones.names[0]}"
  cluster    = "${google_container_cluster.kube-1.name}"
  node_count = 1

  node_config {
    preemptible  = true
    machine_type = "f1-micro"

    metadata {
      disable-legacy-endpoints = "true"
    }

    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]
  }
}

output "client_certificate" {
  value = "${google_container_cluster.kube-1.master_auth.0.client_certificate}"
}

output "client_key" {
  value = "${google_container_cluster.kube-1.master_auth.0.client_key}"
}

output "cluster_ca_certificate" {
  value = "${google_container_cluster.kube-1.master_auth.0.cluster_ca_certificate}"
}
