#!/bin/bash

mesaj bilgi "$MASAUSTU kurulum ve ayarlari yapiliyor.."
chroot $LFS /bin/bash -c "mps kur $MASAUSTU"

mesaj bilgi "$MASAUSTU gerekli uygulamalar kuruluyor.."
cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/apps $LFS/tmp
chroot $LFS /bin/bash -c "mps -kurul /tmp/apps"

mesaj bilgi "Gnome teması yapılandırılıyor"
chroot $LFS /bin/bash -c "gnome_masaustu_yapilandir"

# default config
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/.config $LFS/root/

# varsayilan arkaplan
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/milis-linux-arkaplan.png $LFS/sources/milis.git/ayarlar/

# varsayılan milis logo
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/milislogo.png $LFS/sources/milis.git/ayarlar/

# cesitli arkaplanlar
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/* $LFS/usr/share/backgrounds/xfce/