##
# No defaults
variable deploy_region {
  type        = string
  description = "Openstack region to deploy into"
}

variable deploy_public_key {
  type        = string
  description = "Openssh format public key"
}

variable external_network_name {
  type        = string
  description = "Name of external facing Openstack network"
}

variable deploy_image_name {
  type        = string
  description = "Name of pre-existing image in Openstack"
}

variable deploy_flavor_name {
  type        = string
  description = "Name of Openstack flavor to provision"
}

variable cluster_name {
  type        = string
  description = "Name of cluster to deploy"
}

##
# Initialization
variable manager_user_data {
  type        = string
  description = "Init blob"
  default     = ""
}

variable worker_user_data {
  type        = string
  description = "Init blob"
  default     = ""
}

##
# Networking
variable internal_cidr {
  type        = string
  description = "Network for private communication"
  default     = "192.168.1.0/24"
}

variable google_dns {
  type        = list
  description = "DNS servers to use by default"
  default     = [
    "8.8.8.8",  # google-public-dns-a.google.com
    "8.8.4.4"   # google-public-dns-b.google.com
  ]
}

variable security_group_ids {
  type        = list
  description = "List of security group ids"
  default     = []
}

##
# Scaling
variable number_of_workers {
  type        = number
  description = "Number of worker VMs to create"
  default     = 2
}
