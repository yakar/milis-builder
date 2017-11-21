#!/bin/bash

# parametre girilmedi ise
if [ -z $1 ]; then mesaj hata "Parametre belirtilmelidir."; fi

mesaj yesil "
Milis Builder 2017.11

Genel Parametreler
	-t | --temizle
	Tüm çalışmaları siler ve çalışmaya sıfırdan başlamanızı sağlar. Silme işlemi geri alınamaz.

	-o | --onhazirlik
	Gerekli klasör yapısını oluşturur, temel paketlerin indirilmesi ve kurulması işlemleri yapar.

	-i | --iso
	Son aşamadır, dağıtımı iso formatına çevirir. Öncesinde --onhazirlik ile gerekli temel paketlerin
	kurulmuş olması gerekmektedir.

	-si | --sadece-iso
	SquashFS oluşturma adımını atlayarak iso oluşturmaktadır. SquashFS'nin oluşturulmuş olması gerekmektedir.

	-c | --chroot
	Ön hazırlığı yapılmış dağıtım için elle müdahale imkanı tanır.

	-q | --qemu <iso> <ram kb>
	Çıkarılan ISO dosyasının test edilmesini sağlar. Ram miktarı isteğe bağlı olarak belirtilebilir, belirtilmez ise 1024 Kb olarak değerlendirilecektir.

	-y | --yardim
	Bu yardım metnini görüntüler.

Yerel Paket Sistemi:
	-yo | --yps-olustur
	Yerel paket sunucusu oluşturmak için kullanılır. Dağıtım hazırlama sırasında tekrar tekrar
	tüm paketlerin indirilmesi istenmiyorsa bu seçenek kullanılabilir. Fakat unutulmamalıdır ki
	kullanmasanız da sunucuda bulunan tüm paketler indirilecektir.

	-yb | --yps-baslat
	Oluşturulmuş olan Yerel Paket Sistemi (--yps-olustur) başlatılacaktır.

	-yd | --yps-durdur
	Başlatılan Yerel Paket Sistemi (--yps-baslat) durdurulacaktır.

	-yg | --yps-guncelle
	Yerel Paket Sistemi ile Miilis Paket Sunucusunu eşitler.

	-yk | --yps-kontrol
	Yerel Paket Sistemi yolu, veritabanı kontrolü, çalışıp çalışmadığı gibi kontrolleri sağlar.
	"
