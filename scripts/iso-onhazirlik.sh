#!/bin/bash

bootstrap_url="http://kaynaklar.milislinux.org/iso/milis-bootstrap-enson.sfs"

# sfs dosyasının indirilmesi ve açılması
mesaj bilgi "milis-bootstrap indir ve aç";
if [ ! -d $LFS ]; then
	cd ${LFS%/*} # üst klasöre git (/mnt)

	if [ ! -f "milis-bootstrap-enson.sfs" ]; then
		wget $bootstrap_url
	fi

	unsquashfs milis-bootstrap-enson.sfs && mv squashfs-root ${LFS##*/} #son klasör adıyla taşı (/mnt/milis için milis)
fi


# dns
#echo 'nameserver 8.8.8.8' > $LFS/etc/resolv.conf
cp -f /etc/resolv.conf $LFS/etc/

# unmount ve mount islemleri
_umount
_mount


# bashrc kopyalayalim
cp -r /sources/milis.git/ayarlar/bashrc_chroot "$LFS"/etc/bashrc


# mps.conf ve guncelle
mesaj bilgi "paket sistemi guncellemesi";
cp -r $MPSCONF $LFS/etc/
chroot $LFS /bin/bash -c "mps guncelle && mps -GG && mps -G"

mesaj bilgi "linux-firmware, kernel, dracut, xorg kurulumu";
if [ -d "$LFS/root/bin/dracut" ]; then	chroot $LFS /bin/bash -c "rm -rf /root/bin/dracut"; fi
if [ ! -d "$LFS/var/lib/pkg/DB/linux-firmware" ]; then	chroot $LFS /bin/bash -c "mps kur linux-firmware"; fi
if [ ! -d "$LFS/var/lib/pkg/DB/linux-firmware" ]; then	exit 1; fi
if [ ! -d "$LFS/var/lib/pkg/DB/kernel" ]; then			chroot $LFS /bin/bash -c "mps kur kernel"; fi
if [ ! -d "$LFS/var/lib/pkg/DB/kernel" ]; then	exit 1; fi
if [ ! -f "$LFS/usr/bin/dracut" ]; then					rm -rf $LFS/usr/bin/dracut; fi # dracut dizin ise sil..
if [ ! -d "$LFS/var/lib/pkg/DB/dracut" ]; then			chroot $LFS /bin/bash -c "mps kur dracut || true"; fi
if [ ! -d "$LFS/var/lib/pkg/DB/cryptsetup" ]; then chroot $LFS /bin/bash -c "mps kur cryptsetup"; fi

if [ ! -z ${MASAUSTU} ];then

	if [ ! -d "$LFS/var/lib/pkg/DB/xorg" ]; then			chroot $LFS /bin/bash -c "mps kur xorg"; fi
	if [ ! -d "$LFS/var/lib/pkg/DB/xf86-video-openchrome" ]; then chroot $LFS /bin/bash -c "mps kur xf86-video-openchrome"; fi


	#temel-ek uygulamaların kurulması
	TEMEL_EK_PAKETLER=()
	mesaj bilgi "Her masaüstü için gerekli paketlerin kurulmasi";

	for tepaket in $(cat $BUILDER_ROOT/$OZELLESTIRME/uygulamalar); do
		if [ ! -d "$LFS/var/lib/pkg/DB/$tepaket" ]; then
			chroot $LFS /bin/bash -c "mps kur $tepaket"
		fi
	done

	for gerekli in $(cat $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/apps); do
		if [ ! -d "$LFS/var/lib/pkg/DB/$gerekli" ]; then chroot $LFS /bin/bash -c "mps kur $gerekli"; fi
		if [ ! -d "$LFS/var/lib/pkg/DB/$gerekli" ]; then mesaj hata "$gerekli paketi kurulamadı!";exit 1; fi
	done



	# Masaüstü ortamının kurulumu
	if [ -f "$BUILDER_ROOT/scripts/de-$MASAUSTU.sh" ];then
		. $BUILDER_ROOT/scripts/de-$MASAUSTU.sh
	else
		mesaj hata "de-$MASAUSTU.sh betik dosyası bulunamadı!";
		exit 1
	fi

	# girisci kurulum
	if [ -f "$BUILDER_ROOT/scripts/de-login-$GIRISYONETICISI.sh" ];then
		. $BUILDER_ROOT/scripts/de-login-$GIRISYONETICISI.sh
	else
		mesaj hata "de-login-$GIRISYONETICISI.sh betik dosyası bulunamadı!";
		exit 1
	fi
