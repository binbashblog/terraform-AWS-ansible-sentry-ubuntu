// key pair to inject into the instance
resource "aws_key_pair" "mykey" {
	key_name	= "MyKeyPair"
	public_key	= "${file(var.ssh_pub_key_path)}"
}

resource "aws_instance" "terraform-aws-ansible-sentry-ubuntu" {
	#ami		= "${lookup(var.AMIS, var.aws_region)}"
	ami		= "${var.ami}"
	instance_type	= "${var.instance}"
	key_name	= "${aws_key_pair.mykey.key_name}"

    	vpc_security_group_ids = [
	  "${aws_security_group.web.id}",
          "${aws_security_group.ssh.id}",
          "${aws_security_group.egress-tls.id}",
          "${aws_security_group.ping-ICMP.id}",
        ]

    connection {
        host              = "${self.public_ip}"
	user              = "${var.ssh_username}"
	private_key       = "${file(var.ssh_pri_key_path)}"
    }

    // Update the system, ensure python is installed and set the hostname
    provisioner "remote-exec" {
	inline = [
	  "sudo apt-get update",
          "sudo apt-get -y upgrade",
          "sudo apt-get -y install python3",
          "sudo hostnamectl set-hostname ${var.instance_name_fqdn}",
          "sudo sed -i 's/127.0.0.1.*/127.0.0.1\t${var.instance_name_fqdn}\t${var.instance_name}/' /etc/hosts",
	  "sudo sed -i '/127.0.0.1.*/a ${self.public_ip}\t${var.instance_name_fqdn}\t${var.instance_name}/' /etc/hosts"
        ]
    }

    // Run ansible-playbook to configure the instance
    provisioner "local-exec" {
	command = "ansible-playbook -u ${var.ssh_username} -i '${self.public_ip},' --private-key ${var.ssh_pri_key_path} ${var.ansible_playbook_name}"
    }

}

// Define networking
resource "aws_security_group" "web" {
	name		= "default-web-example"
	description 	= "Security group for web that allows web traffic from internet"
	#vpc_id      	= "${aws_vpc.my-vpc.id}"

  ingress {
	from_port   	= 443
	to_port     	= 443
	protocol    	= "tcp"
	cidr_blocks 	= ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ssh" {
	name		= "default-ssh-example"
	description 	= "Security group for nat instances that allows SSH and VPN traffic from internet"
	#vpc_id      	= "${aws_vpc.my-vpc.id}"

  ingress {
	from_port   	= 22
	to_port     	= 22
	protocol    	= "tcp"
	cidr_blocks 	= ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "egress-tls" {
	name        	= "default-egress-tls-example"
	description 	= "Default security group that allows inbound and outbound traffic from all instances in the VPC"
	#vpc_id      	= "${aws_vpc.my-vpc.id}"

  egress {
	from_port   	= 0
	to_port     	= 0
	protocol    	= "-1"
	cidr_blocks 	= ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "ping-ICMP" {
	name        	= "default-ping-example"
	description 	= "Default security group that allows to ping the instance"
	#vpc_id      	= "${aws_vpc.my-vpc.id}"

  ingress {
	from_port      	    = -1
	to_port        	    = -1
	protocol       	    = "icmp"
	cidr_blocks    	    = ["0.0.0.0/0"]
	ipv6_cidr_blocks    = ["::/0"]
  }
}
