mesaj bilgi "$GIRISYONETICISI kurulum ve ayarları"

if [ ! -d "$LFS/var/lib/pkg/DB/$GIRISYONETICISI" ]; then chroot $LFS /bin/bash -c "mps kur $GIRISYONETICISI"; fi

# arkaplan
cp -r $BUILDER_ROOT/$OZELLESTIRME/slim/panel.png $LFS/usr/share/slim/themes/milis/

# .xinitrc
cp $BUILDER_ROOT/$OZELLESTIRME/$GIRISYONETICISI/.xinitrc $LFS/root/.xinitrc
case "$MASAUSTU" in
	"xfce4")
		sed -i "s/^DEFAULTSESSION.*/DEFAULTSESSION=xfce4-session/g" $LFS/root/.xinitrc
		;;
	"gnome")
		sed -i "s/^DEFAULTSESSION.*/DEFAULTSESSION=gnome-session/g" $LFS/root/.xinitrc
		;;
	"mate")
		sed -i "s/^DEFAULTSESSION.*/DEFAULTSESSION=mate-session/g" $LFS/root/.xinitrc
		;;
	"kde")
		sed -i "s/^DEFAULTSESSION.*/DEFAULTSESSION=startkde/g" $LFS/root/.xinitrc
		;;
	"cinnamon")
		sed -i "s/^DEFAULTSESSION.*/DEFAULTSESSION=gnome-session-cinnamon/g" $LFS/root/.xinitrc
		;;
	"openbox")
		sed -i "s/^DEFAULTSESSION.*/DEFAULTSESSION=openbox-session/g" $LFS/root/.xinitrc
		;;
	"lxqt")
		sed -i "s/^DEFAULTSESSION.*/DEFAULTSESSION=lxqt-session/g" $LFS/root/.xinitrc
		;;
	"lxde")
		sed -i "s/^DEFAULTSESSION.*/DEFAULTSESSION=lxsession/g" $LFS/root/.xinitrc
		;;
esac