else
	mesaj bilgi "Minimal imaj için masaüstü ayarları es geçildi.";
fi

# ekstra paketlerin kurulmasi
for paket in $EXTRA_PAKETLER; do
	if [ ! -d "$LFS/var/lib/pkg/DB/$paket" ]; then
		chroot $LFS /bin/bash -c "mps kur $paket"
	fi
done

# hostname
chroot $LFS /bin/bash -c "echo 'HOSTNAME=\"$HOSTNAME\"' > /etc/sysconfig/network"
chroot $LFS /bin/bash -c "echo 'MANAGER=\"networkmanager\"' >> /etc/sysconfig/network"

# baslatici olustur
mesaj bilgi "diğer ayarlar ve yapılandırmalar";
chroot $LFS /bin/bash -c "rm -f /boot/initramfs"


chroot $LFS /bin/bash -c "dracut -N --force --xz --add 'dmsquash-live pollcdrom crypt' --omit systemd /boot/initramfs `ls /lib/modules`"
chroot $LFS /bin/bash -c "if [ -f /var/lib/pkg/tarihce/temel-pkvt.tar.lz ]; then mv /var/lib/pkg/tarihce/temel-pkvt.tar.lz /var/lib/pkg/tarihce/temel2-pkvt.tar.lz; fi"
chroot $LFS /bin/bash -c "rm -rf /tmp/*"
chroot $LFS /bin/bash -c "rm -rf /depo/paketler/*"
chroot $LFS /bin/bash -c "mps -tro"
chroot $LFS /bin/bash -c "export LC_ALL='tr_TR.UTF-8'"
chroot $LFS /bin/bash -c "export LANG='tr_TR.UTF-8'"

if [ ! -z ${MASAUSTU} ];then

	#plymouth tema ayarlanması
	[ -d $BUILDER_ROOT/$OZELLESTIRME/plymouth/$PLYMOUTH_TEMA ] && cp -rf $BUILDER_ROOT/$OZELLESTIRME/plymouth/$PLYMOUTH_TEMA   $LFS/usr/share/plymouth/themes/
	chroot $LFS /bin/bash -c "plymouth-set-default-theme $PLYMOUTH_TEMA"
	chroot $LFS /bin/bash -c "[ -f /usr/bin/xdg-user-dirs-update ] && xdg-user-dirs-update"
	chroot $LFS /bin/bash -c "cp -rf /sources/milis.git/ayarlar/milbit/milbit.desktop /usr/share/applications/"
	chroot $LFS /bin/bash -c "mkdir -p /root/Masaüstü"
	chroot $LFS /bin/bash -c "cp -f /sources/milis.git/ayarlar/kurulum.desktop /root/Masaüstü/"
	chroot $LFS /bin/bash -c "cp -f /sources/milis.git/ayarlar/milis-kur.desktop /root/Masaüstü/"
	chroot $LFS /bin/bash -c "chmod +x /root/Masaüstü/*.desktop"
	chroot $LFS /bin/bash -c "tamir_touchpad"
	chroot $LFS /bin/bash -c "tamir_masaustu"
fi



#chroot $LFS /bin/bash -c "if [ -f /usr/bin/lxdm ];then cp -rf /sources/milis.git/ayarlar/servisler/mbd/init.d/lxdm /etc/init.d/; fi"

#eski kurulum masaüstü kısayolu

chroot $LFS /bin/bash -c "rm -f /root/.gitconfig"

chroot $LFS /bin/bash -c "git_ssl_tamir"


mesaj bilgi "Ön Hazırlık başarıyla tamamlandı."
mesaj bilgi "ISO oluşturma adımına geçebilirsiniz."
