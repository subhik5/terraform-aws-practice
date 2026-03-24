#key pair we add key-pair in this =
resource "aws_key_pair" "my_key" {
    key_name = "terra-key-ec2"
    public_key = file("terra-key-ec2.pub")
}

#vpc & security group
resource aws_default_vpc default {
}

# security group 
resource aws_security_group my_security_group {
    name = "automate-sg"
    description = "this will add a TF generated security group"
    vpc_id = aws_default_vpc.default.id #interpolation 

# inbound rules
ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "open 22 port"

}

ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "http open"
}

# outbound rules
egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "allow all"
}
    tags = {
        Name = "automate=sg"
    }
}

#ec2 instance using all resources

resource "aws_instance" "my_instance" {
    for_each = tomap({
        ec2-1-automate = "t2.micro"
        ec2_2-automate = "t2.medium"
    })

    depends_on = [ aws_security_group.my_security_group, aws_key_pair.my_key ]
    key_name = aws_key_pair.my_key.key_name  #interpolation
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = each.value              #var.ec2_instance_type
    ami = var.ec2_ami_id  #ubuntu
    user_data = file("install_nginx.sh")

    root_block_device {
        volume_size = var.env == "prod" ? 20 : var.ec2_default_root_storage_size #volume_size = var.ec2_root_storage_size
        volume_type = "gp3"
    }
    tags = {
      Name = each.key                 #Name = "ec2-automate"
    }
}
