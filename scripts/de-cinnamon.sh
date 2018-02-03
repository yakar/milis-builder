#!/bin/bash

mesaj bilgi "$MASAUSTU kurulum ve ayarlari yapiliyor.."
chroot $LFS /bin/bash -c "mps kur $MASAUSTU"

mesaj bilgi "$MASAUSTU gerekli uygulamalar kuruluyor.."

for gerekli in $(cat $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/apps); do
	if [ ! -d "$LFS/var/lib/pkg/DB/$gerekli" ]; then chroot $LFS /bin/bash -c "mps kur $gerekli"; fi
	if [ ! -d "$LFS/var/lib/pkg/DB/$gerekli" ]; then mesaj hata "$gerekli paketi kurulamadı!";exit 1; fi
done


# default config
cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/.config $LFS/root/

# varsayilan arkaplan
cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/milis-linux-arkaplan.png $LFS/sources/milis.git/ayarlar/
cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/milis-linux-arkaplan.png $LFS/root/ayarlar/

# varsayılan milis logo
cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/milislogo.png $LFS/sources/milis.git/ayarlar/
cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/milislogo.png $LFS/root/ayarlar/

# cesitli arkaplanlar
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/* $LFS/usr/share/backgrounds/gnome/
