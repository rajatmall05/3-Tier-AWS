variable "Private_EC2_Security_Group_id" {
  type    = list(string)
  default = [""]
}
variable "Public_EC2_Security_Group_id" {
  type    = list(string)
  default = [""]
}
variable "Private_Subnet_AZ1_id" {
  type    = string
  default = ""
}
variable "Public_Subnet_AZ1_id" {
  type    = string
  default = ""
}
