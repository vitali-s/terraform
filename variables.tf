variable "is_preemptible" {
  default = true
}

data "google_compute_zones" "zones" {
  region = "us-west1"
  status = "UP"
}
