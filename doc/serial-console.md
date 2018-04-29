                    IP Engineering Rescue Disk Serial Cosole

Most boot images supported by IPERD contain support for serial consoles. In
most cases the serial console can be enabled by navigating to the desired image,
pressing the [TAB] key to edit the boot parameters, and appending the following:

        console=<device>,<speed>

The following are common devices and their speeds:

        console=tty0          - VGA console
        console=ttyS0         - com1 at 9600 baud
        console=ttyS1,57600   - com2 at 57,600 baud (Dell iDRAC/IPMI)
        console=ttyS2,115200  - com2 at 115,200 baud (SuperMicro IPMI)

Multiple consoles may be specified. The last console specified will be used for
/dev/console (i.e. userspace). The following is an example of two consoles:

        console=tty0 console=ttyS1,115200

The filw 'admin-guide/serial-console.rst' in the Linux kernel documentation
contains more detailed information.

