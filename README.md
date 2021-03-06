# milis-builder
Milis Linux tabanlı dağıtım hazırlama işlemlerini hızlandırmak için hazırladığımız uygulama.

Mevcut sürüm Milis Linux dağıtımı altında çalışmaktadır. İleriki sürümlerde diğer dağıtımlarda da çalışacak şekilde gerekli geliştirmeler planlanmaktadır.

Desteklenen masaüstleri:
- xfce4

Login yöneticisi:
- slim


```
Milis Builder 2017.11

Genel Parametreler
        -t | --temizle
        Tüm çalışmaları siler ve çalışmaya sıfırdan başlamanızı sağlar. Silme işlemi geri alınamaz.

        -o | --onhazirlik
        Gerekli klasör yapısını oluşturur, temel paketlerin indirilmesi ve kurulması işlemleri yapar.

        -i | --iso
        Son aşamadır, dağıtımı iso formatına çevirir. Öncesinde --onhazirlik ile gerekli temel paketlerin kurulmuş olması gerekmektedir.

        -si | --sadece-iso
        SquashFS oluşturma adımını atlayarak iso oluşturmaktadır. SquashFS'nin oluşturulmuş olması gerekmektedir.

        -c | --chroot
        Ön hazırlığı yapılmış dağıtım için elle müdahale imkanı tanır.

        -q | --qemu <iso> <ram kb>
        Çıkarılan ISO dosyasının test edilmesini sağlar. Ram miktarı isteğe bağlı olarak belirtilebilir, belirtilmez ise 1024 Kb olarak değerlendirilecektir.

        -y | --yardim
        Bu yardım metnini görüntüler.

Nasıl Kullanılır?:
        Öncelikle de/ içerisinde özelleştirmek istediğiniz ayarları/resimleri vb. düzenlemelisiniz. Ardından ayarlar/ayarlar.conf içerisinde yer alan dağıtım ile ilgili bilgiler kısmını düzenlemelisiniz. Düzenleme işlemi tamamlandıktan sonra;
        
        1) Ön Hazırlık: ./builder.sh -o ayarlar/ayarlar.conf
        2) ISO Oluştur: ./builder.sh -i ayarlar/ayarlar.conf

        Eğer 1. adım sonrası daha fazla özelleştirmeyi canlı sistem üzerinde yapmak isterseniz -c parametresi ile sisteme giriş yaparak (chroot) istediğiniz ekstra düzenlemeleri yapabilirsiniz ve ardından 2. adıma geçebilirsiniz. ayarlar/ klasöründe istediğiniz kadar ayar dosyası oluşturabilirsiniz ve 1. ve 2. adımlarda bu dosyaları yolu ile birlikte belirtebilirsiniz.

        NOT: Builder sürekli güncellendiğinden iso oluşturmadan önce son değişiklikleri `git pull` ile aldığınızdan emin olunuz. ayarlar.conf dosyası örnek ayarları/değerleri içerdiğinden dosyanın kopyasını alıp üzerinde değişikliğe gitmeniz tavsiye edilir.


Yerel Paket Sistemi:
        -yo | --yps-olustur
        Yerel paket sunucusu oluşturmak için kullanılır. Dağıtım hazırlama sırasında tekrar tekrar tüm paketlerin indirilmesi istenmiyorsa bu seçenek kullanılabilir. Fakat unutulmamalıdır ki kullanmasanız da sunucuda bulunan tüm paketler indirilecektir.

        -yb | --yps-baslat
        Oluşturulmuş olan Yerel Paket Sistemi (--yps-olustur) başlatılacaktır.

        -yd | --yps-durdur
        Başlatılan Yerel Paket Sistemi (--yps-baslat) durdurulacaktır.

        -yg | --yps-guncelle
        Yerel Paket Sistemi ile Miilis Paket Sunucusunu eşitler.

        -yk | --yps-kontrol
        Yerel Paket Sistemi yolu, veritabanı kontrolü, çalışıp çalışmadığı gibi kontrolleri sağlar.
```
