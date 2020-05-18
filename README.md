# terraform-docker-swarm
Deploy a set of vms for a docker swarm cluster into an Openstack project.

# Variables
The following variables do not have defaults and must be provided:
- `deploy_region`: Openstack region to deploy into
- `deploy_public_key`: Openssh format public key
- `external_network_name`: Name of external facing Openstack network
- `deploy_image_name`: Name of pre-existing image in Openstack
- `deploy_flavor_name`: Name of Openstack flavor to provision
- `cluster_name`: Name of cluster to deploy

The following variables are pre-defined with defaults:
- `number_of_workers`: 2
- `manager_user_data`: ""
- `worker_user_data`: ""
