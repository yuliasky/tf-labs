terraform {
  backend "gcs" {
    bucket = "auto-infra-20201117-student3xi-tfstate"
    credentials = "./creds/jenkins-sa.json"
  }
}
