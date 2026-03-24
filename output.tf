#output for count with = [*]
#  output "ec2_public_ip" {
#      value = aws_instance.my_instance[*].public_key
#  }

#  output "ec2_public_dns" {
#     value = aws_instance.my_instance[*].public_dns
#  }

#  output "ec2_private_ip" {
#     value = aws_instance.my_instance[*].private_ip
#  }
# [*] = used for 2 and more instance or type, ip etc.


# Output for for_each=

output "ec2_public_ip" {
    value = [
        for instance in aws_instance.my_instance : instance.public_ip
    ]
}