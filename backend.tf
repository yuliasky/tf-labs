terraform {
  backend "gcs" {
    bucket = "infra-20210121-student13xinnov-tfstate"
    credentials = "./creds/jenkins-sa.json"
  }
}
