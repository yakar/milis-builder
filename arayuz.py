#!/usr/bin/env python3
from PyQt5.QtWidgets import (QMainWindow, QApplication, QWidget, QGridLayout, QLineEdit, QLabel, QComboBox, QCheckBox,
                             QTextEdit, QPushButton,QFileDialog,QMessageBox)
from PyQt5.QtCore import QDir,QUrl
import sys,os,subprocess,contextlib

class BuilderPencere(QMainWindow):
    def __init__(self,ebeveyn=None):
        super(BuilderPencere,self).__init__(ebeveyn)
        merkez_widget = QWidget()
        self.setCentralWidget(merkez_widget)
        merkez_kutu = QGridLayout()
        merkez_widget.setLayout(merkez_kutu)

        ac_dugme = QPushButton(self.tr("Ayarlar Aç"))
        ac_dugme.clicked.connect(self.ac_func)
        merkez_kutu.addWidget(ac_dugme,0,0,1,1)
        self.acilan_url = QLineEdit()
        self.acilan_url.setReadOnly(True)
        merkez_kutu.addWidget(self.acilan_url,0,1,1,3)


        merkez_kutu.addWidget(QLabel(self.tr("Dağıtım Adı")),1,0,1,1)
        self.dagitim_adi = QLineEdit()
        merkez_kutu.addWidget(self.dagitim_adi,1,1,1,1)

        merkez_kutu.addWidget(QLabel(self.tr("Dağıtım Kod Adı")),1,2,1,1)
        self.dagitim_kod_adi = QLineEdit()
        merkez_kutu.addWidget(self.dagitim_kod_adi,1,3,1,1)

        merkez_kutu.addWidget(QLabel(self.tr("Versiyon")),2,0,1,1)
        self.versiyon = QLineEdit()
        merkez_kutu.addWidget(self.versiyon,2,1,1,1)

        merkez_kutu.addWidget(QLabel(self.tr("CD/DVD İso Etiketi")),2,2,1,1)
        self.iso_etiketi = QLineEdit()
        merkez_kutu.addWidget(self.iso_etiketi,2,3,1,1)

        merkez_kutu.addWidget(QLabel(self.tr("Masaüstü")),3,0,1,1)
        self.masaustleri = QComboBox()
        self.masaustleri.addItems(["------","xfce4","mate","gnome"])
        merkez_kutu.addWidget(self.masaustleri,3,1,1,1)

        merkez_kutu.addWidget(QLabel(self.tr("Giriş Yöneticileri")),3,2,1,1)
        self.giris_yoneticisi = QComboBox()
        self.giris_yoneticisi.addItems(["------","slim", "mdm", "lxdm"])
        merkez_kutu.addWidget(self.giris_yoneticisi,3,3,1,1)

        merkez_kutu.addWidget(QLabel(self.tr("Host Adı")),4,0,1,1)
        self.host_adi = QLineEdit()
        merkez_kutu.addWidget(self.host_adi,4,1,1,1)

        merkez_kutu.addWidget(QLabel(self.tr("Root Parolası")),4,2,1,1)
        self.root_parolasi = QLineEdit()
        merkez_kutu.addWidget(self.root_parolasi,4,3,1,1)

        self.uefi_desteği = QCheckBox(self.tr("Uefi Desteği Olsun"))
        merkez_kutu.addWidget(self.uefi_desteği,5,0,1,4)

        merkez_kutu.addWidget(QLabel(self.tr("Ek Paketler (Her satıra bir paket gelecek şekilde yazınız)")),6,0,1,4)
        self.ek_paketler = QTextEdit()
        merkez_kutu.addWidget(self.ek_paketler,7,0,1,4)

        merkez_kutu.addWidget(QLabel(self.tr("Dağıtımın özelleştirilmesi için gerekli dosyaların bulunduğu klasör")),8,0,1,4)
        self.ozellestirme = QLineEdit()
        merkez_kutu.addWidget(self.ozellestirme,9,0,1,4)

        merkez_kutu.addWidget(QLabel(self.tr("Dağıtım hazırlanması için kullanılacak klasör yolu. /mnt altında olmamalıdır.")),10,0,1,4)
        self.lfs = QLineEdit()
        merkez_kutu.addWidget(self.lfs,11,0,1,3)
        lfs_klasor_dugme = QPushButton(self.tr("..."))
        lfs_klasor_dugme.clicked.connect(self.lfs_klasor_func)
        merkez_kutu.addWidget(lfs_klasor_dugme,11,3,1,1)

        merkez_kutu.addWidget(QLabel(self.tr("mps.conf yolu isteğe bağlı mps.conf kullanabilmek için")),12,0,1,4)
        self.mpsconf = QLineEdit()
        merkez_kutu.addWidget(self.mpsconf,13,0,1,3)
        mpsconf_dugme = QPushButton(self.tr("..."))
        mpsconf_dugme.clicked.connect(self.mpsconf_klasor_func)
        merkez_kutu.addWidget(mpsconf_dugme,13,3,1,1)

        merkez_kutu.addWidget(QLabel(self.tr("Yerel Paket Sunucusu (isteğe bağlı)")),14,0,1,4)
        self.yerelps = QLineEdit()
        merkez_kutu.addWidget(self.yerelps,15,0,1,3)
        yerelps_dugme = QPushButton(self.tr("..."))
        yerelps_dugme.clicked.connect(self.yerelps_klasor_func)
        merkez_kutu.addWidget(yerelps_dugme,15,3,1,1)

        self.kaydet_dugme = QPushButton(self.tr("Kaydet"))
        self.kaydet_dugme.clicked.connect(self.kaydet)
        merkez_kutu.addWidget(self.kaydet_dugme,16,0,1,2)
        self.farkli_kaydet_dugme = QPushButton(self.tr("Farklı Kaydet"))
        self.farkli_kaydet_dugme.clicked.connect(self.farkli_kaydet)
        merkez_kutu.addWidget(self.farkli_kaydet_dugme,16,2,1,2)

        self.iso_on_hazırlık_dugme = QPushButton(self.tr("Ön Hazırlık"))
        self.iso_on_hazırlık_dugme.clicked.connect(self.iso_on_hazirlik_fonk)
        merkez_kutu.addWidget(self.iso_on_hazırlık_dugme,17,0,1,1)

        self.iso_olustur_dugme = QPushButton(self.tr("İso Oluştur"))
        self.iso_olustur_dugme.setDisabled(True)
        self.iso_olustur_dugme.clicked.connect(self.iso_olustur_fonk)
        merkez_kutu.addWidget(self.iso_olustur_dugme,17,1,1,1)

        self.sadece_iso_olustur_dugme = QPushButton(self.tr("Sadece İso Oluştur"))
        self.sadece_iso_olustur_dugme.clicked.connect(self.sadece_iso_olustur_fonk)
        merkez_kutu.addWidget(self.sadece_iso_olustur_dugme,17,2,1,2)

    def komutCalistirFonksiyon(self, komut):
        try:
            out = subprocess.check_output(komut, stderr=subprocess.STDOUT, shell=True, universal_newlines=True)
            return out.replace("\b", "")
        except subprocess.CalledProcessError as e:
            return e.output

    def iso_on_hazirlik_fonk(self):
        if self.acilan_url.text():
            self.komutCalistirFonksiyon('xterm -hold -e "./builder.sh  {}  -o"'.format(self.acilan_url.text()))
            self.iso_olustur_dugme.setDisabled(False)
        else:
            QMessageBox.warning(self,self.tr("Hata"),self.tr("Bir ayar dosyası seçmediniz veya kaydetmediniz."))

    def iso_olustur_fonk(self):
        if self.acilan_url.text():
            self.komutCalistirFonksiyon('xterm -hold -e "./builder.sh  {}  -i"'.format(self.acilan_url.text()))

    def sadece_iso_olustur_fonk(self):
        if self.acilan_url.text():
            self.komutCalistirFonksiyon('xterm -hold -e "./builder.sh  {}  -si"'.format(self.acilan_url.text()))

    def ac_func(self):
        dosya = QFileDialog.getOpenFileName(self, self.tr("Conf Dosyası Aç"), "./ayarlar","(*.conf)")
        if dosya:
            if dosya != ("",""):
                self.ayarlar_oku(dosya[0])

    def lfs_klasor_func(self):
        dizin = QFileDialog.getExistingDirectory(self, self.tr("LFS klasör ekle"), QDir.homePath(), QFileDialog.ShowDirsOnly)
        if dizin:
            if dizin != ("",""):
                self.lfs.setText(dizin)

    def mpsconf_klasor_func(self):
        dizin = QFileDialog.getExistingDirectory(self, self.tr("LFS klasör ekle"), QDir.homePath(), QFileDialog.ShowDirsOnly)
        if dizin:
            if dizin != ("",""):
                self.mpsconf.setText(dizin)

    def yerelps_klasor_func(self):
        dizin = QFileDialog.getExistingDirectory(self, self.tr("LFS klasör ekle"), QDir.homePath(), QFileDialog.ShowDirsOnly)
        if dizin:
            if dizin != ("",""):
                self.yerelps.setText(dizin)

    def ayarlar_oku(self,url):
        self.acilan_url.setText(url)
        dosya = open(url, "r")
        okunan = dosya.readlines()
        dosya.close()
        for satir in okunan:
            if satir[0:8] == "DAGITIM=":
                self.dagitim_adi.setText(satir[9:-2])
            elif satir[0:7] == "KODADI=":
                self.dagitim_kod_adi.setText(satir[8:-2])
            elif satir[0:9] == "VERSIYON=":
                self.versiyon.setText(satir[10:-2])
            elif satir[0:9] == "MASAUSTU=":
                self.masaustleri.setCurrentText(satir[10:-2])
            elif satir[0:16] == "GIRISYONETICISI=":
                self.giris_yoneticisi.setCurrentText(satir[17:-2])
            elif satir[0:15] == "EXTRA_PAKETLER=":
                self.ek_paketler.setText(satir[16:-2].replace(" ","\n"))
            elif satir[0:9] == "HOSTNAME=":
                self.host_adi.setText(satir[10:-2])
            elif satir[0:14] == "ROOT_PAROLASI=":
                self.root_parolasi.setText(satir[15:-2])
            elif satir[0:11] == "ISO_ETIKET=":
                self.iso_etiketi.setText(satir[12:-2])
            elif satir[0:5] == "UEFI=":
                if satir[6:-2] == "0":
                    self.uefi_desteği.setChecked(False)
                elif satir[6:-2] == "1":
                    self.uefi_desteği.setChecked(True)
            elif satir[0:13] == "OZELLESTIRME=":
                self.ozellestirme.setText(satir[14:-2])
            elif satir[0:4] == "LFS=":
                self.lfs.setText(satir[5:-2])
            elif satir[0:8] == "MPSCONF=":
                self.mpsconf.setText(satir[9:-2])
            elif satir[0:8] == "YERELPS=":
                self.yerelps.setText(satir[9:-2])

    def kaydet(self):
        yazilacak = ""
        if not os.path.exists(self.acilan_url.text()):
            QMessageBox.warning(self,self.tr("Hata"),self.acilan_url.text()+self.tr(" dosyası bulunamadı."))
            return 0
        dosya = open(self.acilan_url.text(), "r")
        okunan = dosya.readlines()
        dosya.close()
        for satir in okunan:
            if satir[0:8] == "DAGITIM=":
                yazilacak += 'DAGITIM="{}"\n'.format(self.dagitim_adi.text())
            elif satir[0:7] == "KODADI=":
                yazilacak += 'KODADI="{}"\n'.format(self.dagitim_kod_adi.text())
            elif satir[0:9] == "VERSIYON=":
                yazilacak += 'VERSIYON="{}"\n'.format(self.versiyon.text())
            elif satir[0:9] == "MASAUSTU=":
                yazilacak += 'MASAUSTU="{}"\n'.format(self.masaustleri.currentText())
            elif satir[0:16] == "GIRISYONETICISI=":
                yazilacak += 'GIRISYONETICISI="{}"\n'.format(self.giris_yoneticisi.currentText())
            elif satir[0:15] == "EXTRA_PAKETLER=":
                yazilacak += 'EXTRA_PAKETLER="{}"\n'.format(self.ek_paketler.toPlainText().replace("\n"," "))
            elif satir[0:9] == "HOSTNAME=":
                yazilacak += 'HOSTNAME="{}"\n'.format(self.host_adi.text())
            elif satir[0:14] == "ROOT_PAROLASI=":
                yazilacak += 'ROOT_PAROLASI="{}"\n'.format(self.root_parolasi.text())
            elif satir[0:11] == "ISO_ETIKET=":
                yazilacak += 'ISO_ETIKET="{}"\n'.format(self.iso_etiketi.text())
            elif satir[0:5] == "UEFI=":
                if self.uefi_desteği.isChecked():
                    yazilacak += 'UEFI="1"\n'
                else:
                    yazilacak += 'UEFI="0"\n'
            elif satir[0:13] == "OZELLESTIRME=":
                yazilacak += 'OZELLESTIRME="{}"\n'.format(self.ozellestirme.text())
            elif satir[0:4] == "LFS=":
                yazilacak+='LFS="{}"\n'.format(self.lfs.text())
            elif satir[0:8] == "MPSCONF=":
                yazilacak+='MPSCONF="{}"\n'.format(self.mpsconf.text())
            elif satir[0:8] == "YERELPS=":
                yazilacak+='YERELPS="{}"\n'.format(self.yerelps.text())
            else:
                yazilacak+=satir
        dosya = open(self.acilan_url.text(), "w")
        dosya.write(yazilacak)
        dosya.close()
        QMessageBox.information(self,self.tr("Başarılı"),self.tr("Yazma işlemi başarıyla tamamlandı"))

    def farkli_kaydet(self):
        yazilacak = ""
        yazilacak += 'DAGITIM="{}"\n'.format(self.dagitim_adi.text())
        yazilacak += 'KODADI="{}"\n'.format(self.dagitim_kod_adi.text())
        yazilacak += 'VERSIYON="{}"\n'.format(self.versiyon.text())
        yazilacak += 'MASAUSTU="{}"\n'.format(self.masaustleri.currentText())
        yazilacak += 'GIRISYONETICISI="{}"\n'.format(self.giris_yoneticisi.currentText())
        yazilacak += 'EXTRA_PAKETLER="{}"\n'.format(self.ek_paketler.toPlainText().replace("\n", " "))
        yazilacak += 'HOSTNAME="{}"\n'.format(self.host_adi.text())
        yazilacak += 'ROOT_PAROLASI="{}"\n'.format(self.root_parolasi.text())
        yazilacak += 'ISO_ETIKET="{}"\n'.format(self.iso_etiketi.text())
        if self.uefi_desteği.isChecked():
            yazilacak += 'UEFI="1"\n'
        else:
            yazilacak += 'UEFI="0"\n'
        yazilacak += 'OZELLESTIRME="{}"\n'.format(self.ozellestirme.text())
        yazilacak += 'LFS="{}"\n'.format(self.lfs.text())
        yazilacak += 'MPSCONF="{}"\n'.format(self.mpsconf.text())
        yazilacak += 'YERELPS="{}"\n'.format(self.yerelps.text())
        kaydet = QFileDialog.getSaveFileUrl(self, self.tr("Conf Dosyası Kaydet"), "./ayarlar","(*.conf)")
        if kaydet:
            if kaydet != (QUrl(''), ''):
                url = kaydet[0].toString()[7:]
                if url.split(".")[-1] != "conf":
                    url += ".conf"
                dosya = open(url, "w+")
                dosya.write(yazilacak)
                dosya.close()
                self.ayarlar_oku(url)
                QMessageBox.information(self, self.tr("Başarılı"), self.tr("Yazma işlemi başarıyla tamamlandı"))

if __name__ == "__main__":
    uygulama = QApplication(sys.argv)
    uygulama.setOrganizationName('Milis Builder')
    uygulama.setApplicationName('Milis Builder')
    merkezPencere = BuilderPencere()
    merkezPencere.show()
    sys.exit(uygulama.exec_())