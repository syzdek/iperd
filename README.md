
IP Engineering Rescue Disk
==========================

Copyright
=========

IP Engineering Rescue Disk  
Copyright (C) 2026 David M. Syzdek <david@syzdek.net>.  
All rights reserved.  

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are
met:

   * Redistributions of source code must retain the above copyright
     notice, this list of conditions and the following disclaimer.
   * Redistributions in binary form must reproduce the above copyright
     notice, this list of conditions and the following disclaimer in the
     documentation and/or other materials provided with the distribution.
   * Neither the name of David M. Syzdek nor the
     names of its contributors may be used to endorse or promote products
     derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL DAVID M. SYZDEK BE LIABLE FOR
ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
SUCH DAMAGE.


Overview
========

The IP Egineering Rescue Disk is not a disk or set of disks, but rather
a framework which allows an administrator to download collections of boot
images for packaging into either bootable ISO images, bootable USB pen drives,
or network shares for PXE booting.


Maintainers
===========

* David M. Syzdek <david@syzdek.net>


Requirements
============

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


Quick Start
===========

   Configure images and disk options:

       make configure

   Download files:

       make download

   Make ISO image and USB images in `images/`:

       make images

   Make bootable USB thumbdrive:

       make thumbdrive DISK=/dev/sdX


Directory Structure
===================

   * `EFI/BOOT/`              - UEFI boot files
   * `boot/`                  - Boot images
   * `doc/`                   - Additional documentation
   * `images/`                - Generated IPERD images
   * `src/distros/<distro>/`  - Distro build/configuration files
   * `src/`                   - Source files/packages


Compatibility
=============

    +-------------------+-----------------+-----------------+-----------------+
    |                   |     USB Boot    |     CD Boot     |     Net Boot    |
    |                   |   BIOS     UEFI |   BIOS     UEFI |   BIOS     UEFI |
    |    Boot Images    +-----------------+-----------------+-----------------+
    |                   |  32 |  64 |  64 |  32 |  64 |  64 |  32 |  64 |  64 |
    +-------------------+-----+-----+-----+-----+-----+-----+-----+-----+-----+
    | Alpine Linux      |  N  |  N  |  N  |  N  |  N  |  N  |  Y  |  Y  |  Y  |
    | Arch Linux        |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | Debian Linux      |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | Gentoo Linux      |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | openSUSE          |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | Rocky Linux       |  N  |  N  |  N  |  N  |  N  |  N  |  Y  |  Y  |  Y  |
    | Slackware Linux   |  N  |  N  |  N  |  N  |  N  |  N  |  Y  |  Y  |  Y  |
    | TinyCore          |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    | Ubuntu Linux      |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |  -  |
    +-------------------+-----+-----+-----+-----+-----+-----+-----+-----+-----+


Source Code
===========

   The source code for this project is maintained using git
   (http://git-scm.com).  The following contains information to checkout the
   source code from the git repository.

   Browse Source:

      https://github.com/syzdek/iperd

   Downloading Source:

      $ git clone https://github.com/syzdek/iperd.git

   Preparing Source:

      $ cd iperd
      $ make configure

   Git Branches:

      master - Current release of packages.
      next   - changes staged for next release
      pu     - proposed updates for next release
      xx/yy+ - branch for testing new changes before merging to 'pu' branch


