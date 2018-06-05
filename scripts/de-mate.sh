#!/bin/bash

mesaj bilgi "$MASAUSTU kurulum ve ayarlari yapiliyor.."
chroot $LFS /bin/bash -c "mps kur $MASAUSTU"

mesaj bilgi "$MASAUSTU gerekli uygulamalar kuruluyor.."
for gerekli in $(cat $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/apps); do
	if [ ! -d "$LFS/var/lib/pkg/DB/$gerekli" ]; then chroot $LFS /bin/bash -c "mps kur $gerekli"; fi
	if [ ! -d "$LFS/var/lib/pkg/DB/$gerekli" ]; then mesaj hata "$gerekli paketi kurulamadı!";exit 1; fi
done

mesaj bilgi "$MASAUSTU teması yapılandırılıyor"
#chroot $LFS /bin/bash -c "gnome_masaustu_yapilandir"

mesaj bilgi "$MASAUSTU logo tamiri"
chroot $LFS /bin/bash -c "tamir_mate_logo"

# arkaplan resimleri
mkdir -p $LFS/usr/share/backgrounds/milis
cp $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/* $LFS/usr/share/backgrounds/milis/
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/* $LFS/usr/share/backgrounds/milis

# default config
cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/.config $LFS/root/
