terraform {
  backend "gcs" {
    bucket = "infra-tf-20210921-student15xin-tfstate"
    credentials = "./creds/jenkins-sa.json"
  }
}
