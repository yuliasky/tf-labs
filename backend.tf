terraform {
  backend "gcs" {
    bucket = "instructor-20201022-student3xi-tfstate"
    credentials = "./creds/jenkins-sa.json"
  }
}
