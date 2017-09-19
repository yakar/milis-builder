#!/bin/bash

mesaj bilgi "$DAGITIM için ISO hazırlanıyor..."
#umount
_umount

#ek-güncellemelerin eklenmesi
if [ -d $BUILDER_ROOT/iso_icerik/updates ]; then rm -rf iso_icerik/updates;fi
cp -rf $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/updates iso_icerik/


# Milis yükleyici kurulu değilse gitrepodan çekilecek.
if [ ! -d $LFS/var/lib/pkg/DB/milis-yukleyici ];then
	mkdir -p $BUILDER_ROOT/iso_icerik/updates/opt/
	#Milis-Yukleyicinin eklenmesi
	if [ -d $YUKLEYICI_KONUM ]; then 
		cd $YUKLEYICI_KONUM
		git pull
		cd -
	else
		git clone $YUKLEYICI_GITREPO $YUKLEYICI_KONUM
	fi
	cp -rf $YUKLEYICI_KONUM  $BUILDER_ROOT/iso_icerik/updates/opt/
fi

### UEFI bolumu
if [ $UEFI == "1" ]; then
    mkdir -p $BUILDER_ROOT/iso_icerik/efi_tmp
    dd if=/dev/zero bs=1M count=40 of=$BUILDER_ROOT/iso_icerik/efiboot.img
    mkfs.vfat -n Milis_EFI $BUILDER_ROOT/iso_icerik/efiboot.img 
    mount -o loop $BUILDER_ROOT/iso_icerik/efiboot.img $BUILDER_ROOT/iso_icerik/efi_tmp
    cp -rf $BUILDER_ROOT/iso_icerik/boot/kernel $BUILDER_ROOT/iso_icerik/efi_tmp/
    cp -rf $BUILDER_ROOT/iso_icerik/boot/initramfs $BUILDER_ROOT/iso_icerik/efi_tmp/
    cp -rf $BUILDER_ROOT/efi/* $BUILDER_ROOT/iso_icerik/efi_tmp/
    umount $BUILDER_ROOT/iso_icerik/efi_tmp 
    rm -rf $BUILDER_ROOT/iso_icerik/efi_tmp
fi

# ISO oluştur 
mesaj bilgi "ISO oluşturuluyor..."
ISODOSYA=`echo $DAGITIM | tr '[A-Z]' '[a-z]' | tr ' ' '-'`-$VERSIYON-$MASAUSTU-`date +%Y%m%d%H%M`
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
        -eltorito-alt-boot -e efiboot.img -isohybrid-gpt-basdat -no-emul-boot \
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
