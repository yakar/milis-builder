#!/bin/bash

# YPS olusturulmadi ise islemi bitir.
if [ ! -d "$YERELPS" ]; then
	mesaj bilgi "$YERELPS oluşturulmamış. Lütfen --yps-olustur ile oluşturunuz."
	exit 1
fi



UZAK_PAKET_SUNUCUSU="paketler.milislinux.org"

# ana sunucu ile yerel sunucu paket kontrolu ve eski paketlerin temizlenmesi
mesaj uyari "Tüm paketler sunucudakiler ile karşılaştırılacak ve paket veritabanı yeniden oluşturulacak. [e/h]"
read -p " " cevap

if [ $cevap == 'e' ]; then
	# tmp klasoru olustur, tum paketleri oraya tasi ve sunucudan guncel paket.vt indir
	mkdir -p $YERELPS/tmp
	mv -u $YERELPS/*mps.lz $YERELPS/tmp > /dev/null 2>&1
	wget -q -r "http://$UZAK_PAKET_SUNUCUSU/paket.vt" -O $YERELPS/tmp/paket.vt

	# sunucudan indirilen paketler ile tmp klasorundekileri karsilastir (ismine gore)
	for paket in `cat $YERELPS/tmp/paket.vt |  awk '{print $3}'`; do

		# paket tmp de yoksa uzak sunucudan indir
		if [ ! -f "$YERELPS/tmp/$paket" ]; then
			p=`echo $paket | cut -d '#' -f1` # paket adi
			v=`echo $paket | cut -d '#' -f2` # versiyon ve uzanti
			wget "http://$UZAK_PAKET_SUNUCUSU/$p%23$v" -O "$YERELPS/$paket"
			mesaj bilgi "Olmayan paket indirildi: $paket"

		#paket tmp de varsa yerel sunucu klasorune tasi
		else
			mv $YERELPS/tmp/$paket $YERELPS/
		fi
	done

	# tmp klasorunu, eski paket.vt sil ve yeniden olustur..
	mesaj bilgi "Güncel paketler taşındı, paket veritabanı yeniden oluşturuluyor (~3dk)."
	rm -rf "$YERELPS/tmp"
	rm -f $YERELPS/paket.vt
	cd $YERELPS
	pkvt_olustur

	YPS_BOYUT=`du -h -P -d 1 $YERELPS | awk '{print $1}'`
	mesaj bilgi "Yerel Paket Sistemi yeni boyutu: $YPS_BOYUT"
	mesaj bilgi "Güncelleme tamamlandı.."
fi
