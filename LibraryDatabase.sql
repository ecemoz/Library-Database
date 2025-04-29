-- Kütüphane Yönetimi 

DROP TABLE IF EXISTS Emanetler;
DROP TABLE IF EXISTS Kitaplar;
DROP TABLE IF EXISTS Uyeler;
DROP TABLE IF EXISTS Yazarlar;

CREATE TABLE Yazarlar (
    yazarId INT PRIMARY KEY IDENTITY(1,1),
    yazarAdi NVARCHAR(100),
    dogumTarihi DATE
);

CREATE TABLE Kitaplar (
    kitapId INT PRIMARY KEY IDENTITY(1,1),
    kitapAdi NVARCHAR(150),
    yazarId INT,
    yayinTarihi DATE,
    sayfaSayisi INT,
    rafNo NVARCHAR(10),
    FOREIGN KEY (yazarId) REFERENCES Yazarlar(yazarId)
);

CREATE TABLE Uyeler (
    uyeId INT PRIMARY KEY IDENTITY(1,1),
    adSoyad NVARCHAR(100),
    dogumTarihi DATE,
    kayitTarihi DATE
);

CREATE TABLE Emanetler (
    emanetId INT PRIMARY KEY IDENTITY(1,1),
    kitapId INT,
    uyeId INT,
    alisTarihi DATE,
    iadeTarihi DATE NULL,
    FOREIGN KEY (kitapId) REFERENCES Kitaplar(kitapId),
    FOREIGN KEY (uyeId) REFERENCES Uyeler(uyeId)
);

INSERT INTO Yazarlar (yazarAdi, dogumTarihi) VALUES
('Ali Yılmaz', '1980-05-10'),
('Veli Demir', '1975-08-22'),
('Ayşe Kaya', '1990-02-17');

INSERT INTO Kitaplar (kitapAdi, yazarId, yayinTarihi, sayfaSayisi, rafNo) VALUES
('Veritabanı Sistemleri', 1, '2020-01-01', 320, 'A1'),
('Programlamaya Giriş', 2, '2019-03-15', 250, 'B3'),
('İleri SQL', 1, '2021-07-20', 400, 'A2'),
('Algoritmalar', 3, '2018-09-10', 150, 'C1');

INSERT INTO Uyeler (adSoyad, dogumTarihi, kayitTarihi) VALUES
('Ahmet Çelik', '2000-04-05', '2024-01-01'),
('Zeynep Aksoy', '1998-11-22', '2024-02-15');

INSERT INTO Emanetler (kitapId, uyeId, alisTarihi) VALUES
(1, 1, '2024-04-01'),
(3, 2, '2024-04-10');

INSERT INTO Emanetler (kitapId, uyeId, alisTarihi, iadeTarihi)
VALUES (2, 1, GETDATE(), DATEADD(DAY, 15, GETDATE()));


-- 1. Kütüphanedeki kitaplar ve yazarları
SELECT k.kitapAdi, y.yazarAdi, k.sayfaSayisi, k.rafNo
FROM Kitaplar k
INNER JOIN Yazarlar y ON k.yazarId = y.yazarId;

-- 2. Hangi üye hangi kitabı almış
SELECT u.adSoyad, k.kitapAdi, e.alisTarihi, e.iadeTarihi
FROM Emanetler e
INNER JOIN Kitaplar k ON e.kitapId = k.kitapId
INNER JOIN Uyeler u ON e.uyeId = u.uyeId;

-- 3. Raflara göre kitap sayısı
SELECT rafNo, COUNT(*) AS KitapSayisi
FROM Kitaplar
GROUP BY rafNo;

-- 4. Teslim edilmeyen kitaplar
SELECT u.adSoyad AS UyeAdi, k.kitapAdi AS KitapAdi, e.alisTarihi AS AlisTarihi
FROM Emanetler e
INNER JOIN Kitaplar k ON e.kitapId = k.kitapId
INNER JOIN Uyeler u ON e.uyeId = u.uyeId
WHERE e.iadeTarihi IS NULL;

-- 5. Geciken kitaplar (30 günü geçen)
SELECT u.adSoyad AS UyeAdi, k.kitapAdi AS KitapAdi, e.alisTarihi,
       DATEDIFF(DAY, e.alisTarihi, GETDATE()) AS GecenGun
FROM Emanetler e
INNER JOIN Kitaplar k ON e.kitapId = k.kitapId
INNER JOIN Uyeler u ON e.uyeId = u.uyeId
WHERE e.iadeTarihi IS NULL AND DATEDIFF(DAY, e.alisTarihi, GETDATE()) > 30;

-- 6. En çok ödünç alınan kitaplar
SELECT k.kitapAdi, COUNT(*) AS OduncSayisi
FROM Emanetler e
INNER JOIN Kitaplar k ON e.kitapId = k.kitapId
GROUP BY k.kitapAdi
ORDER BY OduncSayisi DESC;

-- 7. Ceza hesaplama (15 gün sonrası, günlük 2₺)
SELECT u.adSoyad AS UyeAdi, k.kitapAdi, e.alisTarihi,
       DATEDIFF(DAY, e.alisTarihi, GETDATE()) AS GecenGun,
       CASE 
           WHEN DATEDIFF(DAY, e.alisTarihi, GETDATE()) > 15 THEN 
               (DATEDIFF(DAY, e.alisTarihi, GETDATE()) - 15) * 2
           ELSE 0 
       END AS CezaTL
FROM Emanetler e
INNER JOIN Kitaplar k ON e.kitapId = k.kitapId
INNER JOIN Uyeler u ON e.uyeId = u.uyeId
WHERE e.iadeTarihi IS NULL;