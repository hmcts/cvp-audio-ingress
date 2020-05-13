variable "location" {
  type        = string
  description = "The azure resource location"
}

variable "env" {
  type        = string
  description = "The platform environment"
}

variable "common_tags" {
  type        = map(string)
  description = "Tags for the Azure resources"
}

variable "product" {
  type        = string
  description = "Product name used in naming standards"
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
}

variable "dns_resource_group" {
  type = string
}

variable "address_space" {
  type = string
}

variable "cert_path" {
  type = string
}

variable "thumbprint" {
  type = string
}

variable "wowza_publisher" {
  type = string
}

variable "wowza_offer" {
  type = string
}

variable "wowza_version" {
  type = string
}

variable "wowza_sku" {
  type = string
}

variable "num_applications" {
  type    = number
  default = 1
}

variable "ssh_public_key" {
  type    = string
  default = "c3NoLXJzYSBBQUFBQjNOemFDMXljMkVBQUFBREFRQUJBQUFDQVFDM051SHdJZit5aFBPeGdWbHI5SDBTamJTTW94L2RodXVVZWl0R1dra2JTVXRIbHc4SUdiME1tTUo2L0s2S3pUbW1INlN3SUIvTHlSa1dNd3Y2aWRDUVZ1b2RCU0VOdHI3RG41WUNWaU05RUQ3akp1c0dqMTJLaVROQzI0T3NQYkplcmdwa0YvUmFUY3pIeGhnZ0RhL2JuN1gwa1B4VUpxMUd2UWdScm5sd2VmV1Q5RHcvby9JZHVXdjJ1MHJVVGErRUwvOFdaWkw4bUlwdWcydDVkVTRGZStvckpYNDNHejd1TW82dG1vWXVKOUtXZ2RKUTVSbDdGUkJRZmVRVGJpZjJZd3hQWCtrTjV6YTdDN2pTeDVJbUxKelpab2NOVkEwOW4zaTNMSHRyb2lFUHJlTmlvOHpHUlNPelExcktyZnJrOFlYaVd2K2hwMDRabGVsWjVNV3Q2OFJZRXdsSTkxQ25SV2VnTjNYYVdCRXBxZGkxVDZSRXNIOFc5TzJjVWdKWGdpM0M0Z1E4N3ArUUN1NlBOeEp6c2U3c0gwZlRya05WSzBHUWNMSmFRakVVcVppbjVHNWc5WVFMZm5OcjNwemFvT09WZ2hYMFJEZFNzNHB3WUMxMnM2NytZaXowSFdzYjFhMWczZFBFei9QY21BMVV3YlNQTlNmd1lNUUY2RytTcDk3bnV5czFtVGsvN0VULzRYRWptWTBDdFUwQlBlR0Z3QWY4b1YrN0YrMmJVRlZYbmNxTGRXamIwSVljQW9OYTZEOFAzSlprVms3UzVPWnQzNkpkQ25vZG96bXdKd2h2WnRBNjl3U3BOa3ZtV0c2bStsRmdlT1JlRk9mRVF1Qi9NR0xBazY3aHVzSmtYcHUxaFoxZVA3bzhON1FoQng3eWhPWmlVWlowRFE9PSB2c3RzQGZ2LWF6MTQKCg=="
}