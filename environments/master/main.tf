terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {

  project = var.project
  region  = var.region
}

resource "google_storage_bucket" "sql-files" {
  name          = "bixon-sql-files"
  location      = var.region
  force_destroy = true
}

resource "google_sql_database" "bixon-database" {
  name     = "bixon-database"
  instance = google_sql_database_instance.bixon-postgres-instance.name
    
}


resource "google_sql_database_instance" "bixon-postgres-instance" {
  name             = "bixon-postgres-instance"
  region           = "us-west1"
  database_version = "POSTGRES_14"
  settings {
    tier = "db-f1-micro"
  }

}

resource "google_sql_user" "users" {
  name     = "admin"
  password = "admin"
  instance = google_sql_database_instance.bixon-postgres-instance.name
}

terraform {
  backend "gcs" {
    bucket = "bixon-sql-files"
    prefix = "env/master"
  }
}
