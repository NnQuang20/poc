resource "aws_vpc" "NnQ" { 
  cidr_block       = var.vpc_cidr 

  instance_tenancy = "default" 
 
  tags = { 
    Name = "NnQ_vpc" 
  } 
} 

resource "aws_subnet" "NnQ" { 
  vpc_id     = aws_vpc.NnQ.id 
  cidr_block = var.subnet_cidr 
  tags = { 
    Name = "NnQ_subnet" 
  } 
} 

 #instance 

resource "aws_instance" "server" { 

  ami           = "ami-0801a1e12f4a9ccc0" 
  instance_type = "t2.micro" 
  subnet_id     = aws_subnet.NnQ.id 
  vpc_security_group_ids = [aws_security_group.NnQ_sg.id]
  associate_public_ip_address = true
  tags = { 
    Name = "Server" 
  } 

}
#keypair
resource "aws_key_pair" "NnQ" {
key_name = "nqkey"
public_key = "${file("~/.ssh/id_rsa.pub")}"
} 
#sec_group
resource "aws_security_group" "NnQ_sg" { 

  name = "NnQ_sg"

  vpc_id = aws_vpc.NnQ.id 

ingress { 
    from_port        = 22 
    to_port          = 22 
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  } 

egress { 
    from_port        = 8080 
    to_port          = 8080 
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"] 
  } 

tags = { 
    Name = "NnQ_sg" 
  } 

} 
