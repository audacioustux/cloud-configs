data "cloudflare_zones" "com_audacioustux" {
  filter {
    name = "audacioustux.com"
  }
}

locals {
  zone_audacioustux         = data.cloudflare_zones.com_audacioustux.zones[0]
  k3s_test_server-public_ip = data.terraform_remote_state.k8s-test.outputs.k3s-server-ip.value
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

resource "cloudflare_record" "com_audacioustux_A_argocd-test" {
  zone_id = local.zone_audacioustux.id
  name    = "argocd-test"
  value   = local.k3s_test_server-public_ip
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "craftkori_A" {
  zone_id = local.zone_audacioustux.id
  name    = "craftkori"
  value   = var.craftkori_ip_addr
  type    = "A"
  proxied = true
}

resource "cloudflare_record" "craftkori_SRV_mc_tcp_4120" {
  zone_id = local.zone_audacioustux.id
  name    = "_minecraft._tcp"
  type    = "SRV"

  data {
    service  = "_minecraft"
    proto    = "_tcp"
    name     = "craftkori"
    priority = 0
    weight   = 0
    port     = 4120
    target   = "craftkori.audacioustux.com"
  }
}

resource "cloudflare_record" "craftkori_SRV_mc_tcp_5968" {
  zone_id = local.zone_audacioustux.id
  name    = "_minecraft._tcp"
  type    = "SRV"

  data {
    service  = "_minecraft"
    proto    = "_tcp"
    name     = "craftkori"
    priority = 0
    weight   = 0
    port     = 5968
    target   = "craftkori.audacioustux.com"
  }
}

resource "cloudflare_record" "craftkori_SRV_mc_udp_24454" {
  zone_id = local.zone_audacioustux.id
  name    = "_minecraft._udp"
  type    = "SRV"

  data {
    service  = "_minecraft"
    proto    = "_udp"
    name     = "craftkori"
    priority = 0
    weight   = 0
    port     = 24454
    target   = "craftkori.audacioustux.com"
  }
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
