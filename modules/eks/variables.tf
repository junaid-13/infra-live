
variable "cluster_name" {
  type = string
}

variable "version" {
  type = string
}

variable "subnet_ids" {
  type = list(string)
}

variable "tags" {
  type = map(string)
  default = {}
}

variable "instance_types" {
  type = list(string)
  default = ["t3.medium"]
}

variable "capacity_type" {
  type = string
  default = "SPOT"
}

variable "desired_size" {
  type = number
  default = 2
}

variable "min_size" {
  type = number
  default = 1
}

variable "max_size" {
  type = number
  default = 4 
}