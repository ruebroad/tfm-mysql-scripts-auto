variable "account_id" {}
variable "default_tags" {
  type = map
}
variable "name_prefix" {}
variable "client" {
}
variable "expiration" {
  default = 30
}
