#!/bin/bash

if [ ! -d "$YERELPS" ]; then 			mesaj hata "$YERELPS bulunamadı!"; exit; fi
if [ ! -f "$YERELPS/paket.vt" ]; then 	mesaj hata "$YERELPS/paket.vt veritabanı bulunamadı!"; exit; fi

cd $YERELPS
python -m SimpleHTTPServer 8888 > /dev/null 2>&1 &

sleep 1
mesaj bilgi "Yerel Paket Sunucusu başlatıldı.."
mesaj bilgi "Herhangi bir hata aldıysanız:"
mesaj bilgi "--yps-kontrol ile hatalara karşı kontrol edebilir"
mesaj bilgi "--yps-durdur ile çalışan durdurduktan sonra yeniden başlatmayı deneyiniz."