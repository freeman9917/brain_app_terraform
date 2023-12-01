variable "vpc_id" {
    type = string
    default = ""
}

variable "private_subnets" {
    type = list
}

variable env_prefix {
    type = string
    default = ""
}