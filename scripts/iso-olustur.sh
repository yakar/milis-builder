#!/bin/bash

#umount
_umount

#son ayar yuklemeleri
mesaj bilgi "ISO için ön ayarlar yapılıyor.."
cd /sources/milis.git/
cp -f rootfs/etc/bashrc $LFS/etc/bashrc
cp -f rootfs/etc/profile $LFS/etc/profile
cp -f ayarlar/mps.conf $LFS/etc/mps.conf
cp -f rootfs/etc/rc.d/init.d/* $LFS/etc/rc.d/init.d/

rm iso_icerik/boot/kernel
rm iso_icerik/boot/initramfs
rm -r iso_icerik/LiveOS
cp $LFS/boot/kernel-* iso_icerik/boot/kernel
cp $LFS/boot/initramfs* iso_icerik/boot/initramfs

mesaj bilgi "LiveOS ayarları yapılıyor..."
anayer=$(du -sm "$LFS"|awk '{print $1}')
fazladan="$((anayer))"
mkdir -p tmp
mkdir -p tmp/LiveOS
#fallocate -l 32G tmp/LiveOS/rootfs.img
#if [ -f $bos_imaj ];
#then
   #cp $bos_imaj tmp/LiveOS/ext3fs.img
#else
   #dd if=/dev/zero of=tmp/LiveOS/ext3fs.img bs=1MB count="$((anayer+fazladan))"
dd if=/dev/zero of=tmp/LiveOS/ext3fs.img bs=1MB count=16384
#dd if=/dev/zero of=tmp/LiveOS/ext3fs.img bs=1MB count=16192
mke2fs -t ext4 -L $ISO_ETIKET -F tmp/LiveOS/ext3fs.img
mkdir -p temp-root
mount -o loop tmp/LiveOS/ext3fs.img temp-root
cp -dpR $LFS/* temp-root/
#rsync -a kur/ temp-root
umount -l temp-root
rm -rf temp-root 
mkdir -p iso_icerik/LiveOS
mksquashfs tmp iso_icerik/LiveOS/squashfs.img -comp xz -b 256K -Xbcj x86
chmod 444 iso_icerik/LiveOS/squashfs.img
rm -rf tmp

mesaj bilgi "ISO oluşturuluyor..."
ISODOSYA=`echo $DAGITIM | tr '[A-Z]' '[a-z]' | tr ' ' '-'`-$VERSIYON-LIVE-`date +%Y%m%d%H%M`
if [ $UEFI == "1" ]; then
	# uefi
    cp $LFS/usr/lib/syslinux/isohdpfx.bin iso_icerik/boot/isolinux/isohdpfx.bin
    xorriso -as mkisofs \
        -iso-level 3 -rock -joliet \
        -max-iso9660-filenames -omit-period \
        -omit-version-number -relaxed-filenames -allow-lowercase \
        -volid "$ISO_ETIKET" \
        -eltorito-boot boot/isolinux/isolinux.bin \
        -eltorito-catalog boot/isolinux/isolinux.cat \
        -no-emul-boot -boot-load-size 4 -boot-info-table \
        -eltorito-alt-boot -e boot/grub/efiboot.img -isohybrid-gpt-basdat -no-emul-boot \
        -isohybrid-mbr iso_icerik/boot/isolinux/isohdpfx.bin \
        -output "$ISODOSYA.iso" iso_icerik || echo "ISO imaj olusturalamadı";exit 1

else
	genisoimage -l -V $ISO_ETIKET -R -J -pad -no-emul-boot -boot-load-size 4 -boot-info-table  \
	-b boot/isolinux/isolinux.bin -c boot/isolinux/boot.cat -o $ISODOSYA.iso iso_icerik && isohybrid $ISODOSYA.iso
fi

ISOBOYUT=$(du -sbh $ISODOSYA.iso | awk '{print $1}')
mesaj yesil "
	*********************************************************************
	* ISO olusturuldu..
	* `pwd`/$ISODOSYA.iso ($ISOBOYUT)
	*********************************************************************
"