# Xbox 360 ISO Extractor (macOS)

Bu uygulama, Xbox 360 ISO dosyalarını çıkarmak için kullanılan modern bir macOS uygulamasıdır. SwiftUI kullanılarak geliştirilmiştir.

## Özellikler

- Modern ve kullanıcı dostu arayüz
- ISO dosyası seçimi için dosya tarayıcısı
- Hedef klasör seçimi
- Gerçek zamanlı çıkarma durumu göstergesi
- Hata yönetimi ve kullanıcı bildirimleri
- macOS 13.0+ uyumluluğu

## Gereksinimler

- macOS 13.0 veya üzeri
- Xcode 15.0 veya üzeri (geliştirme için)

## Kurulum

1. Projeyi Xcode'da açın
2. `XboxISOExtractor.xcodeproj` dosyasını çift tıklayın
3. Build edin (⌘+B)
4. Uygulamayı çalıştırın (⌘+R)

## Kullanım

1. "Gözat" butonuna tıklayarak ISO dosyasını seçin
2. İkinci "Gözat" butonuna tıklayarak hedef klasörü seçin
3. "ISO'yu Çıkar" butonuna tıklayarak çıkarma işlemini başlatın
4. İşlem tamamlandığında bildirim alacaksınız

## Teknik Detaylar

- **Framework**: SwiftUI
- **Dil**: Swift 5.0
- **Minimum macOS Sürümü**: 13.0
- **Arka Plan İşlem**: extract-xiso binary kullanılarak

## Lisans

Bu proje MIT lisansı altında lisanslanmıştır.

## Katkıda Bulunma

1. Fork edin
2. Feature branch oluşturun (`git checkout -b feature/AmazingFeature`)
3. Commit edin (`git commit -m 'Add some AmazingFeature'`)
4. Push edin (`git push origin feature/AmazingFeature`)
5. Pull Request oluşturun 