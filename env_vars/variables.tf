variable "address_space" {
  type = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-sbox.yaml")), ["address_space"])
}


variable "location" {
  type        = string
  description = "The azure resource location"
  default = try(yamldecode(file("${path.root}/pipeline/variables-common.yaml")), ["location"])
}

variable "env" {
  type        = string
  description = "The platform environment"
  default = try(yamldecode(file("${path.root}/pipeline/variables-sbox.yaml")), ["env"])
}

variable "common_tags" {
  type        = map(string)
  description = "Tags for the Azure resources"
}

variable "product" {
  type        = string
  description = "Product name used in naming standards"
  default = try(yamldecode(file("${path.root}/pipeline/variables-common.yaml")), ["product"])
}

variable "admin_ssh_key_path" {
  type    = string
  default = "~/.ssh/wowza.pub"
}

variable "service_certificate_kv_url" {
  type = string
}

variable "key_vault_id" {
  type = string
}

# DNS
variable "dns_zone_name" {
  type = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-sbox.yaml")), ["dns_zone_name"])
}

variable "dns_resource_group" {
  type = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-sbox.yaml")), ["dns_resource_group"])
}

variable "address_space" {
  type = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-sbox.yaml")), ["address_space"])
}

variable "lb_IPaddress" {
  type = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-sbox.yaml")), ["lb_IPaddress"])
}

variable "cert_path" {
  type = string
}

variable "thumbprint" {
  type = string
}

variable "wowza_publisher" {
  type = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-common.yaml")), ["wowza_publisher"])
}

variable "wowza_offer" {
  type = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-common.yaml")), ["wowza_offer"])
}

variable "wowza_version" {
  type = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-common.yaml")), ["wowza_version"])
}

variable "wowza_sku" {
  type    = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-common.yaml")), ["wowza_sku"])
}

variable "num_applications" {
  type    = number
  default = 1
}

variable "ssh_public_key" {
  type = string
}

variable "rtmps_source_address_prefixes" {
  type = list(string)
  default =["35.204.50.163\",\"35.204.108.36\",\"34.91.92.40\",\"34.91.75.226\",\"81.109.71.47\"]
}

variable "ws_name" {
  type = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-sbox.yaml")), ["ws_name"])
}

variable "ws_rg" {
  type    = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-sbox.yaml")), ["ws_rg"])
}

variable "ws_sub_id" {
  type = string
  default = try(yamldecode(file("${path.root}/pipeline/variables-sbox.yaml")), ["ws_sub_id"])
}
