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

# mps.conf kontrol
elif [ ${sunucular[0]} != "127.0.0.1:8888/" ]; then
	mesaj hata "mps.conf dosyasında sunucular değerine 127.0.0.1:8888/ girilmemiş!"

else
	mesaj bilgi "Herşey yolunda görünüyor.."
fi