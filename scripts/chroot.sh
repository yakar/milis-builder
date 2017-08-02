#!/bin/bash

if [ ! -d "$LFS" ]; then
	mesaj hata "$LFS klasörü bulunamadı!"
else

	_umount
	_mount

	chroot $LFS /bin/bash
fi