variable "account_name" {
  type = string
  default = "julientr99"
}

variable "api_key" {
  type = string
  sensitive = true
}

variable "group_id" {
  type = string
}

variable "volume_path" {
  type = string
  default = ""
}