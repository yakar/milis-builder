#!/bin/bash

# 2 Temmuz 2017 20:00
# Beta 2 / aydin@komutan.org
set -e

# builder mevcut dizini
BUILDER_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

# ayarlar
. ayarlar.conf


# gerekli fonksiyonlar
. scripts/mesaj.sh
. scripts/mount-umount.sh


# yetki kontrol
if [ "$(id -u)" != "0" ]; then mesaj hata "Root hakları ile çalıştırılmalıdır."; exit 1; fi

# ayarlar.conf'da belirtilmesi gereken degiskenlerin kontrolu
if [ -z "$DAGITIM" ]; then 			mesaj hata "DAGITIM=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi
if [ -z "$KODADI" ]; then 			mesaj hata "KODADI=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi
if [ -z "$VERSIYON" ];then 			mesaj hata "VERSIYON=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi
if [ -z "$MASAUSTU" ];then 			mesaj hata "MASAUSTU=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi
if [ -z "$GIRISYONETICISI" ];then	mesaj hata "GIRISYONETICISI=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi
if [ -z "$HOSTNAME" ];then 			mesaj hata "HOSTNAME=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi
if [ -z "$ISO_ETIKET" ];then 		mesaj hata "ISO_ETIKET=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi
if [ -z "$UEFI" ];then 				mesaj hata "UEFI=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi
if [ -z "$OZELLESTIRME" ];then 		mesaj hata "OZELLESTIRME=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi
if [ ! -d "$OZELLESTIRME" ];then 	mesaj hata "ayarlar.conf da belirtilen '$OZELLESTIRME' klasörü bulunamadı!"; exit 1; fi
if [ -z "$LFS" ];then 				mesaj hata "LFS=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi
if [ -z "$PAKET_SUNUCUSU" ];then	mesaj hata "PAKET_SUNUCUSU=\"\" ayarlar.conf dosyasında tanımlanmamış!"; exit 1; fi

# gerekli paketlerin kontrolu ve yoksa kurulmasi
if [ ! -d "/var/lib/pkg/DB/lzip" ]; then 		mps kur lzip;		fi
if [ ! -d "/var/lib/pkg/DB/mksquashfs" ]; then	mps kur squashfs;	fi
if [ ! -d "/var/lib/pkg/DB/syslinux" ]; then	mps kur syslinux;	fi
if [ ! -d "/var/lib/pkg/DB/cdrkit" ]; then		mps kur cdrkit;		fi


case "$1" in
	# iso islemleri
	-t|--temizle)
		. scripts/temizle.sh
		;;
	-o|--onhazirlik)
		. scripts/iso-onhazirlik.sh
		;;
	-i|--iso)
		. scripts/iso-olustur.sh
		;;
		
	# yps secenekleri
	--yps-olustur)
		. scripts/yps-olustur.sh
		;;
	--yps-baslat)
		. scripts/yps-baslat.sh
		;;
	--yps-durdur)
		fuser -k 8888/tcp
		;;
	--yps-kontrol)
		. scripts/yps-kontrol.sh
		;;
	-y|--yardim)
		. scripts/yardim.sh
		;;
	*)
		mesaj hata "Lütfen parametre giriniz. Yardım için -y kullanabilirsiniz."
esac
exit

# ADIM 8: qemu ile iso test
./qemu.sh milis_live.iso