To install ``IFFSET`` it on a fresh Ubuntu 20.04 LTS system you can follow these steps:



Setup
============

.. code-block:: none
	sudo apt-get install busybox-static fakeroot git dmsetup kpartx nmap snmp
.. code-block:: none
	git clone --recursive https://github.com/momalab/iffset

QEMU
============

.. code-block:: none
	sudo apt-get install qemu-system-arm qemu-system-x86 qemu-utils

Make sure qemu-system-arm is an environmental variable!

Cross-Compilation
=================
	
This is a cross-toolchain to build your own binaries, such as fuzz harnesses, and run them on IFFSET.

.. code-block:: none
	deb http://debian.pengutronix.de/debian/ sid main contrib non-free
 	(Replace "sid" by the right release name e.g. 2021.07.0) 
.. code-block:: none
	sudo apt-get install pengutronix-archive-keyring
.. code-block:: none
	sudo apt -o="Acquire::AllowInsecureRepositories=true" update
.. code-block:: none
	sudo apt install pengutronix-archive-keyring
Having finished up with adding the oselas repo to your list, run the following:
.. code-block:: none
	sudo apt-get install oselas.toolchain-2016.06.0-arm-cortexa8-linux-gnueabihf-gcc-5.4.0-glibc-2.23-binutils-2.26-kernel-4.6-sanitized

Kernel Building
===============
If you are curious enough, you may build and use your own kernel for IFFSET. Download your kernel source and build an image with the OSELAS toolchain. Alternatively, you may find one 3.x and one 4.x kernel source tarballs in the kernel/ folder, which you can modify at will, build and use.
