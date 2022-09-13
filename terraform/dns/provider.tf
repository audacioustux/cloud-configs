terraform {
  required_providers {
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 3.0"
    }
    oci = {
      source  = "oracle/oci"
      version = "4.73.0"
    }
  }
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}
