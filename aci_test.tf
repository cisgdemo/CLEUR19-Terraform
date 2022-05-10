provider "aci" {
  username    = "api_user"
  private_key = "${var.aci_private_key}"
  cert_name   = "${var.aci_cert_name}"
  url         = "${var.apic_url}"
  insecure    = true
}

resource "aci_tenant" "terraform_ten" {
  name = "terraform_ten"
}

resource "aci_vrf" "vrf1" {
  tenant_dn = "${aci_tenant.terraform_ten.id}"
  name      = "vrf1"
}

resource "aci_bridge_domain" "bd1" {
  tenant_dn          = "${aci_tenant.terraform_ten.id}"
  relation_fv_rs_ctx = "${aci_vrf.vrf1.name}"
  name               = "bd1"
}

resource "aci_subnet" "bd1_subnet" {
  bridge_domain_dn = "${aci_bridge_domain.bd1.id}"
  name             = "Subnet"
  ip               = "${var.bd_subnet}"
}

resource "aci_application_profile" "app1" {
  tenant_dn = "${aci_tenant.terraform_ten.id}"
  name      = "app1"
}

resource "aci_application_epg" "epg1" {
  application_profile_dn = "${aci_application_profile.app1.id}"
  name                   = "epg1"
  relation_fv_rs_bd      = "${aci_bridge_domain.bd1.name}"
  relation_fv_rs_dom_att = ["${var.vmm_domain_dn}"]
  relation_fv_rs_cons    = ["${aci_contract.contract_epg1_epg2.name}"]
}

