data "cloudflare_zones" "com_audacioustux" {
  filter {
    name = "audacioustux.com"
  }
}

locals {
  zone_audacioustux                = data.cloudflare_zones.com_audacioustux.zones[0]
  container_registry_dev_dns_label = "registry-dev"
}

resource "cloudflare_record" "com_audacioustux_CNAME_www" {
  zone_id = local.zone_audacioustux.id
  name    = "www"
  value   = local.zone_audacioustux.name
  type    = "CNAME"
  proxied = true
}

resource "cloudflare_record" "com_audacioustux_CNAME_root" {
  zone_id = local.zone_audacioustux.id
  name    = "@"
  value   = var.k8s_prod_ip_addr
  type    = "A"
  proxied = true
}

// container registry - dev/test environment
resource "cloudflare_record" "com_audacioustux_CNAME_registry" {
  zone_id = local.zone_audacioustux.id
  name    = local.container_registry_dev_dns_label
  value   = var.dev_container_registry_ip_addr
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
