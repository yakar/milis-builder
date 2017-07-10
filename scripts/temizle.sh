#!/bin/bash

# $LFS klasörü yoksa çık
if [ ! -d $LFS ]; then mesaj hata "$LFS klasörü bulunamadı."; exit 1; fi

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
			exit 1
			;;

		[Hh]* )
			mesaj uyari "$LFS klasörü silinmekten vazgeçildi."
			exit 1
			;;

		* )
			mesaj hata "Silme işlemini onaylamak için e veya h seçeneklerini girmelisiniz."
	esac
done