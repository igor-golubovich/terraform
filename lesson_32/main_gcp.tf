
#----------------------------------------------------------
# My Terraform
#
# Use Terraform with GCP - Google Cloud Platform
#
#-----------------------------------------------------------
//export GOOGLE_CLOUD_KEYFILE_JSON="gcp-creds.json"

provider "google" {
  credentials = file("mygcp-creds.json")
  project     = "modular-skyline-330516"
  region      = "europe-west3"
  zone        = "europe-west3-c"
}

resource "google_compute_instance" "my_server" {
  name         = "my-gcp-server"
  machine_type = "e2-micro"
  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"
  }
}
