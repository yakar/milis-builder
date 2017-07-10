#!/bin/bash


# sfs dosyasının indirilmesi ve açılması
mesaj bilgi "milis-bootstrap indir ve aç"; sleep 1;
if [ ! -d $LFS ]; then
	cd ${LFS%/*} # üst klasöre git (/mnt)

	if [ ! -f "milis-bootstrap-enson.sfs" ]; then
		wget http://milis.gungre.ch/iso/milis-bootstrap-enson.sfs
	fi

	unsquashfs milis-bootstrap-enson.sfs && mv squashfs-root ${LFS##*/} #son klasör adıyla taşı (/mnt/milis için milis)
fi


# dns
echo 'nameserver 8.8.8.8' > $LFS/etc/resolv.conf 

# unmount ve mount islemleri
_umount
_mount

# bashrc kopyalayalim
cp /sources/milis.git/ayarlar/bashrc_chroot "$LFS"/etc/bashrc

# chroot
# TEST: chroot "$LFS" /usr/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' /bin/bash --login
# lfs dizini oluşturup ortama girdikten sonra bu betiği çalıştırabilirsiniz,bütün ortam içi işlemler yapılacaktır.
mesaj bilgi "paket sistemi guncellemesi"; sleep 1;
chroot $LFS /bin/bash -c "mps sun http://$PAKET_SUNUCUSU"
chroot $LFS /bin/bash -c "mps guncelle"

mesaj bilgi "linux-firmware, kernel, dracut, xorg ve $MASAUSTU kurulumu"; sleep 1;

chroot $LFS /bin/bash -c "if [ ! -d '/var/lib/pkg/DB/linux-firmware' ]; then 	mps kur linux-firmware;	fi"
chroot $LFS /bin/bash -c "if [ ! -d '/var/lib/pkg/DB/kernel' ]; then 			mps kur kernel;			fi"
chroot $LFS /bin/bash -c "if [ ! -d '/var/lib/pkg/DB/dracut' ]; then 			mps kur dracut;			fi"
chroot $LFS /bin/bash -c "if [ ! -d '/var/lib/pkg/DB/xorg' ]; then 				mps kur xorg;			fi"
chroot $LFS /bin/bash -c "mps -kuruld /root/talimatname/temel-ek/derleme.sira"
chroot $LFS /bin/bash -c "mps kur $MASAUSTU"

# girisci kurulum
mesaj bilgi "$GIRISYONETICISI kurulum ve ayarları"; sleep 1;
chroot $LFS /bin/bash -c "if [ ! -d '/var/lib/pkg/DB/$GIRISYONETICISI' ]; then  mps kur $GIRISYONETICISI; fi"
chroot $LFS /bin/bash -c "mps -kurul /root/ayarlar/gerekli_programlar_$MASAUSTU"
chroot $LFS /bin/bash -c "cp /root/ayarlar/.xinitrc.$MASAUSTU /root/.xinitrc"
chroot $LFS /bin/bash -c "cp -r /root/ayarlar/$MASAUSTU/.config /root/"
chroot $LFS /bin/bash -c "echo 'HOSTNAME=\"$HOSTNAME\"' > /etc/sysconfig/network"
chroot $LFS /bin/bash -c "echo 'MANAGER=\"networkmanager\"' >> /etc/sysconfig/network"
chroot $LFS /bin/bash -c "if [ ! -f /usr/bin/dracut ]; then tamir_dracut; fi"

# baslatici olustur
mesaj bilgi "diğer ayarlar ve yapılandırmalar"; sleep 1;
chroot $LFS /bin/bash -c "rm -f /boot/initramfs"
chroot $LFS /bin/bash -c "dracut -N --force --xz --add 'dmsquash-live pollcdrom' --omit systemd /boot/initramfs `ls /lib/modules`"
chroot $LFS /bin/bash -c "if [ -f /var/lib/pkg/tarihce/temel-pkvt.tar.lz ]; then mv /var/lib/pkg/tarihce/temel-pkvt.tar.lz /var/lib/pkg/tarihce/temel2-pkvt.tar.lz; fi"
chroot $LFS /bin/bash -c "rm -rf /tmp/*"
chroot $LFS /bin/bash -c "rm -rf /depo/paketler/*"
chroot $LFS /bin/bash -c "mps -tro"
chroot $LFS /bin/bash -c "export LC_ALL='tr_TR.UTF-8'"
chroot $LFS /bin/bash -c "export LANG='tr_TR.UTF-8'"
chroot $LFS /bin/bash -c "xdg-user-dirs-update"
chroot $LFS /bin/bash -c "if [ -f /usr/bin/slim ];then 	cp -f /root/ayarlar/.xinitrc-$MASAUSTU.slim /root/.xinitrc; fi"
chroot $LFS /bin/bash -c "if [ -f /usr/bin/lxdm ];then cp -rf /sources/milis.git/ayarlar/servisler/mbd/init.d/lxdm /etc/init.d/; fi"
chroot $LFS /bin/bash -c "cp -rf /sources/milis.git/ayarlar/milbit/milbit.desktop /usr/share/applications/"
chroot $LFS /bin/bash -c "mkdir -p /root/{Desktop,Masaüstü}"
chroot $LFS /bin/bash -c "cp -f /sources/milis.git/ayarlar/kurulum.desktop /root/Desktop/"
chroot $LFS /bin/bash -c "cp -f /sources/milis.git/ayarlar/kurulum.desktop /root/Masaüstü/"
chroot $LFS /bin/bash -c "tamir_touchpad"
chroot $LFS /bin/bash -c "tamir_masaustu"
