module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0" #this is module version

  #refer to below
  #https://github.com/terraform-aws-modules/terraform-aws-eks?tab=readme-ov-file#eks-managed-node-group


  name               = local.common_name_suffix
  kubernetes_version = "1.29"

  # access_entries = {
  #   terraform-admin = {
  #     principal_arn = "arn:aws:iam::131676642204:user/shell-scripting"
  #     policy_associations = {
  #       admin = {
  #         policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
  #         access_scope = {
  #           type = "cluster"
  #         }
  #       }
  #     }
  #   }
  # }

  addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
    metrics-server = {}
  }

  # Optional
  endpoint_public_access = false

  # Optional: Adds the current caller identity as an administrator via cluster access entry
  enable_cluster_creator_admin_permissions = true

  vpc_id                   = local.vpc_id
  subnet_ids               = local.private_subnets_array
  control_plane_subnet_ids = local.private_subnets_array
  create_security_group = false
  create_node_security_group = false
  node_security_group_id = local.eks_node_sg_id
  security_group_id = local.eks_control_plane_sg_id

  # EKS Managed Node Group(s)
  eks_managed_node_groups = {
    blue = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m7i-flex.large"] 
      # instance_types = ["t3.micro"]  - addons are not installed 
      # instance_types = ["m5.xlarge"]
      iam_role_additional_policies={
        amazonEBS= "arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy"
        amazonEFS = "arn:aws:iam::aws:policy/service-role/AmazonEFSCSIDriverPolicy"
      }
#cluster node autoscaling
      min_size     = 2
      max_size     = 10
      desired_size = 2
    }
  }

  tags = merge(

    local.common_tags,
    {
      Name = "${local.common_name_suffix}-EKS-resource"
    }
  )
}
