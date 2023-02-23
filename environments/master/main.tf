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

resource "google_sql_database" "database" {
  name     = "bixon_database"
  instance = google_sql_database_instance.instance.name
    
}


resource "google_sql_database_instance" "instance" {
  name             = "bixon_postgres_instance"
  region           = "us-west1"
  database_version = "POSTGRES_14"
  settings {
    tier = "db-f1-micro"
  }

}

resource "google_sql_user" "users" {
  name     = "admin"
  password = "admin"
  instance = google_sql_database_instance.instance.name
}
