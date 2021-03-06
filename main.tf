terraform {
  required_version = ">= 0.11.1"
}

variable "gcp_credentials" {
  description = "GCP credentials needed by google provider"
}

variable "gcp_project" {
  description = "GCP project name"
}

variable "gcp_region" {
  description = "GCP region, e.g. us-east1"
}

variable "gcp_zone" {
  description = "GCP zone, e.g. us-east1-a"
}

variable "machine_type" {
  description = "The GCP machine type"
  default = "n1-standard-1"
}

variable "instance_name" {
  description = "GCP instance name"
  default = "demo"
}

variable "image" {
  description = "image to build instance the from"
  default = "centos-6-v20180716"
}

provider "google" {
  project     = "${var.gcp_project}"
  region      = "${var.gcp_region}"
  credentials = "${var.gcp_credentials}"
}

resource "google_compute_instance" "demo" {
  name         = "${var.instance_name}"
  machine_type = "${var.machine_type}"
  zone         = "${var.gcp_zone}"

  boot_disk {
    initialize_params {
      image = "${var.image}"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

}

output "external_ip"{
  value = "${google_compute_instance.demo.network_interface.0.access_config.0.assigned_nat_ip}"
}
