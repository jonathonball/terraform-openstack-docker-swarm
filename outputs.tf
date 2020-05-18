data openstack_networking_network_v2 external {
  region = var.deploy_region
  name   = var.external_network_name
}

data openstack_images_image_v2 default {
  name        = var.deploy_image_name
  region      = var.deploy_region
  most_recent = true
}
