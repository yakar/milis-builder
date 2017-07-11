#!/bin/bash

#umount
_umount

# son ayar yuklemeleri
mesaj bilgi "ISO için ön ayarlar yapılıyor.."
cd /sources/milis.git/
cp -f rootfs/etc/bashrc $LFS/etc/bashrc
cp -f rootfs/etc/profile $LFS/etc/profile
cp -f ayarlar/mps.conf $LFS/etc/mps.conf
cp -f rootfs/etc/rc.d/init.d/* $LFS/etc/rc.d/init.d/

rm -f iso_icerik/boot/kernel
rm -f iso_icerik/boot/initramfs
rm -rf iso_icerik/LiveOS
cp $LFS/boot/kernel-* iso_icerik/boot/kernel
cp $LFS/boot/initramfs* iso_icerik/boot/initramfs


# LiveOS ayarları
mesaj bilgi "LiveOS ayarları yapılıyor..."
mkdir -p tmp/LiveOS

dd if=/dev/zero of=tmp/LiveOS/ext3fs.img bs=1MB count=16384
mke2fs -t ext4 -L $ISO_ETIKET -F tmp/LiveOS/ext3fs.img
mkdir -p temp-root
mount -o loop tmp/LiveOS/ext3fs.img temp-root
cp -dpR $LFS/* temp-root/
umount -l temp-root
rm -rf temp-root 
mkdir -p iso_icerik/LiveOS
mksquashfs tmp iso_icerik/LiveOS/squashfs.img -comp xz -b 256K -Xbcj x86
chmod 444 iso_icerik/LiveOS/squashfs.img
rm -rf tmp


# isolinux ve syslinux
mesaj bilgi "ISOLinux ve SYSLinux ayarları yapılıyor"
sed -i "s/^label.*/label $DAGITIM $VERSIYON Live/g" iso_icerik/boot/syslinux/syslinux.cfg
sed -i "s/CDLABEL=[A-Z_]*/CDLABEL=$ISO_ETIKET/g" iso_icerik/boot/syslinux/syslinux.cfg
cp -r iso_icerik/boot/syslinux/syslinux.cfg iso_icerik/boot/isolinux/isolinux.cfg
cp -r $BUILDER_ROOT/ozellestirme/syslinux/arkaplan.png iso_icerik/boot/syslinux/arkaplan.png
cp -r $BUILDER_ROOT/ozellestirme/syslinux/arkaplan.png iso_icerik/boot/isolinux/arkaplan.png

# slim
cp -r $BUILDER_ROOT/ozellestirme/slim/panel.png $LFS/usr/share/slim/themes/milis/

# xfce4 arkaplanlar ve logo
if [ $MASAUSTU == "xfce4" ]; then
	# varsayilan arkaplan
	cp -r $BUILDER_ROOT/ozellestirme/xfce4/backgrounds/milis-linux-arkaplan.png /sources/milis.git/ayarlar/

	# varsayılan milis logo
	mv -f $BUILDER_ROOT/ozellestirme/xfce4/backgrounds/milislogo.png /sources/milis.git/ayarlar/

	# cesitli arkaplanlar
	cp -r $BUILDER_ROOT/ozellestirme/xfce4/backgrounds/* /usr/share/backgrounds/xfce/
fi

# varsayılan root parolası
sed -i "47s/milis/$ROOT_PAROLASI/g" $LFS/etc/init.d/sysklogd

# ISO oluştur 
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