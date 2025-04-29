# 📚 Kütüphane Yönetim Sistemi

SQL Server kullanılarak geliştirilen bu proje, temel bir kütüphane yönetim sisteminin veritabanı altyapısını içerir. Kitaplar, yazarlar, üyeler ve emanet işlemlerine yönelik tablo yapıları, örnek veriler ve çeşitli analiz sorguları ile birlikte gelir.

## 🚀 Özellikler

- 📘 Kitap, yazar, üye ve emanet tabloları
- 📥 Örnek veri ekleme işlemleri (`INSERT INTO`)
- 🔄 INNER JOIN ile ilişkisel veri sorguları
- 📅 Teslim edilmeyen ve geciken kitapları listeleme
- 💸 Gecikme durumunda ceza hesaplama (15 gün sonrası, günlük 2₺)
- 🧲 Raf bazında kitap sayımı
- 📊 En çok ödünç alınan kitaplar sıralaması

## 🧹 Veritabanı Yapısı

Aşağıdaki tablolar projede yer almaktadır:

- `Yazarlar` (`yazarId`, `yazarAdi`, `dogumTarihi`)
- `Kitaplar` (`kitapId`, `kitapAdi`, `yazarId`, `yayinTarihi`, `sayfaSayisi`, `rafNo`)
- `Uyeler` (`uyeId`, `adSoyad`, `dogumTarihi`, `kayitTarihi`)
- `Emanetler` (`emanetId`, `kitapId`, `uyeId`, `alisTarihi`, `iadeTarihi`)

## 🧪 Örnek Sorgular

```sql
-- Kütüphanedeki tüm kitaplar ve yazarları
SELECT k.kitapAdi, y.yazarAdi FROM Kitaplar k
INNER JOIN Yazarlar y ON k.yazarId = y.yazarId;

-- Teslim edilmeyen kitaplar
SELECT u.adSoyad, k.kitapAdi FROM Emanetler e
INNER JOIN Kitaplar k ON e.kitapId = k.kitapId
INNER JOIN Uyeler u ON e.uyeId = u.uyeId
WHERE e.iadeTarihi IS NULL;
```

## 🛠️ Gereksinimler

- SQL Server 2019 veya üstü
- SQL Server Management Studio (SSMS)

## 📂 Projeyi Çalıştırmak

1. `CREATE TABLE`, `INSERT INTO` ve sorguları SSMS üzerinde çalıştır.
2. Tablolar oluşturulduktan sonra örnek veriler eklenecektir.
3. Sorgular kısmı ile analizler yapılabilir.

## 📌 Notlar

- `GETDATE()` fonksiyonu sayesinde sistem tarihine göre dinamik sorgular yapılmaktadır.
- Tüm tarih ve metin alanları SQL Server standartlarına uygun şekilde tanımlanmıştır.

## 🤖 Katkıda Bulun

Pull request'ler ve öneriler her zaman açıktır. Lütfen katkı yapmadan önce bir issue açın.

## 📄 Lisans

Bu proje MIT lisansı ile lisanslanmıştır. Daha fazla bilgi için `LICENSE` dosyasına bakabilirsiniz.
