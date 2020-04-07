terraform {
  required_version = "~> 0.12"

  # Use a GCS Bucket as a backend
  backend "gcs" {}
}

# https://www.terraform.io/docs/providers/google/index.html
provider "google" {
  version = "3.5.0"
  project = var.gcp_project_id
  region  = local.gcp_region
}

provider "google-beta" {
  version = "3.5.0"
  project = var.gcp_project_id
  region  = local.gcp_region
}

# Local values assign a name to an expression, that can then be used multiple
# times within a module. They are used here to determine the GCP region from
# the given location, which can be either a region or zone.
locals {
  gcp_location_parts = split("-", var.gcp_location)
  gcp_region         = format("%s-%s", local.gcp_location_parts[0], local.gcp_location_parts[1])
}

resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_network_name
  auto_create_subnetworks = "false"
  project                 = var.gcp_project_id
}

# https://www.terraform.io/docs/providers/google/r/compute_subnetwork.html
resource "google_compute_subnetwork" "vpc_subnetwork" {
  # The name of the resource, provided by the client when initially creating
  # the resource. The name must be 1-63 characters long, and comply with
  # RFC1035. Specifically, the name must be 1-63 characters long and match the
  # regular expression [a-z]([-a-z0-9]*[a-z0-9])? which means the first
  # character must be a lowercase letter, and all following characters must be
  # a dash, lowercase letter, or digit, except the last character, which
  # cannot be a dash.
  #name = "default-${var.gcp_cluster_region}"
  project = var.gcp_project_id
  region  = local.gcp_region

  name = var.vpc_subnetwork_name

  ip_cidr_range = var.vpc_subnetwork_cidr_range

  # The network this subnet belongs to. Only networks that are in the
  # distributed mode can have subnetworks.
  network = google_compute_network.vpc_network.self_link

  # Configurations for secondary IP ranges for VM instances contained in this
  # subnetwork. The primary IP of such VM must belong to the primary ipCidrRange
  # of the subnetwork. The alias IPs may belong to either primary or secondary
  # ranges.
  secondary_ip_range {
    range_name    = var.cluster_secondary_range_name
    ip_cidr_range = var.cluster_secondary_range_cidr
  }
  secondary_ip_range {
    range_name    = var.services_secondary_range_name
    ip_cidr_range = var.services_secondary_range_cidr
  }

  # When enabled, VMs in this subnetwork without external IP addresses can
  # access Google APIs and services by using Private Google Access. This is
  # set explicitly to prevent Google's default from fighting with Terraform.
  private_ip_google_access = true

  depends_on = [
    google_compute_network.vpc_network,
  ]
}

module "local-cluster-001" {
  source  = "../modules/gcp/gke"

  # These values are set from the terrafrom.tfvas file
  gcp_project_id                         = var.gcp_project_id
  cluster_name                           = "local-cluster-001"
  gcp_location                           = var.gcp_location
  daily_maintenance_window_start_time    = var.daily_maintenance_window_start_time
  node_pools                             = var.node_pools
  cluster_secondary_range_name           = var.cluster_secondary_range_name
  services_secondary_range_name          = var.services_secondary_range_name
  master_ipv4_cidr_block                 = var.master_ipv4_cidr_block
  access_private_images                  = var.access_private_images
  http_load_balancing_disabled           = var.http_load_balancing_disabled
  master_authorized_networks_cidr_blocks = var.master_authorized_networks_cidr_blocks
  istio_config_disabled                  = false

  # Refer to the vpc-network and vpc-subnetwork by the name value on the
  # resource, rather than the variable used to assign the name, so that
  # Terraform knows they must be created before creating the cluster

  vpc_network_name    = google_compute_network.vpc_network.name
  vpc_subnetwork_name = google_compute_subnetwork.vpc_subnetwork.name
}

module "local-cluster-002" {
  source  = "../modules/gcp/gke"

  # These values are set from the terrafrom.tfvas file
  gcp_project_id                         = var.gcp_project_id
  cluster_name                           = "local-cluster-002"
  gcp_location                           = var.gcp_location
  daily_maintenance_window_start_time    = var.daily_maintenance_window_start_time
  node_pools                             = var.node_pools
  cluster_secondary_range_name           = var.cluster_secondary_range_name
  services_secondary_range_name          = var.services_secondary_range_name
  master_ipv4_cidr_block                 = var.master_ipv4_cidr_block
  access_private_images                  = var.access_private_images
  http_load_balancing_disabled           = var.http_load_balancing_disabled
  master_authorized_networks_cidr_blocks = var.master_authorized_networks_cidr_blocks
  istio_config_disabled                  = true

  # Refer to the vpc-network and vpc-subnetwork by the name value on the
  # resource, rather than the variable used to assign the name, so that
  # Terraform knows they must be created before creating the cluster

  vpc_network_name    = google_compute_network.vpc_network.name
  vpc_subnetwork_name = google_compute_subnetwork.vpc_subnetwork.name
}

