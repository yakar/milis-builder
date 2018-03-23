#!/bin/bash

_mount() {
	if [ -d $LFS ]; then
		mountpoint -q $LFS/dev     || mount -v -B /dev $LFS/dev
		mountpoint -q $LFS/dev/pts || mount --bind /dev/pts $LFS/dev/pts
		mountpoint -q $LFS/proc    || mount -vt proc proc $LFS/proc
		mountpoint -q $LFS/sys     || mount -vt sysfs sysfs $LFS/sys
		

		mesaj bilgi "Ana sistem hazirlik klasorune mount edildi."
	else
		mesaj hata "LFS icin gerekli aygitlar mount edilemedi!"
	fi
}

_umount() {
	if [ -d $LFS ]; then
		mountpoint -q $LFS/proc    && umount -l $LFS/proc/
		mountpoint -q $LFS/sys     && umount -l $LFS/sys/
		mountpoint -q $LFS/dev/pts && umount -l $LFS/dev/pts/
		mountpoint -q $LFS/dev     && umount -l $LFS/dev/

		mesaj bilgi "Hazirlik klasorunden aygitlar unmount edildi."
	else
		mesaj hata "Hazirlik klasorunden aygitlar unmount edilemedi!"
	fi
}
