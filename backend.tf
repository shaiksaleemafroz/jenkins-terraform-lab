terraform {
  backend "gcs" {
    bucket = "devops-storagebucket"  # GCS bucket name
    prefix = "terraform/state"              # Path within the bucket (e.g., a folder structure)
  }
}
