mesaj bilgi "$GIRISYONETICISI kurulum ve ayarları"

if [ ! -d "$LFS/var/lib/pkg/DB/$GIRISYONETICISI" ]; then chroot $LFS /bin/bash -c "mps kur $GIRISYONETICISI"; fi

# arkaplan
cp -r $BUILDER_ROOT/$OZELLESTIRME/slim/background.png $LFS/usr/share/slim/themes/milis/

# .xinitrc
cp $BUILDER_ROOT/$OZELLESTIRME/$GIRISYONETICISI/.xinitrc $LFS/root/.xinitrc
case "$MASAUSTU" in
	"xfce4")
		sed -i "s/^ONTANIMLI_OTURUM.*/ONTANIMLI_OTURUM=xfce4-session/g" $LFS/root/.xinitrc
		;;
	"gnome")
		sed -i "s/^ONTANIMLI_OTURUM.*/ONTANIMLI_OTURUM=gnome-session/g" $LFS/root/.xinitrc
		;;
	"mate")
		sed -i "s/^ONTANIMLI_OTURUM.*/ONTANIMLI_OTURUM=mate-session/g" $LFS/root/.xinitrc
		;;
	"kde")
		sed -i "s/^ONTANIMLI_OTURUM.*/ONTANIMLI_OTURUM=startkde/g" $LFS/root/.xinitrc
		;;
	"cinnamon")
		sed -i "s/^ONTANIMLI_OTURUM.*/ONTANIMLI_OTURUM=gnome-session-cinnamon/g" $LFS/root/.xinitrc
		;;
	"openbox")
		sed -i "s/^ONTANIMLI_OTURUM.*/ONTANIMLI_OTURUM=openbox-session/g" $LFS/root/.xinitrc
		;;
	"lxqt")
		sed -i "s/^ONTANIMLI_OTURUM.*/ONTANIMLI_OTURUM=lxqt-session/g" $LFS/root/.xinitrc
		;;
	"lxde")
		sed -i "s/^ONTANIMLI_OTURUM.*/ONTANIMLI_OTURUM=lxsession/g" $LFS/root/.xinitrc
		;;
esac
