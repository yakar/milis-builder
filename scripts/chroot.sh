#!/bin/bash

if [ ! -d "$LFS" ];
	mesaj hata "$LFS klasörü bulunamadı!"
else

	_umount
	_mount

	chroot $LFS /bin/bash
fi