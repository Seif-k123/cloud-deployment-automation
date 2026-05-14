resource "aws_security_group" "devops_sg" {
  name = "devops-sg"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "devops_server" {
  ami           = "ami-091138d0f0d41ff90"
  instance_type = var.instance_type

  key_name = "my-keypair"

  vpc_security_group_ids = [aws_security_group.devops_sg.id]

  tags = {
    Name = "devops-server"
  }
}
resource "local_file" "inventory" {
  filename = "${path.module}/../ansible/inventory.ini"

  content = templatefile("${path.module}/../ansible/inventory.tpl", {
    app_ip   = aws_instance.devops_server.public_ip
    key_path = "~/.ssh/my-keypair.pem"
  })
}
