variable "sa_name" {
  type        = string
  description = "Storage Account Name"
}

variable "container_name" {
  type        = string
  description = "Storage Container Name"
}
variable "container_access" {
  type        = string
  description = "Storage Container Access Type"
  default     = "private"
}