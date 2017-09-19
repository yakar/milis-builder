#!/bin/bash

# $LFS klasörü yoksa çık
if [ ! -d $LFS ]; then mesaj hata "$LFS klasörü bulunamadı.";exit 1; fi

#unmount
_umount

# temizlensin mi?
while true; do

	mesaj hata "$LFS klasörü tamamen silinecek, emin misiniz? [e/h]"
	read -p " " cevap

	case $cevap in
		[Ee]* )
			if [ -d $LFS ]; then
				rm -rf $LFS
				mesaj bilgi "$LFS klasörü silindi."
			fi
			;;

		[Hh]* )
			mesaj uyari "$LFS klasörü silinmekten vazgeçildi."
			exit 1
			;;

		* )
			mesaj hata "Silme işlemini onaylamak için e veya h seçeneklerini girmelisiniz."
	esac
	
	mesaj hata "iso_icerik/LiveOS ve iso_icerik/updates klasörü tamamen silinecek, emin misiniz? [e/h]"
	read -p " " cevap

	case $cevap in
		[Ee]* )
			if [ -d iso_icerik/LiveOS ]; then
				rm -rf iso_icerik/LiveOS
				rm -rf iso_icerik/updates
				rm -f iso_icerik/boot/initramfs
				rm -f iso_icerik/boot/kernel

               			if [ -f iso_icerik/efiboot.img ]; then
				        rm -rf iso_icerik/efiboot.img
               			fi
				mesaj bilgi "iso_icerik/LiveOS klasörü silindi."
			fi
			exit 1
			;;

		[Hh]* )
			mesaj uyari "iso_icerik/LiveOS ve iso_icerik/updates klasörü silinmekten vazgeçildi."
			exit 1
			;;

		* )
			mesaj hata "Silme işlemini onaylamak için e veya h seçeneklerini girmelisiniz."
	esac
done
