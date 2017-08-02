#!/bin/bash

UZAK_PAKET_SUNUCUSU="paketler.milislinux.org"

# Emin misiniz?
read -p "Milis Linux paket sunucusunda bulunan tüm paketler indirilecek (~6 GB veya daha fazla) emin misiniz? [e/h] " cevap
case $cevap in
	[Hh]* )
		mesaj bilgi "İptal edildi.."
		exit
		;;
esac


# YPS klasörü varsa uyar.
if [ -d "$YERELPS" ]; then
	mesaj hata "Varsayılan yerel paket sunucusu $YERELPS mevcut"

	read -p "Tüm paketleri tekrar indirmek istediğinize emin misiniz? [e/h] " cevap
	case $cevap in
		[Hh]* )
			mesaj bilgi "İptal edildi.."
			exit
			;;
	esac
fi


mkdir -p $YERELPS
cd $YERELPS

mesaj bilgi "Paketler indiriliyor.."
wget -r --no-parent http://$UZAK_PAKET_SUNUCUSU -P $YERELPS
mv $UZAK_PAKET_SUNUCUSU/*.lz $YERELPS
rm -rf $UZAK_PAKET_SUNUCUSU

mesaj bilgi "Paket veritabanı oluşturuluyor, lütfen bekleyiniz.."
pkvt_olustur

YPS_BOYUT=`du -h -P -d 1 $YERELPS | awk '{print $1}'`
mesaj bilgi "Yerel paket sunucusu $YERELPS oluşturuldu."
mesaj bilgi "Yerel Sunucu Toplam Boyutu: $YPS_BOYUT"
mesaj bilgi "Yerel sunucuyu ayarlar.conf dosyasına 127.0.0.1:8888 olarak giriniz."
mesaj bilgi "Yerel sunucuyu başlatmayı unutmayın."