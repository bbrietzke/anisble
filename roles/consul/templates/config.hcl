# Fullconfiguration options can be found at https://www.consul.io/docs/agent/options.html

# datacenter
# This flag controls the datacenter in which the agent is running. If not provided,
# it defaults to "dc1". Consul has first-class support for multiple datacenters, but
# it relies on proper configuration. Nodes in the same datacenter should be on a
# single LAN.
datacenter = "{{ consul_datacenter | lower }}"

# data_dir
# This flag provides a data directory for the agent to store state. This is required
# for all agents. The directory should be durable across reboots. This is especially
# critical for agents that are running in server mode as they must be able to persist
# cluster state. Additionally, the directory must support the use of filesystem
# locking, meaning some types of mounted folders (e.g. VirtualBox shared folders) may
# not be suitable.
data_dir = "{{ consul_data_dir }}"


# ui
# Enables the built-in web UI server and the required HTTP routes. This eliminates
# the need to maintain the Consul web UI files separately from the binary.
# Version 1.10 deprecated ui=true in favor of ui_config.enabled=true
#ui_config {
#  enabled = {{ consul_ui | lower}}
#}

# server
# This flag is used to control if an agent is in server or client mode. When provided,
# an agent will act as a Consul server. Each Consul cluster must have at least one
# server and ideally no more than 5 per datacenter. All servers participate in the Raft
# consensus algorithm to ensure that transactions occur in a consistent, linearizable
# manner. Transactions modify cluster state, which is maintained on all server nodes to
# ensure availability in the case of node failure. Server nodes also participate in a
# WAN gossip pool with server nodes in other datacenters. Servers act as gateways to
# other datacenters and forward traffic as appropriate.
server = {{ consul_server | lower }}

# Bind addr
# You may use IPv4 or IPv6 but if you have multiple interfaces you must be explicit.
bind_addr = "[::]" # Listen on all IPv6
bind_addr = "0.0.0.0" # Listen on all IPv4

node_name = "{{ ansible_hostname | lower }}"
{% if consul_server %}
bootstrap_expect = 3
{% endif %}


retry_join = ["10.0.0.160", "10.0.0.109", "10.0.0.207"]