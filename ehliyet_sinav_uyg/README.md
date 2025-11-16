# Ehliyet Sınav Uygulaması

Bu proje, Flutter ile geliştirilmiş bir ehliyet sınavı hazırlık uygulamasıdır. Kullanıcıların ehliyet sınavına hazırlanmalarına yardımcı olmak amacıyla çeşitli kategorilerde sorular sunar, deneme sınavları yapma imkanı sağlar ve sonuçları takip etmelerine olanak tanır.

## Özellikler

*   **Kategori Bazlı Testler:** Trafik ve Çevre, Motor ve Araç Tekniği, İlk Yardım, Trafik Adabı gibi kategorilerde sorular.
*   **Deneme Sınavları:** Belirli sayıda soru ve zaman sınırlaması ile gerçek sınav deneyimi.
*   **Yanıt Gözden Geçirme:** Sınav sonrası doğru/yanlış yanıtları ve açıklamaları gözden geçirme.
*   **Yer İmleri:** Önemli veya tekrar bakılması gereken soruları işaretleme.
*   **Ayarlar:** Soru ve şık karıştırma, zamanlayıcı etkinleştirme/devre dışı bırakma ve tema seçimi (aydınlık/karanlık) gibi kişiselleştirme seçenekleri.
*   **Yerel JSON Verisi:** Sorular yerel JSON dosyalarından okunur. Gelecekte harici bir kaynaktan (API, Google Sheets vb.) veri çekme yeteneği eklenebilir.

## Kurulum

Projeyi yerel makinenizde çalıştırmak için aşağıdaki adımları izleyin:

1.  **Flutter SDK Kurulumu:**
    Flutter SDK'sını henüz kurmadıysanız, [resmi Flutter web sitesinden](https://flutter.dev/docs/get-started/install) işletim sisteminize uygun kurulumu yapın.

2.  **Projeyi Klonlayın:**
    ```bash
    git clone <proje_deposu_url>
    cd ehliyet_sinav_uyg
    ```
    *(Not: Bu proje bir git deposu olarak başlatılmadı, bu adım sadece genel bir örnektir. Eğer bir git deposundan klonladıysanız bu adımı kullanın.)*

3.  **Bağımlılıkları Yükleyin:**
    Proje bağımlılıklarını yüklemek için aşağıdaki komutu çalıştırın:
    ```bash
    flutter pub get
    ```

4.  **Uygulamayı Çalıştırın:**
    Tercih ettiğiniz bir emülatör veya fiziksel cihazda uygulamayı başlatın:
    ```bash
    flutter run
    ```

## Proje Yapısı

```
lib/
├── core/
│   ├── theme/          # Uygulama temaları (aydınlık/karanlık)
│   └── utils/          # Yardımcı fonksiyonlar ve araçlar
├── data/
│   ├── models/         # Veri modelleri (örn. Question)
│   ├── repositories/   # Veri çekme mantığı (örn. QuestionRepository)
│   └── sources/        # Yerel JSON yükleyici
├── features/           # Uygulama ekranları ve ilgili widget'lar
│   ├── bookmarks/      # Yer imleri ekranı
│   ├── category/       # Kategori seçimi ekranı
│   ├── home/           # Ana ekran
│   ├── quiz/           # Sınav ekranı ve widget'ları
│   ├── result/         # Sonuç ekranı
│   ├── review/         # Yanıtları gözden geçirme ekranı
│   └── settings/       # Ayarlar ekranı
└── providers/          # Durum yönetimi için Provider sınıfları
    ├── bookmarks_provider.dart
    ├── quiz_provider.dart
    └── settings_provider.dart
```

## JSON Şeması

Uygulama, `assets/data/` klasöründeki JSON dosyalarından soruları okur. Her bir JSON dosyası, aşağıdaki şemaya uygun bir soru listesi içerir:

```json
[
  {
    "id": 1,
    "kategori": "Trafik ve Çevre",
    "soru": "Emniyet kemerinin temel amacı nedir?",
    "secenekler": {
      "A": "Sadece ceza almamak için",
      "B": "Trafik akışını hızlandırmak için",
      "C": "Can ve mal güvenliğini sağlamak için",
      "D": "Diğer sürücüleri etkilemek için"
    },
    "dogru": "C",
    "aciklama": "Kısa rasyonel açıklama (opsiyonel)"
  }
]
```

## Gelecek Geliştirmeler (TODO)

*   **Harici Veri Kaynağı:** Soruları bir API, Google Sheets veya Firebase gibi harici bir kaynaktan çekme yeteneği.
*   **Zamanlayıcı Fonksiyonelliği:** Sınav ekranında zamanlayıcıyı tam olarak uygulama.
*   **Son Çalışma:** Kullanıcının en son kaldığı yerden devam etme özelliği.
*   **Gelişmiş İstatistikler:** Kullanıcı performansını gösteren daha detaylı grafikler ve istatistikler.
*   **Yer İmlerine Ekleme Mantığı:** Sonuç ekranında yanlış veya boş bırakılan soruları otomatik olarak yer imlerine ekleme.