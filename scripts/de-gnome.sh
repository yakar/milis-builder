#!/bin/bash

mesaj bilgi "$MASAUSTU kurulum ve ayarlari yapiliyor.."
chroot $LFS /bin/bash -c "mps kur $MASAUSTU"

mesaj bilgi "$MASAUSTU gerekli uygulamalar kuruluyor.."
for gerekli in $(cat $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/apps); do
	if [ ! -d "$LFS/var/lib/pkg/DB/$gerekli" ]; then chroot $LFS /bin/bash -c "mps kur $gerekli"; fi
	if [ ! -d "$LFS/var/lib/pkg/DB/$gerekli" ]; then mesaj hata "$gerekli paketi kurulamadı!";exit 1; fi
done
chroot $LFS /bin/bash -c "mps sil python-gobject && mps kur python-gobject && mps sil emacs && mps sil gdb"

mesaj bilgi "Gnome teması yapılandırılıyor"
#chroot $LFS /bin/bash -c "gnome_masaustu_yapilandir"

# default config
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/.config $LFS/root/

# varsayilan arkaplan
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/milis-linux-arkaplan.png $LFS/sources/milis.git/ayarlar/

# varsayılan milis logo
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/milislogo.png $LFS/sources/milis.git/ayarlar/

# cesitli arkaplanlar
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/* $LFS/usr/share/backgrounds/xfce/
