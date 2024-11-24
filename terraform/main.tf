# WARNING !!!! 
# No security has been implemented, it is only to test the deployment native metrics
# DO NOT deploy this configuration on production servers
terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

