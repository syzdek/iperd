
IP Engineering Rescue Disk: Configuration
=========================================


GRUB Configuration Options
--------------------------

    #
    # GRUB options
    GRUB_SERIAL_DEV=0
    GRUB_SERIAL_BAUD=115200
    GRUB_USE_GFXTERM=n
    GRUB_TERM=vt100-color
    GRUB_TERM_GEOMETRY=80x24
    GRUB_TERM_UTF8=y


GRUB Linux Kernel Options
-------------------------

    #
    # Linux kernel options
    LINUX_CONSOLE=tty0


IPERD Configuration Options
---------------------------

    #
    # IPERD
    IPERD_RUNTIME_SETUP=y
    IPERD_RUNTIME_NOTICE=y
    IPERD_DIR_DISK=
    IPERD_DIR_NET=/httpboot
    IPERD_PROGRESS=y
    IPERD_VERBOSE=y
    IPERD_DEBUG=n
    IPERD_NET=y
    IPERD_NET_CARD=any
    IPERD_NET_IP=dhcp
    IPERD_NET_GW=
    IPERD_NET_VLAN=0
    IPERD_NET_DNS=8.8.8.8


Example Linux Distribution Options
----------------------------------

    #
    # Xxxxxx Linux
    DISTRO_XXXXXX=y
    DISTRO_XXXXXX_URL=https://mirrors.example.org/xxxxxx
    DISTRO_XXXXXX_REPO=
    DISTRO_XXXXXX_GRUB=(http,mirrors.example.org)/xxxxxx
    DISTRO_XXXXXX_APPEND=
    DISTRO_XXXXXX_DOWNLOAD_REPO=
    DISTRO_XXXXXX_DOWNLOAD_APPEND=
    DISTRO_XXXXXX_EXTRA_URL=
    DISTRO_XXXXXX_EXTRA_APPEND=
    DISTRO_XXXXXX_LOCAL_URL=http://10.0.109.249/xxxxxx
    DISTRO_XXXXXX_LOCAL_REPO=
    DISTRO_XXXXXX_LOCAL_GRUB=(http,10.0.109.249)xxxxxx
    DISTRO_XXXXXX_LOCAL_APPEND=
    DISTRO_XXXXXX_NNN_x86=n
    DISTRO_XXXXXX_NNN_x8664=n
    DISTRO_XXXXXX_NNN_x86=n
    DISTRO_XXXXXX_NNN_x8664=n
    DISTRO_XXXXXX_NNN_x86=n
    DISTRO_XXXXXX_NNN_x8664=n
    DISTRO_XXXXXX_NNN_x86=n
    DISTRO_XXXXXX_NNN_x8664=n

