#!/bin/bash

mesaj bilgi "$DAGITIM için ISO hazırlanıyor..."
#umount
_umount


#ek-güncellemelerin eklenmesi
#ek-güncellemelerin eklenmesi
if [ -d $BUILDER_ROOT/iso_icerik/updates ]; then rm -rf iso_icerik/updates;fi
cp -rf $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/updates iso_icerik/
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
ISOYOLU=`pwd`/$ISODOSYA.iso
mv $ISOYOLU /mnt/
mesaj yesil "
	*********************************************************
	* ISO olusturuldu..
	* /mnt/$ISODOSYA.iso ($ISOBOYUT)
	*********************************************************
"
