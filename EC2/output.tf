output "Private-EC2-id"{
    value = aws_instance.Private-Instance-1.ami
}

output "Public-EC2-id"{
    value = aws_instance.Public-Instance-2.ami
}