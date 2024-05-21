variable "ports" {
  type = list(number)

}

variable "imageid" {
  type = string

}

variable "instancetype" {
  type = string
}

variable "instance_name" {
  type = string
}

variable "keyname" {
  type = string
}

variable "cidr_block" {
  type = list(string)

}
