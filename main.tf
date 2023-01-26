provider "aws" {
        access_key = "============================="
        secret_key = "============================"
        region = "ap-south-1"
}
resource "aws_instance" "dev_Ins" {
        ami = "ami-0f9d9a251c1a44858"
        instance_type = "t2.micro"
        key_name = "KeyPairJan2022"
        subnet_id = "subnet-06e3260c3cdca46d6"
        vpc_security_group_ids = ["sg-0d23fef751c6f316a"]

        tags = {
                Name = "Dev_Inst"
		}
        connection {
                type = "ssh"
                host = aws_instance.dev_Ins.public_ip
                user = "ec2-user"
                private_key = "${file("KeyPairJan2022.pem")}"
                agent = false
                timeout = "300s"
        }
        provisioner "remote-exec" {
                inline = [
                "sudo yum update -y",
                "sudo yum install -y httpd",
		"sudo systemctl start httpd",
		"sudo systemctl enable httpd"	
                ]



        }

}

output "dev_Ins_ip" { value = aws_instance.dev_Ins.public_ip }
