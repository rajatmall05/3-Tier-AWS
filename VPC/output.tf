# SUBNET iD FOR DATABASE

output "RDS_Subnet_id" {
    value = [aws_subnet.Private-DB-Subnet-AZ1.id, aws_subnet.Private-DB-Subnet-AZ2.id]
}

# VPC SUCURITY GROUP ID FOR DATABASE

output "RDS_Security_Group_id" {
    value = [aws_security_group.DBMS-sg.id]
}

############################################################################################################################

# VPC SECURITY GROUP FOR PRIVATE EC2

output "Private_EC2_Security_Group_id" {
    value = [aws_security_group.Private-EC2-sg.id]
}

# VPC PRIVATE SUBNET AZ1

output "Private_Subnet_AZ1_id" {
    value = aws_subnet.Private-Subnet-AZ1.id
}

# VPC PRIVATE SUBNET AZ2

output "Private_Subnet_AZ2_id" {
    value = aws_subnet.Private-Subnet-AZ2.id
}

# VPC SECURITY GROUP FOR PUBLIC EC2

output "Public_EC2_Security_Group_id" {
    value = [aws_security_group.Public-EC2-sg.id]
}

# VPC PUBLIC SUBNET AZ1

output "Public_Subnet_AZ1_id" {
    value = aws_subnet.Public-Subnet-AZ1.id
}

##################################################################################################################################

# INTERNAL LOAD BALANCER SG

output "Inter-LB-SG_id" {
    value = aws_security_group.Internal-Load-Balancer-sg.id
}

# EXTERNAL LOAD BALANCER SG

output "External-LB-SG_id" {
    value = aws_security_group.External-Load-Balancer-sg.id
}

# VPC ID

output "VPC-id" {
    value = aws_vpc.Three-Tier-VPC-Test.id
}