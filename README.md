
IP Engineering Rescue Disk
==========================

Overview
--------

IP Engineering Rescue Disk (IPERD) is a framework for creating boot
environments capable of booting the installers and utilities of multiple
releases of multiple Linux distributions.  The primary goal of IPED is to ease
the burden on system administrators and enthusiasts when they need to boot
the installer or rescue tools for a Linux distribution which they run.

The IPERD framework can be used to create a PXE boot environment or bootable
ISO image.  The bootable ISO image can be either burned to a CDR or written to
a USB thumb drive.

The IP Engineering Rescue Disk is capable of booting multiple versions of the
following Linux distributions:

   * Alpine Linux
   * Debian Linux
   * Fedora Linux
   * Rocky Linux
   * Slackware Linux
   * Ubuntu Linux


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
    |                   +-----------+-----+-----------+-----+-----------+-----+
    |    Boot Images    |   BIOS    | EFI |   BIOS    | EFI |   BIOS    | EFI |
    |                   +-----------+-----+-----------+-----+-----------+-----+
    |                   |  32 |  64 |  64 |  32 |  64 |  64 |  32 |  64 |  64 |
    +-------------------+-----+-----+-----+-----+-----+-----+-----+-----+-----+
    | Alpine Linux      |  ?  |  ?  |  ?  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |
    | Arch Linux        |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | Debian Linux      |  ?  |  ?  |  ?  |  ?  |  ?  |  ?  |  ?  |  Y  |  Y  |
    | Fedora Linux      |  -  |  ?  |  ?  |  -  |  Y  |  Y  |  -  |  Y  |  Y  |
    | Gentoo Linux      |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | openSUSE          |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | Rocky Linux       |  -  |  ?  |  ?  |  -  |  Y  |  Y  |  -  |  Y  |  Y  |
    | Slackware Linux   |  ?  |  ?  |  ?  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |
    | Ubuntu Linux      |  ?  |  ?  |  ?  |  ?  |  ?  |  ?  |  Y  |  Y  |  Y  |
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


