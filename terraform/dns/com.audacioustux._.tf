data "cloudflare_zones" "com_audacioustux" {
  filter {
    name = "audacioustux.com"
  }
}

locals {
  zone_audacioustux         = data.cloudflare_zones.com_audacioustux.zones[0]
  k3s_test_server-public_ip = data.terraform_remote_state.k8s-test.outputs.k3s-server-ip
}

resource "cloudflare_record" "com_audacioustux_CNAME_www" {
  zone_id = local.zone_audacioustux.id
  name    = "www"
  value   = local.zone_audacioustux.name
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "com_audacioustux_A_kuma" {
  zone_id = local.zone_audacioustux.id
  name    = "kuma"
  value   = local.k3s_test_server-public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "com_audacioustux_A_trilium" {
  zone_id = local.zone_audacioustux.id
  name    = "trilium"
  value   = local.k3s_test_server-public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "com_audacioustux_A_argocd-test" {
  zone_id = local.zone_audacioustux.id
  name    = "argocd-test"
  value   = local.k3s_test_server-public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "audacioustux_com_TXT_dmarc" {
  zone_id = local.zone_audacioustux.id
  name    = "_dmarc"
  value   = "v=DMARC1; p=reject; sp=reject; adkim=s; aspf=s;"
  type    = "TXT"
  proxied = false
}

resource "cloudflare_record" "audacioustux_com_TXT_domainkey" {
  zone_id = local.zone_audacioustux.id
  name    = "*._domainkey"
  value   = "v=DKIM1; p="
  type    = "TXT"
  proxied = false
}

resource "cloudflare_record" "audacioustux_com_TXT" {
  zone_id = local.zone_audacioustux.id
  name    = "audacioustux.com"
  value   = "v=spf1 -all"
  type    = "TXT"
  proxied = false
}
