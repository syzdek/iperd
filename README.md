
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


Directory Structure
===================

   * boot/<distro>/<ver>/<arch>
   * docs/
   * images/
   * src/distros/<distro>/options
   * src/distros/<distro>/make.header
   * src/distros/<distro>/make.boot
   * src/distros/<distro>/make.footer
   * src/scripts/
   * src/syslinux
   * tmp/
   * var/config/


Compatibility
=============

    +---------------------------+---------------+---------------+---------------+
    |                           |   USB Boot    |    CD Boot    |   Net Boot    |
    |        Boot Images        | BIOS     UEFI | BIOS     UEFI | BIOS     UEFI |
    |                           +---------------+---------------+---------------+
    |                           |x86|_64|x86|_64|x86|_64|x86|_64|x86|_64|x86|_64|
    +---------------------------+---+---+---+---+---+---+---+---+---+---+---+---+
    | Alpine Linux 3.6.2        | X | X |   |   |   |   |   |   |   |   |   |   |
    | Alpine Linux 3.7.0        | X | X |   |   |   |   |   |   |   |   |   |   |
    | CentOS 6 (x86_64)         |   | X |   |   |   | X |   |   |   | X |   |   |
    | CentOS 7 (x86_64)         |   | X |   |   |   | X |   |   |   | X |   |   |
    | Debian "Wheezy"           | X | X |   |   | X | X |   |   |   |   |   |   |
    | Debian "Jessie"           | X | X |   |   | X | X |   |   |   |   |   |   |
    | Debian "Stretch"          | X | X |   |   | X | X |   |   |   |   |   |   |
    | Slackware Linux 14.0      | X | X | X | X | X | X |   |   | X | X |   |   |
    | Slackware Linux 14.1      | X | X | X | X | X | X |   |   | X | X | X | X |
    | Slackware Linux 14.2      | X | X | X | X | X | X |   |   | X | X | X | X |
    | System Rescue CD 4.9.4    | X | X |   |   | X | X |   |   |   |   |   |   |
    | System Rescue CD 4.9.5    | X | X |   |   | X | X |   |   |   |   |   |   |
    | System Rescue CD 5.1.2    | X | X |   |   | X | X |   |   |   |   |   |   |
    | TinyCore 7.2              | X |   |   |   | X |   |   |   |   |   |   |   |
    | TinyCore 8.2.1            | X |   |   |   | X |   |   |   |   |   |   |   |
    | Ubuntu "Precise Pangolin" | X | X |   |   | X | X |   |   |   |   |   |   |
    | Ubuntu "Trusty Tahr"      | X | X |   |   | X | X |   |   |   |   |   |   |
    | Ubuntu "Xenial Xerus"     | X | X |   |   | X | X |   |   |   |   |   |   |
    | Ubuntu "Yakkety Yak"      | X | X |   |   | X | X |   |   |   |   |   |   |
    | Ubuntu "Artful Aardvark"  | X | X |   |   | X | X |   |   |   |   |   |   |
    | Ubuntu "Zesty Zapus"      | X | X |   |   | X | X |   |   |   |   |   |   |
    +---------------------------+---+---+---+---+---+---+---+---+---+---+---+---+


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


