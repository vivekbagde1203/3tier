variable "vpc_cidr" {
}

variable "public-subnet" {
  type = list
}

variable "private-subnet" {
  type = list
}

variable "db-private-subnet" {
  type = list
}
variable "az" {
  type = list
  default = ["ap-south-1a","ap-south-1b"]
}

