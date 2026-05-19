
variable "rg_name" {
  type = string
}

variable "location" {
  type = string
}


variable "vnet_name" {
  type = string
}

variable "nsg_id" {
  description = "NSG ID to attach to NIC"
  type        = string
}

