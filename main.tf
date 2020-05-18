resource openstack_compute_keypair_v2 deploy {
  name       = var.cluster_name
  region     = var.deploy_region
  public_key = var.deploy_public_key
}

resource openstack_networking_router_v2 external {
  name                = var.cluster_name
  region              = var.deploy_region
  external_network_id = data.openstack_networking_network_v2.external.id
}

resource openstack_networking_network_v2 internal {
  name   = var.cluster_name
  region = var.deploy_region
}

resource openstack_networking_subnet_v2 internal {
  name            = var.cluster_name
  region          = var.deploy_region
  network_id      = openstack_networking_network_v2.internal.id
  cidr            = var.internal_cidr
  dns_nameservers = var.google_dns
}

resource openstack_networking_router_interface_v2 external {
  region    = var.deploy_region
  router_id = openstack_networking_router_v2.external.id
  subnet_id = openstack_networking_subnet_v2.internal.id
}

resource openstack_compute_secgroup_v2 admin {
  name        = "admin"
  region      = var.deploy_region
  description = "Admin rules for ${var.cluster_name} application"

  rule {
    from_port   = -1
    to_port     = -1
    ip_protocol = "icmp"
    cidr        = "0.0.0.0/0"
  }

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

}

resource openstack_networking_port_v2 manager {
  name               = "${var.cluster_name}_manager"
  network_id         = openstack_networking_network_v2.internal.id
  admin_state_up     = true
  region             = var.deploy_region
  security_group_ids = concat([openstack_compute_secgroup_v2.admin.id], var.security_group_ids)

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.internal.id
  }
}

resource openstack_compute_instance_v2 manager {
  name        = "${var.cluster_name}_manager"
  region      = var.deploy_region
  image_id    = data.openstack_images_image_v2.default.id
  flavor_name = var.deploy_flavor_name
  key_pair    = openstack_compute_keypair_v2.deploy.name
  user_data   = var.manager_user_data

  network {
    port = openstack_networking_port_v2.manager.id
  }
}

resource openstack_networking_floatingip_v2 gateway {
  region = var.deploy_region
  pool   = data.openstack_networking_network_v2.external.name
}

resource openstack_compute_floatingip_associate_v2 gateway {
  region      = var.deploy_region
  floating_ip = openstack_networking_floatingip_v2.gateway.address
  instance_id = openstack_compute_instance_v2.manager.id
}

resource openstack_networking_port_v2 worker {
  count          = var.number_of_workers
  name           = "${var.cluster_name}_worker_${count.index}"
  network_id     = openstack_networking_network_v2.internal.id
  admin_state_up = true
  region         = var.deploy_region

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.internal.id
  }
}

resource openstack_compute_instance_v2 worker {
  count       = var.number_of_workers
  name        = "${var.cluster_name}_worker_${count.index}"
  region      = var.deploy_region
  image_id    = data.openstack_images_image_v2.default.id
  flavor_name = var.deploy_flavor_name
  key_pair    = openstack_compute_keypair_v2.deploy.name
  user_data   = var.worker_user_data

  network {
    port = openstack_networking_port_v2.worker[count.index].id
  }
}
