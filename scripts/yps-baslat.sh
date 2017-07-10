#!/bin/bash

if [ ! -d "$YERELPS" ]; then 			mesaj hata "$YERELPS bulunamadı!"; exit; fi
if [ ! -f "$YERELPS/paket.vt" ]; then 	mesaj hata "$YERELPS/paket.vt veritabanı bulunamadı!"; exit; fi

python -m SimpleHTTPServer 8888 &

sleep 1
mesaj bilgi "Yerel Paket Sunucusu başlatıldı.."
mesaj bilgi "Başlatma sırasında herhangi bir hata aldıysanız durdurup yeniden başlatmayı deneyiniz."