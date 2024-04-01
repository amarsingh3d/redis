variable "name" {
  default = "minikube"

}

variable "ports" {
  default = [80, 443]
}

variable "ssh-port" {
  default = 22

}


variable "cidr_blocks" {
  default = "103.69.14.12/32"

}

variable "instance_type" {
  default = "t3a.medium"

}
variable "volume_size" {
  description = "Volume size in GB"
  type        = number
  default     = 30

}

variable "volume_type" {
  description = "Details about volume"
  type        = string
  default     = "gp3"

}

variable "description" {
  type    = string
  default = "office IP"

}


variable "pub_key" {
  description = "Minikube pub key"
  type        = string
  default     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDPNmtkDbmcC8w38Ka015f3Li/Dvbt5S5fVojimmgo44n6An95tr0o+290J03NI5adwT5Y+3G1A3nYj8b7Vy1EymGmVnT98o/uFED/eddKU0k9Z1yCn2reFEoMud40uDCKoUvpb+RN6H8h1gF+ZNTTkhbLOKz5dVctq4TLQRC6v+H6ficTRsnyJMl1OUY/kypP7dfm6aYKps1Kfn7GV+pANqhVHrkBRG+bsHwmBdX2+peT/r2shC8GyWOj+fxcjO3VsEeOFaCD850KgoJqPM1E843sNMKk3n9bgnlQg8bMkqh3eHgiB96NYRsnfug9FDCFvYBFGP2xn6Xiqxega4Huy8bvMMxTSPcEgCI85kBrR9+rl5nkL4cmrR+eiCmGXiRMf6Czb1vJAA/TmWjIG2ZVqiA0DPf7/j/Z04zi8YFOE3q2EsuU8QoHeIjqOgvReUIdvukhyavM10ThldYiRH7LJ1rMt/QSiDYKOrrE+NzpsqShULvZ/N8Fwrcc5bmzQoQM= root@ISHLTP95"

}

variable "instance_count" {
  description = "Set the no of instances"
  type        = number
  default     = "1"

}

