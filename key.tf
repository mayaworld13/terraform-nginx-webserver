resource "aws_key_pair" "tf-key" {
  key_name   = var.keyname
  public_key = file("${path.module}/id_rsa.pub")
}