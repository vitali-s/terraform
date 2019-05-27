provider "google" {
  credentials = "${file("~/.gcp/account.json")}"
  project     = "***"
  region      = "us-west1"
  zone        = "us-west1-a"
}

provider "google-beta" {
  credentials = "${file("~/.gcp/account.json")}"
  project     = "***"
  region      = "us-west1"
  zone        = "us-west1-a"
}

provider "aws" {
  region                  = "us-west-2"
  shared_credentials_file = "${file("~/.aws/credentials")}"
  profile                 = "default"
}
