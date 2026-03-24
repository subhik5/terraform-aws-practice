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
    key_name = aws_key_pair.my_key.key_name  #interpolation
    security_groups = [aws_security_group.my_security_group.name]
    instance_type = "t2.micro"
    ami = "ami-0ec10929233384c7f"   #ubuntu

    root_block_device {
        volume_size = 15
        volume_type = "gp3"
    }
    tags = {
    Name = "ec2-automate"
    }
}
