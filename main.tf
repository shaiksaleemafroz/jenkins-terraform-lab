# 1. VPC Configuration
resource "google_compute_network" "vpc_network" {
  name                    = "vpc-network"
  auto_create_subnetworks = false
}

# 2. Subnet Configuration
resource "google_compute_subnetwork" "subnet" {
  name          = "subnet-1"
  network       = google_compute_network.vpc_network.name
  ip_cidr_range = "10.0.0.0/24"
}

resource "google_storage_bucket" "terraform-afrozbucket2026" {
  name          = "terraform-afrozbucket2026"
  location      = "US"
}

# 3. VM Instance Configuration
resource "google_compute_instance" "vm_instance" {
  count        = var.instance_count  # Use instance_count variable to create multiple instances
  name         = "${var.instance_name}-${count.index + 1}"  # Append instance number to name
  machine_type = var.instance_machine_type  # Use instance_machine_type variable
  zone         = var.zone  # Use zone variable
  
  # Boot disk configuration for the VM
  boot_disk {
    initialize_params {
      image = "debian-11"
      size  = 10 # 10 GB boot disk size
    }
  }

  network_interface {
    network = google_compute_network.vpc_network.name
    subnetwork = google_compute_subnetwork.subnet.name
    access_config {
      # Allocate a public IP
    }
  }

  metadata_startup_script = <<-EOT
    #!/bin/bash
    echo "Hello, World!" > /var/www/html/index.html
    EOT
}

# 4. Google Kubernetes Engine (GKE) Cluster Configuration
resource "google_container_cluster" "aks_cluster" {
  name     = "my-aks-cluster"

  initial_node_count = 1
  
  node_config {
    machine_type = var.instance_machine_type  # Use instance_machine_type variable
    
    # Ensuring each GKE node has a 30 GB disk
    disk_size_gb = 30
    disk_type    = "pd-standard"  # Use standard persistent disk
  }

  network    = google_compute_network.vpc_network.name
  subnetwork = google_compute_subnetwork.subnet.name
}
