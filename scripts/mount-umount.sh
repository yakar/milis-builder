#!/bin/bash

_mount() {
	if [ -d $LFS ]; then
		mountpoint -q $LFS/proc    || mount -t proc /proc $LFS/proc/
		mountpoint -q $LFS/sys     || mount -t sysfs /sys $LFS/sys/
		mountpoint -q $LFS/dev     || mount -o bind /dev $LFS/dev/
		mountpoint -q $LFS/dev/pts || mount -o bind /dev/pts $LFS/dev/pts/

		mesaj bilgi "Ana sistem hazirlik klasorune mount edildi."
	else
		mesaj hata "LFS icin gerekli aygitlar mount edilemedi!"
	fi
}

_umount() {
	if [ -d $LFS ]; then
		mountpoint -q $LFS/proc    && umount -l $LFS/proc/
		mountpoint -q $LFS/sys     && umount -l $LFS/sys/
		mountpoint -q $LFS/dev     && umount -l $LFS/dev/
		mountpoint -q $LFS/dev/pts && umount -l $LFS/dev/pts/

		mesaj bilgi "Hazirlik klasorunden aygitlar unmount edildi."
	else
		mesaj hata "Hazirlik klasorunden aygitlar unmount edilemedi!"
	fi
}