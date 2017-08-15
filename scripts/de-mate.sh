#!/bin/bash

mesaj bilgi "$MASAUSTU kurulum ve ayarlari yapiliyor.."
chroot $LFS /bin/bash -c "mps kur $MASAUSTU"

mesaj bilgi "$MASAUSTU gerekli uygulamalar kuruluyor.."
cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/apps $LFS/tmp
chroot $LFS /bin/bash -c "mps -kurul /tmp/apps"

mesaj bilgi "$MASAUSTU teması yapılandırılıyor"
chroot $LFS /bin/bash -c "gnome_masaustu_yapilandir"

mesaj bilgi "$MASAUSTU logo tamiri"
chroot $LFS /bin/bash -c "tamir_mate_logo"

# arkaplan resimleri
mkdir -p $LFS/usr/share/backgrounds/milis
cp /root/ayarlar/mate/milis-arkaplan/* $LFS/usr/share/backgrounds/milis/
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/* $LFS/usr/share/backgrounds/milis

# default config
cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/.config $LFS/root/
