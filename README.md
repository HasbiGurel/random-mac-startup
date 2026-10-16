# Random MAC Startup

Windows'ta seçtiğiniz ağ bağdaştırıcısına **her açılışta rastgele bir MAC adresi** atar.

## Özellikler
- Tek tıkla kurulum (`install.bat`), yönetici iznini kendisi ister
- Kurulumda bağdaştırıcıyı listeden seçme
- Yerel yönetilen (`02-xx-xx-xx-xx-xx`) adresler, gerçek üreticilerle çakışmaz
- Orijinal MAC adresini yedekler, kaldırınca fabrika adresine döner
- Her değişikliği `C:\ProgramData\RandomMac\log.txt` dosyasına yazar

## Kurulum
1. Depoyu indirin (Code → Download ZIP) veya `git clone` ile klonlayın.
2. `install.bat` dosyasına çift tıklayın, yönetici iznini onaylayın.
3. MAC adresi değişecek bağdaştırıcının numarasını seçin.

Komut satırından: `powershell -ExecutionPolicy Bypass -File install.ps1 -AdapterName "Ethernet"`

## Kaldırma
`uninstall.bat` dosyasını çalıştırın. Zamanlanmış görev silinir ve bağdaştırıcı fabrika MAC adresine döner.

## Nasıl çalışır
`RandomMacAtStartup` adlı bir zamanlanmış görev, sistem açılışında SYSTEM yetkisiyle `random-mac.ps1` betiğini çalıştırır.

## Notlar
- Bazı Wi-Fi sürücüleri MAC değiştirmeyi desteklemez; en iyi sonuç kablolu (Ethernet) bağdaştırıcılarda alınır.
- MAC değişince modem/DHCP yeni bir IP verebilir; MAC filtresi olan ağlarda bağlantı kesilebilir.

## Lisans
MIT