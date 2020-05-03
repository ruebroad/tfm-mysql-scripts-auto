variable "default_tags" {
  type = map
}
variable "name_prefix" {}
variable "client" {
}
variable "rds_admin_name" {
  type = map
}
variable "rds_admin_pwd" {
  default = "change_me"
}
variable "rds_db_endpoint" {
  type = map
}
