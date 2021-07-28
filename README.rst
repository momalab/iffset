******************************************************
IFFSET: In-Field Fuzzing through System Emulation Tool
******************************************************

Overview
========

``IFFSET`` is an plug-and-play emulation framework that enables system-level fuzzing on Linux-based PLC.

by Dimitris Tychalas `\@ditihala`_

.. _`\@ditihala`: https://www.twitter.com/ditihala




Installation
============

See INSTALL_

.. _INSTALL: INSTALL.rst


Getting Started
=============

The ``IFFSET`` tool offers a ready-made setup to start playing with or a custom experience with your own Linux-based PLC.

* Firmware Image
	1. The ready-made setup includes an extracted firmware image from a WAGO PLC, located in the fs_archive/ folder. 
	2. You can extract the file system from your own Linux-based PLC by copying the extract.sh script in a folder (preferrably with a large available disk space) on your device, executing the script and copying the produced tarball in the fs_archive/ folder.

* Building QEMU Image
	1. Run the makeImage.sh script located in the util/folder, giving it as an argument a name for the produced image.
	2. The script will build a bootable QEMU image with your given name, based on the extracted file system and a ready-built kernel image located in the binaries/ folder.
	3. The fixImage.sh script will add (possibly) missing nodes, create some folders, delete some others, change some scripts and make the image usable after boot.
	4. An ARM cross-compiled AFL image will also be copied in the new image to help you get started with fuzzing your binaries!

* Modifying the built Image
	1. Script mountImage.sh located in the util/ folder will mount your newly built image letting you freely browse its file system and mess around to your heart's content :)
	2. When finished, run the umountImage.sh script to unmount the image.
	3. Both scripts need sudo privileges and expect one argument, the image name your gave when building it.

* Booting your Image
	1. Run the emurun.sh file in the util/ folder with the image name as its argument.
	2. Wait for ~1 minute to finish booting, until the debug messages stop.
	3. Press Enter. 
	4. Login with the credentials of your device (user/user, admin/wago or roor/wago for the included image)
	5. Done!

* Fuzzing on the booted Image
	1. If you are acquainted with AFL, just browse to the root folder and use the preinstalled AFL binary
	2. There is also a ready-made script, named fuzzscript, to help you get started
	3. Build an /in folder and create a file inside to be your primary input seed 
	4. Build an /out folder 
	5. Run the script with a system binary of your choice as an argument (e.g. bash)!

Cite us!
========
If you find our work interesting and use it in your (academic or not) research, please cite our DATE 2020 paper describing IFFSET:

Tychalas, Dimitrios, and Michail Maniatakos. "IFFSET: in-field fuzzing of industrial control systems using system emulation." 2020 Design, Automation & Test in Europe Conference & Exhibition (DATE). IEEE, 2020.

Acknowledgements
================

``IFFSET``, as all things good in life, is based on the shoulder of giants. The framework relies on the powerful ``QEMU`` platform for extracting, building and booting firmware images. The main idea for this tool was adapted by the incredible ``Firmadyne`` tool by Dominic Chen, which also provided some memory libraries and initialization files. The main fuzzing tool for this framework is the American Fuzzy Lop, or ``AFL`` by Michal Zalewski.

* `QEMU <http://qemu.org/>`__
* `Firmadyne <https://github.com/firmadyne/firmadyne/>`__
* `AFL <https://lcamtuf.coredump.cx/afl/>`__
