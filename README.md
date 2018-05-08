
IP Engineering Rescue Disk
==========================

The IP Egineering Rescue Disk is not a disk or set of disks, but rather
a framework which allows an administrator to download collections of boot
images for packaging into either bootable ISO images, bootable USB pen drives,
or network shares for PXE booting.


Table of Contents
-----------------

   * Disclaimer
   * Maintainers
   * Quick Start
   * Directory Structure
     * Distro Definition
   * Compatibility
   * Source Code


Disclaimer
==========

   This software is provided by the copyright holders and contributors "as
   is" and any express or implied warranties, including, but not limited to,
   the implied warranties of merchantability and fitness for a particular
   purpose are disclaimed. In no event shall David M. Syzdek be liable for
   any direct, indirect, incidental, special, exemplary, or consequential
   damages (including, but not limited to, procurement of substitute goods or
   services; loss of use, data, or profits; or business interruption) however
   caused and on any theory of liability, whether in contract, strict
   liability, or tort (including negligence or otherwise) arising in any way
   out of the use of this software, even if advised of the possibility of
   such damage.


Maintainers
===========

   David M. Syzdek
   david@syzdek.net


Requirements
============

Build requirements:

   * Bash shell
   * GNU Make
   * GNU Mtools
   * GNU GCC
   * wget
   * GNU Grub 2
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
   * `boot/<distro>/`         - Distribution images
   * `boot/grub/`             - Grub binaries and configurations
   * `doc/`                   - Additional documentation
   * `images/`                - Generated IPERD images
   * `src/distros/<distro>/`  - Distro definition
   * `src/grub/`              - Grub templates and build files
   * `src/scripts/`           - helper scripts
   * `src/syslinux/`          - Syslinux templates and build files
   * `tmp/`                   - Download and build cache
   * `var/config/`            - Configuration files


Distro Definition
-----------------

   * `./broken`             - existence indicates broken distro
   * `./broken.efi`         - existence indicates broken UEFI implementation
   * `./broken.iso`         - existence indicates broken ISO implementation
   * `./broken.pxe`         - existence indicates broken PXE implementation
   * `./broken.sys`         - existence indicates broken USB implementation
   * `./cfg.header`         - start of syslinux configuration
   * `./cfg.header.iso.efi` - start of grub configuration for UEFI ISO
   * `./cfg.label`          - default syslinux label template
   * `./cfg.label.iso`      - syslinux label template for ISO images
   * `./cfg.label.iso.efi`  - grub menuentry template for UEFI ISO images
   * `./cfg.label.pxe`      - syslinux label template for PXE labels
   * `./cfg.label.sys`      - syslinux label template for USB labels
   * `./cfg.footer`         - end of syslinux configuration
   * `./cfg.footer.iso.efi` - end of grub configuration for UEFI ISO
   * `./make.header`        - start of Makefile definitions for distro
   * `./make.boot`          - Makefile targets for distro
   * `./make.footer`        - end of Makefile definitions for distro
   * `./option`             - list of distro variants (single option)
   * `./options`            - list of distro variants (multiple options)


Compatibility
=============

    +-------------------+-----------------+-----------------+-----------------+
    |                   |     USB Boot    |     CD Boot     |     Net Boot    |
    |                   |   BIOS     UEFI |   BIOS     UEFI |   BIOS     UEFI |
    |    Boot Images    +-----------------+-----------------+-----------------+
    |                   |  32 |  64 |  64 |  32 |  64 |  64 |  32 |  64 |  64 |
    +--------------+----+-----+-----+-----+-----+-----+-----+-----+-----+-----+
    | Alpine Linux      |  Y  |  Y  |  N  |  N  |  N  |  N  |  N  |  N  |  N  |
    | Archboot          |  ?  |  ?  |  ?  |  ?  |  ?  |  ?  |  ?  |  ?  |  ?  |
    | CentOS Install    | n/a |  Y  |  Y  | n/a |  Y  |  Y  | n/a |  Y  |  Y  |
    | DBAN              |  Y  |  -  |  -  |  Y  |  -  |  -  |  -  |  -  |  -  |
    | Debian Install    |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |
    | Memtest86+        |  Y  |  -  |  -  |  Y  |  -  |  -  |  ?  |  -  |  -  |
    | Slackware Install |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |
    | SystemRescueCD    |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |
    | TinyCore          |  Y  | n/a | n/a |  Y  | n/a | n/a |  ?  | n/a | n/a |
    | Ubuntu Install    |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |  Y  |
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


