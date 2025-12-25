variable "project" {
  default = "roboshop"
}
variable "environment" {
  default = "dev"
}
variable "sg_name" {
  default = ["mysql", "redis", "rabbitmq", "mongodb",
    "bastion",
    "ingress_alb", 
    # "frontend",
    # "backend_alb",
  # "catalogue", "user", "cart", "shipping", "payment"
  eks_control_plane,
  eks_node
  ]
}
