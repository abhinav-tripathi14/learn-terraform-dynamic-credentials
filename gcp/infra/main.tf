provider "google" {
  project = var.gcp_project_id
  region  = var.gcp_region
  zone    = var.gcp_zone
}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-instance"
  machine_type = var.machine_type

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }

  network_interface {
    network = "default"
    access_config {
    }
  }

  metadata_startup_script = <<-EOF
    #!/bin/bash
    sudo yum update -y
    sudo yum install httpd -y
    sudo systemctl enable httpd
    sudo systemctl start httpd
    echo "<html><body><div>Hello, world!</div></body></html>" > /var/www/html/index.html
    EOF

  tags = var.tags
}

resource "google_compute_backend_bucket" "image_backend" {
  name        = "image-backend-bucket"
  description = "Contains beautiful images"
  bucket_name = google_storage_bucket.image_backend.name
  enable_cdn  = true
  edge_security_policy = google_compute_security_policy.policy.id
}

resource "google_storage_bucket" "image_backend" {
  name     = "image-store-bucket"
  location = "EU"
}

resource "google_compute_security_policy" "policy" {
  name        = "image-store-bucket"
  description = "basic security policy"
    type = "CLOUD_ARMOR_EDGE"
}
