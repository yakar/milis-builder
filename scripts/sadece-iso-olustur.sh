#!/bin/bash

mesaj bilgi "$DAGITIM için ISO hazırlanıyor..."
#umount
_umount

# isolinux ve syslinux
mesaj bilgi "ISOLinux ve SYSLinux ayarları yapılıyor"
sed -i "s/^label.*/label $DAGITIM $KODADI $VERSIYON Deneme-Kurulan/g" iso_icerik/boot/syslinux/syslinux.cfg
sed -i "s/CDLABEL=[A-Z_]*/CDLABEL=$ISO_ETIKET/g" iso_icerik/boot/syslinux/syslinux.cfg
sed -i "s/^title.*/title $DAGITIM $KODADI $VERSIYON (UEFI)/g" efi/loader/entries/milis.conf
sed -i "s/CDLABEL=[A-Z_]*/CDLABEL=$ISO_ETIKET/g" efi/loader/entries/milis.conf
cp -r iso_icerik/boot/syslinux/syslinux.cfg iso_icerik/boot/isolinux/isolinux.cfg
cp -r $BUILDER_ROOT/$OZELLESTIRME/syslinux/arkaplan.png iso_icerik/boot/syslinux/arkaplan.png
cp -r $BUILDER_ROOT/$OZELLESTIRME/syslinux/arkaplan.png iso_icerik/boot/isolinux/arkaplan.png

#ek-güncellemelerin eklenmesi
if [ -d $BUILDER_ROOT/iso_icerik/updates ]; then rm -rf iso_icerik/updates;fi
cp -rf $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/updates iso_icerik/
mv iso_icerik/updates/home/gecici_kullanici iso_icerik/updates/home/$CANLI_KULLANICI
echo "$CANLI_KULLANICI" > iso_icerik/updates/etc/canli_kullanici
[ -f $LFS/home/$CANLI_KULLANICI/Desktop/kurulum.desktop ] && sed -i "s/Milis Linux/$DAGITIM/g" $LFS/home/$CANLI_KULLANICI/Desktop/kurulum.desktop
[ -f $LFS/home/$CANLI_KULLANICI/Masaüstü/kurulum.desktop ] && sed -i "s/Milis Linux/$DAGITIM/g" $LFS/home/$CANLI_KULLANICI/Masaüstü/kurulum.desktop
# kullanici için gerekli home izinleri ve yapılacak betiğin ayarlanması
sed -i "s/canlikullanici/$CANLI_KULLANICI/g" $BUILDER_ROOT/iso_icerik/updates/root/bin/canli_kullanici.sh
sed -i "s/canlikullanici/$CANLI_KULLANICI/g" $BUILDER_ROOT/iso_icerik/updates/etc/security/opasswd
sed -i "s/canlikullanici/$CANLI_KULLANICI/g" $BUILDER_ROOT/iso_icerik/updates/etc/slim.conf
sed -i "s/canlikullanici/$CANLI_KULLANICI/g" $BUILDER_ROOT/iso_icerik/updates/etc/passwd
sed -i "s/canlikullanici/$CANLI_KULLANICI/g" $BUILDER_ROOT/iso_icerik/updates/etc/group
sed -i "s/canlikullanici/$CANLI_KULLANICI/g" $BUILDER_ROOT/iso_icerik/updates/etc/gshadow
sed -i "s/canlikullanici/$CANLI_KULLANICI/g" $BUILDER_ROOT/iso_icerik/updates/etc/shadow

#slim teması ayarlanması
if [ ! -z ${SLIM_TEMA_YOL+:} ] && [ -d $SLIM_TEMA_YOL ];then
	mkdir -p $BUILDER_ROOT/iso_icerik/updates/usr/share/slim/themes
	cp -rf $BUILDER_ROOT/$OZELLESTIRME/slim/temalar/* $BUILDER_ROOT/iso_icerik/updates/usr/share/slim/themes/
fi

# iso için zaman ayarlı sürüm no belirlemek.
zaman_surumu=`date +%Y%m%d%H%M`
milis_surum_no=`echo $DAGITIM | tr '[A-Z]' '[a-z]' | tr ' ' '-'`-$VERSIYON-$MASAUSTU-$zaman_surumu

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
	[ -d $BUILDER_ROOT/iso_icerik/updates/home/$CANLI_KULLANICI/Masaüstü ] && chmod 755 $BUILDER_ROOT/iso_icerik/updates/home/$CANLI_KULLANICI/Masaüstü/*.desktop
	[ -d $BUILDER_ROOT/iso_icerik/updates/home/$CANLI_KULLANICI/Desktop ] && chmod 755 $BUILDER_ROOT/iso_icerik/updates/home/$CANLI_KULLANICI/Desktop/*.desktop
	chmod 645 $BUILDER_ROOT/iso_icerik/updates/$YUKLEYICI_KONUM/milis-kur
	echo $milis_surum_no > $BUILDER_ROOT/iso_icerik/updates/etc/milis-surum
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
ISODOSYA=$milis_surum_no
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
HASH256=$(sha256sum $ISODOSYA.iso | cut -d' ' -f1)
ISOYOLU=`pwd`/$ISODOSYA.iso
mv $ISOYOLU /mnt/
mesaj yesil "
	*********************************************************
	* ISO olusturuldu..
	* /mnt/$ISODOSYA.iso ($ISOBOYUT)
	* sha256sum $HASH256
	*********************************************************
"


