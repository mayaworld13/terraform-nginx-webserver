
![image](https://github.com/mayaworld13/terraform-nginx-webserver/assets/127987256/602e7344-f123-42a2-a518-117211a21cdd)

#  Steps for configuring webserver
1. create key for launching instance
2. create security inbound and outbound rule
3. adding userdata script for configuring webserver to the instance
4. use provisioner to transfer the file
5. launch the instance


# IAC Steps for Configuring Web Server

This guide provides a step-by-step process for configuring a web server using Infrastructure as Code (IAC) principles with Terraform.

### Prerequisites
Terraform installed on your local machine
AWS CLI configured with appropriate permissions
An existing SSH key pair (id_rsa.pub for the public key)

---

## Steps

### 1. Create a Key Pair for Launching Instance

First, create an AWS key pair to securely connect to your EC2 instances.

```hcl
resource "aws_key_pair" "tf-key" {
  key_name   = "devops_key"
  public_key = file("${path.module}/id_rsa.pub")
}
```

### Create Security Group with Inbound and Outbound Rules

Define a security group that allows inbound traffic on necessary ports (e.g., SSH, HTTP, HTTPS, MySQL, MongoDB).

```hcl
resource "aws_security_group" "allow_tls" {
  name        = "allow-traffic"
  description = "Allow TLS inbound traffic and all outbound traffic"

  dynamic "ingress" {
    for_each = var.ports
    iterator = port
    content {
      cidr_blocks = var.cidr_block
      from_port   = port.value
      protocol    = "tcp"
      to_port     = port.value

    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = var.cidr_block
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}
```

### Add User Data Script for Configuring Web Server

Include a user data script to install and configure NGINX on the instance at launch.

`userdata.sh`

```bash
#!/bin/bash
sudo apt-get update -y
sudo apt-get install nginx -y
sudo systemctl enable nginx --now
sudo echo "<h1> Hello Mayank </h1>" > /var/www/html/index.nginx-debian.html
sudo mv /tmp/flask.html /var/www/html/flask.html
```
```hcl
user_data = file("${path.module}/userdata.sh")
```

you can also use like this also

```hcl
user_data = <<-EOF
    #!/bin/bash
    sudo apt update
    sudo apt install nginx -y
    sudo echo "<h1>Hello Mayank</h1>" > /var/www/html/index.nginx-debian.html
  EOF
```

### Use Provisioner to Transfer Files

```hcl
resource "aws_instance" "web" {
  # ... previous configuration ...

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
```
![image](https://github.com/mayaworld13/terraform-nginx-webserver/assets/127987256/c98519a6-ce9c-4140-9b1d-0c1b69b41ab0)


### Launch the Instance

```hcl
# Initialize Terraform
terraform init

# format your Terraform configuration
terraform fmt

# Plan the changes
terraform plan

# Apply the configuration
terraform apply  --auto-approve
```

### provisioners
Provisioners are tools used in Terraform to execute scripts or commands on the resources it manages. They help automate tasks like installing software or configuring settings on newly created infrastructure.

There are three types of provisioners

1. `File provisioner`
The file provisioner in Terraform is used to copy files or directories from the local filesystem to a remote machine after a resource has been created. This provisioner is commonly used to transfer configuration files, scripts, or other necessary files to set up and configure resources like EC2 instances or virtual machines.

2. `Local-exec provisioner`
Executes commands on the machine running Terraform, typically used for tasks like running shell scripts or local commands.
 
      a. Typically used to store information of resource in local system <br>
      b. used to trigger a job in jenkins <br>
      c. userd to trigger a playbook 



3. `Remote-exec provisioner`
Connects to the newly created resource via SSH or WinRM and executes commands remotely. This is useful for tasks like installing software or configuring settings on remote machines.
   


