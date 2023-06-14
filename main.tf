##############################################################################################################################

module "EC2" {
  source = "./EC2"

  # security group

  Private_EC2_Security_Group_id = module.VPC.Private_EC2_Security_Group_id
  Public_EC2_Security_Group_id = module.VPC.Public_EC2_Security_Group_id

  #subnet group
  
  Private_Subnet_AZ1_id = module.VPC.Private_Subnet_AZ1_id
  Private_Subnet_AZ2_id = module.VPC.Private_Subnet_AZ2_id
  Public_Subnet_AZ1_id = module.VPC.Public_Subnet_AZ1_id
}

############################################################################################################################

module "S3-Bucket" {
  source = "./S3-Bucket"
}

############################################################################################################################

module "VPC" {
  source = "./VPC"
  
}

############################################################################################################################

module "RDS" {
  source = "./RDS"
  RDS_Subnet_id = module.VPC.RDS_Subnet_id
  RDS_Security_Group_id = module.VPC.RDS_Security_Group_id
}

#############################################################################################################################

module "LOAD-BALANCER" {
  source = "./LOAD-BALANCER"
  Inter-LB-SG_id = module.VPC.LOAD-BALANCER.Inter-LB-SG_id
  External-LB-SG_id = module.VPC.LOAD-BALANCER.External-LB-SG_id
  VPC-id = module.VPC.LOAD-BALANCER.VPC-id

}


