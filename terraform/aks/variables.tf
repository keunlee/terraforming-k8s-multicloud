# variable "cluster_name" {
#     type = string
# }

variable "resource_group_name" {
    type = string
}

variable "location" {
    type = string
}

variable "client_id" {
    type = string
}

variable "client_secret" {
    type = string
}

variable "prefix" {
    type = string
}

variable node_pool_name  {
    type = string
    default = "default"
}

variable "node_count" {
  type = number
  default = 1
}

variable "vm_size" {
    type = string
    default = "Standard_D2_v2"
}

variable "object_id" {
    type = string
}

variable "subscription_id" { 
    type = string
}

variable "acr_name" {
    type = string
}

