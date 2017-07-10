#!/bin/bash

# yps yol kontrol 
if [ ! -d "$YERELPS" ]; then
	mesaj hata "$YERELPS bulunamadı! Yeniden oluşturmayı deneyiniz.";

# paket.vt kontrol
elif [ ! -f "$YERELPS/paket.vt" ]; then
	mesaj hata "$YERELPS/paket.vt veritabanı bulunamadı, oluşturuluyor...";

	cd $YERELPS
	pkvt_olustur
	mesaj bilgi "$YERELPS/paket.vt oluşturuldu."

# ayarlar.conf kontrol
elif [ $PAKET_SUNUCUSU != "127.0.0.1:8888" ]; then
	mesaj hata "ayarlar.conf dosyasında PAKET_SUNUCUSU değerine 127.0.0.1:8888 girilmemiş!"

else
	mesaj bilgi "Herşey yolunda görünüyor!"
fi