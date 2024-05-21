resource "aws_instance" "web" {
  ami                    = var.imageid
  instance_type          = var.instancetype
  key_name               = aws_key_pair.tf-key.key_name
  vpc_security_group_ids = ["${aws_security_group.allow_tls.id}"]
  tags = {
    Name = var.instance_name
  }
  user_data = file("${path.module}/userdata.sh")

  provisioner "file" {
    source      = "flask.html"
    destination = "/tmp/flask.html"
    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = file("${path.module}/id_rsa")
      host        = self.public_ip
    }
  }
}




