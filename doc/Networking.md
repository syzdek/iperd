
IP Engineering Rescue Disk: Networking
======================================

The IP Engineering Rescue Disk (IPERD) requires network access to boot most
distribution configurations.  IPERD will attempt to configure network access
using DHCP.  If DHCP fails, the network can be manually configured using the
GRUB CLI.


Configure Network with DHCP
---------------------------

The command "net_dhcp" can be used to configure a specific network card or
any network card using DHCP.

Configure all network cards using DHCP:

    grub> net_dhcp
    error: ../../grub-core/net/bootp.c:grub_cmd_bootp:911:couldn't autoconfigure efinet1.
    grub> net_ls_addr
    efinet0:dhcp 00:16:3e:88:6c:e0 10.0.109.169 
    grub>

Configure specific network card "efinet0" using DHCP:

    grub> net_dhcp efinet0
    grub> net_ls_addr
    efinet0:dhcp 00:16:3e:88:6c:e0 10.0.109.169
    grub>


Configure Network with Static Address
-------------------------------------

These instructions will configure the network using the following information:

   * Network Interface: eth0
   * Network Card:      efinet0
   * IP Address:        10.0.109.247/25
   * Default Route:     10.0.109.254

To manually configure the network, enter the GRUB CLI by pressing 'C'.

Determine the list of available network interfaces using 'net_ls_cards':

    grub> net_ls_cards
    efinet1 00:16:3e:88:6c:e1
    efinet0 00:16:3e:88:6c:e0
    grub>

Configure a DNS server:

    grub> net_add_dns 10.0.109.254
    grub>

Add a static IP address:

    grub> net_add_addr eth0 efinet0 10.0.109.247
    grub>

Replace local link routing with correct local link routing for the subnet:

    grub> net_del_route eth0:local
    grub> net_add_route eth0:local 10.0.109.128/25 eth0
    grub>

Add default route:

    grub> net_add_route default 0.0.0.0/0 eth0 gw 10.0.109.254
    grub>


View Network Information
------------------------

List available network cards:

    grub> net_ls_cards
    efinet1 00:16:3e:88:6c:e1
    efinet0 00:16:3e:88:6c:e0
    grub>

List configured IP addresses:

    grub> net_ls_addr
    eth0 ac:1f:6b:36:70:60 10.0.109.247
    grub>

List configured routes:

    grub> net_ls_routes
    default 0.0.0.0/0 eth0
    eth0:local 10.0.109.128/25 eth0
    grub>

List configured DNS servers:

    grub> net_ls_dns
    10.0.109.254 (prefer ipv4)
    grub>

