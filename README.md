
IP Engineering Rescue Disk
==========================

Overview
--------

The IP Egineering Rescue Disk is not a disk or set of disks, but rather
a framework which allows an administrator to download collections of boot
images for packaging into either bootable ISO images, bootable USB pen drives,
or network shares for PXE booting.


Requirements
------------

Build requirements:

   * Bash shell
   * GNU Make
   * GNU Mtools
   * GNU GCC
   * wget
   * bsdtar
   * cdrtools

Network boot requirements:

   * DHCP Server (dnsmasq configuration included)
   * TFTP Server (dnsmasq configuration included)
   * HTTP Server (busybox httpd widget instructions included)


Compatibility
-------------

    +-------------------+-----------------+-----------------+-----------------+
    |                   |     USB Boot    |     CD Boot     |     Net Boot    |
    |                   |   BIOS     UEFI |   BIOS     UEFI |   BIOS     UEFI |
    |    Boot Images    +-----------------+-----------------+-----------------+
    |                   |  32 |  64 |  64 |  32 |  64 |  64 |  32 |  64 |  64 |
    +-------------------+-----+-----+-----+-----+-----+-----+-----+-----+-----+
    | Alpine Linux      |  ?  |  ?  |  ?  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |
    | Arch Linux        |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | Debian Linux      |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | Fedora Linux      |  -  |  ?  |  ?  |  -  |  Y  |  Y  |  -  |  Y  |  Y  |
    | Gentoo Linux      |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | openSUSE          |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | Rocky Linux       |  -  |  ?  |  ?  |  -  |  Y  |  Y  |  -  |  Y  |  Y  |
    | Slackware Linux   |  ?  |  ?  |  ?  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |
    | Ubuntu Linux      |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    +-------------------+-----+-----+-----+-----+-----+-----+-----+-----+-----+


Source Code
-----------

The source code for this project is maintained using git (http://git-scm.com).
The following contains information to checkout the source code from the git
repository.

Browse Source:

      https://github.com/syzdek/iperd

Downloading Source:

      $ git clone https://github.com/syzdek/iperd.git

Preparing Source:

      $ cd iperd
      $ make update

Git Branches:

      master - Current release of packages.
      next   - changes staged for next release
      pu     - proposed updates for next release
      xx/yy+ - branch for testing new changes before merging to 'pu' branch


