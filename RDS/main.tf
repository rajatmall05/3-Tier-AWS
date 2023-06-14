 # CREATING SUBNET GROUP FOR RDS ---------------------------------------------------------------------------------------------------------------

 resource "aws_docdb_subnet_group" "Subnet-Group" {
   name       = "subnet-group"
   subnet_ids = var.RDS_Subnet_id

   tags = {
     Name = "My Subnet Group"
   }
 }

# # CREATING DATA-BASE INSTANCE ----------------------------------------------------------------------------------------------------------------

#  resource "aws_db_instance" "Three-Tier_RDS-Instance" {
#    allocated_storage     = 50
#    max_allocated_storage = 100
#    engine                = "mysql"
#    engine_version        = "5.7"
#    multi_az              = true
#    instance_class        = "db.t3.small"
#    db_name               = "mydb"
#    username              = "admin"
#    password              = "password"

#    vpc_security_group_ids              = var.RDS_Security_Group_id
#    storage_encrypted                   = true
#    db_subnet_group_name                = aws_docdb_subnet_group.Subnet-Group.id
#    iam_database_authentication_enabled = true
#    skip_final_snapshot                 = true

#  }