#!/bin/bash

# 2 Temmuz 2017 20:00
# Beta 2 / aydin@komutan.org
set -e

# gerekli fonksiyonlar
. scripts/mesaj.sh
. scripts/mount-umount.sh

# builder mevcut dizini
BUILDER_ROOT=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

kullanici_ayar="$1"
# ayarlar
if [ ! "$1" ]; then
	mesaj hata "ayardosyası gerek! $1"
	exit 1
fi

if [ -f $kullanici_ayar ];then
	. $kullanici_ayar
else
	mesaj hata "iso yapımı için bir ayar dosyası yolu bulunamadı."
	. $BUILDER_ROOT/ayarlar/ayarlar.conf
fi

if [ -z "$MPSCONF" ];then 
	. $BUILDER_ROOT/ayarlar/mps.conf
else
	if [ ! -f "$MPSCONF" ]; then 
		mesaj hata "$MPSCONF yolu bulunamadı!"; 
		exit 1;
	else
		. $MPSCONF
	fi
fi


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
if [ -z "$sunucular" ];then			mesaj hata "sunucular=\"\" mps.conf dosyasında tanımlanmamış!"; exit 1; fi

# gerekli paketlerin kontrolu ve yoksa kurulmasi
if [ ! -d "/var/lib/pkg/DB/lzip" ]; then 		mps kur lzip;		fi
if [ ! -d "/var/lib/pkg/DB/squashfs" ]; then	mps kur squashfs;	fi
if [ ! -d "/var/lib/pkg/DB/syslinux" ]; then	mps kur syslinux;	fi
if [ ! -d "/var/lib/pkg/DB/cdrkit" ]; then		mps kur cdrkit;		fi

# ayarlar
if [ ! "$1" ]; then
	mesaj hata "ayardosyası gerek! $1"
	exit 1
fi

# ayarlar
if [ ! "$2" ]; then
	mesaj hata "işlem parametresi gerek! Yardım için -y kullanabilirsiniz."
	exit 1
fi

case "$2" in

	# iso islemleri
	-t|--temizle|adim0)
		. scripts/temizle.sh
		;;
	-o|--onhazirlik|adim1)
		. scripts/iso-onhazirlik.sh
		;;
	-i|--iso|adim2)
		. scripts/iso-olustur.sh
		;;
	-si|--sadece-iso)
		SFS_OLUSTUR=1
		. scripts/iso-olustur.sh
		;;
	-c|--chroot)
		. scripts/chroot.sh
		;;

	# qemu
	-q|--qemu)
		. scripts/qemu.sh
		;;

	# yps secenekleri
	-yo|--yps-olustur)
		. scripts/yps-olustur.sh
		;;
	-yb|--yps-baslat)
		. scripts/yps-baslat.sh
		;;
	-yd|--yps-durdur)
		fuser -k 8888/tcp
		;;
	-yg|--yps-guncelle)
		. scripts/yps-guncelle.sh
		;;
	-yk|--yps-kontrol)
		. scripts/yps-kontrol.sh
		;;
	-y|-h|--yardim)
		. scripts/yardim.sh
		;;
	*)
		mesaj hata "Lütfen parametre giriniz. Yardım için -y kullanabilirsiniz."
esac
exit