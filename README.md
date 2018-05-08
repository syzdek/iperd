
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
   * Configuring and Downloading Images
   * Creating Images
     * Bootable ISO Images
     * Bootable Disk Images
     * Bootable USB Pen Drives


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


Quick Start
===========

   Configure images and disk options:

       make configure

   Download files:

       make download

   Make disk ISO and USB images in `images/`:

       make images

   Make bootable USB thumbdrive:

       make thumbdrive DISK=/dev/sdX


Directory Structure
===================

   * boot/<distro>/<ver>/<arch>
   * docs/
   * images/
   * src/distros/<distro>/broken.efi
   * src/distros/<distro>/cfg.footer
   * src/distros/<distro>/cfg.header
   * src/distros/<distro>/cfg.label
   * src/distros/<distro>/cfg.label.iso
   * src/distros/<distro>/cfg.label.pxe
   * src/distros/<distro>/cfg.label.sys
   * src/distros/<distro>/make.boot
   * src/distros/<distro>/make.footer
   * src/distros/<distro>/make.header
   * src/distros/<distro>/option
   * src/distros/<distro>/options
   * src/scripts/
   * src/syslinux
   * tmp/
   * var/config/


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


Configuring and Downloading Images
==================================

To be written.


Creating Images
===============

To be written.


Creating Images: Bootable ISO Images
------------------------------------

To be written.


Creating Images: Bootable Disk Images
-------------------------------------

To be written.


Creating Images: Bootable USB Pen Drives
----------------------------------------

To be written.


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


