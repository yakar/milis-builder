#!/bin/bash

mesaj bilgi "$MASAUSTU kurulum ve ayarlari yapiliyor.."
chroot $LFS /bin/bash -c "mps kur $MASAUSTU"

mesaj bilgi "$MASAUSTU gerekli uygulamalar kuruluyor.."
#cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/apps $LFS/tmp
#chroot $LFS /bin/bash -c "mps -kurul /tmp/apps"
for gerekli in $(cat $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/apps); do
	if [ ! -d "$LFS/var/lib/pkg/DB/$gerekli" ]; then chroot $LFS /bin/bash -c "mps kur $gerekli"; fi
	if [ ! -d "$LFS/var/lib/pkg/DB/$gerekli" ]; then mesaj hata "$gerekli paketi kurulamadı!";exit 1; fi
done


# default config
[ -d $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/.config ] && cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/.config $LFS/root/

# varsayilan arkaplan
[ -f $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/milis-linux-arkaplan.png ] && cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/backgrounds/milis-linux-arkaplan.png $LFS/sources/milis.git/ayarlar/

# varsayılan milis logo
[ -f $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/milislogo.png ] && cp -r $BUILDER_ROOT/$OZELLESTIRME/$MASAUSTU/milislogo.png $LFS/sources/milis.git/ayarlar/

