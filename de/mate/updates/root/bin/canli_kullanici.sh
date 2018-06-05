groupadd -r autologin
gpasswd -a canlikullanici autologin

chown lightdm:lightdm /var/lib/lightdm
chown lightdm:lightdm /var/lib/lightdm-data
chown canlikullanici:canlikullanici -R /home/canlikullanici

#git_ssl_tamir
git config --global http.sslCAinfo /etc/ssl/ca-bundle.crt
mv /.gitconfig /home/canlikullanici/
rm -rf /etc/rc.d/init.d/lightdm
mv /etc/rc.d/init.d/lightdm.orj /etc/rc.d/init.d/lightdm
