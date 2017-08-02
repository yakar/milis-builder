#!/bin/bash


# sfs dosyasının indirilmesi ve açılması
mesaj bilgi "milis-bootstrap indir ve aç";
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
mesaj bilgi "paket sistemi guncellemesi";
chroot $LFS /bin/bash -c "mps guncelle"
chroot $LFS /bin/bash -c "mps sun http://$PAKET_SUNUCUSU"
chroot $LFS /bin/bash -c "mps guncelle"


# ekstra paketlerin kurulmasi
for paket in $EXTRA_PAKETLER; do
	if [ ! -d "$LFS/var/lib/pkg/DB/$paket" ]; then
		chroot $LFS /bin/bash -c "mps kur $paket"
	fi
done


mesaj bilgi "linux-firmware, kernel, dracut, xorg kurulumu";
if [ ! -d "$LFS/var/lib/pkg/DB/linux-firmware" ]; then	chroot $LFS /bin/bash -c "mps kur linux-firmware"; fi
if [ ! -d "$LFS/var/lib/pkg/DB/kernel" ]; then			chroot $LFS /bin/bash -c "mps kur kernel"; fi
if [ ! -f "$LFS/usr/bin/dracut" ]; then					rm -rf $LFS/usr/bin/dracut; fi # dracut dizin ise sil..
if [ ! -d "$LFS/var/lib/pkg/DB/dracut" ]; then			chroot $LFS /bin/bash -c "mps -ik dracut || true"; fi
if [ ! -d "$LFS/var/lib/pkg/DB/xorg" ]; then			chroot $LFS /bin/bash -c "mps kur xorg"; fi


# Desktop Environment kurulumu
. $BUILDER_ROOT/scripts/de-$MASAUSTU.sh

# girisci kurulum
. $BUILDER_ROOT/scripts/de-login-$GIRISYONETICISI.sh

# hostname
chroot $LFS /bin/bash -c "echo 'HOSTNAME=\"$HOSTNAME\"' > /etc/sysconfig/network"
chroot $LFS /bin/bash -c "echo 'MANAGER=\"networkmanager\"' >> /etc/sysconfig/network"


# baslatici olustur
mesaj bilgi "diğer ayarlar ve yapılandırmalar";
chroot $LFS /bin/bash -c "rm -f /boot/initramfs"
chroot $LFS /bin/bash -c "dracut -N --force --xz --add 'dmsquash-live pollcdrom' --omit systemd /boot/initramfs `ls /lib/modules`"
chroot $LFS /bin/bash -c "if [ -f /var/lib/pkg/tarihce/temel-pkvt.tar.lz ]; then mv /var/lib/pkg/tarihce/temel-pkvt.tar.lz /var/lib/pkg/tarihce/temel2-pkvt.tar.lz; fi"
chroot $LFS /bin/bash -c "rm -rf /tmp/*"
chroot $LFS /bin/bash -c "rm -rf /depo/paketler/*"
chroot $LFS /bin/bash -c "mps -tro"
chroot $LFS /bin/bash -c "export LC_ALL='tr_TR.UTF-8'"
chroot $LFS /bin/bash -c "export LANG='tr_TR.UTF-8'"
chroot $LFS /bin/bash -c "xdg-user-dirs-update"
#chroot $LFS /bin/bash -c "if [ -f /usr/bin/lxdm ];then cp -rf /sources/milis.git/ayarlar/servisler/mbd/init.d/lxdm /etc/init.d/; fi"
chroot $LFS /bin/bash -c "cp -rf /sources/milis.git/ayarlar/milbit/milbit.desktop /usr/share/applications/"
chroot $LFS /bin/bash -c "mkdir -p /root/{Desktop,Masaüstü}"
chroot $LFS /bin/bash -c "cp -f /sources/milis.git/ayarlar/kurulum.desktop /root/Desktop/"
chroot $LFS /bin/bash -c "cp -f /sources/milis.git/ayarlar/kurulum.desktop /root/Masaüstü/"
chroot $LFS /bin/bash -c "chmod +x /root/Desktop/*.desktop"
chroot $LFS /bin/bash -c "tamir_touchpad"
chroot $LFS /bin/bash -c "tamir_masaustu"

mesaj bilgi "Ön Hazırlık başarıyla tamamlandı."
mesaj bilgi "ISO oluşturma adımına geçebilirsiniz."