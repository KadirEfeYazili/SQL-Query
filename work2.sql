-- Veritabanı Oluşturma
CREATE DATABASE IF NOT EXISTS ödev;

-- Veritabanını Seçme
USE ödev;

-- Bölüm Tablosu Oluşturma
CREATE TABLE IF NOT EXISTS Bolum (
    BNO INT PRIMARY KEY,
    BADI VARCHAR(100),
    YERI VARCHAR(100)
);

-- Çalışan Tablosu Oluşturma
CREATE TABLE IF NOT EXISTS Calisan (
    CalisanNO INT PRIMARY KEY,
    CAdi VARCHAR(100),
    CSoyadi VARCHAR(100),
    BNO INT,
    FOREIGN KEY (BNO) REFERENCES Bolum (BNO)
);

-- Proje Tablosu Oluşturma
CREATE TABLE IF NOT EXISTS Proje (
    PNO INT PRIMARY KEY,
    ProjeAdi VARCHAR(100),
    Butce DECIMAL(10, 2)
);

-- Çalıştığı Proje Tablosu Oluşturma
CREATE TABLE IF NOT EXISTS CalistigiProje (
    CalistigiProjeNO INT PRIMARY KEY,
    BaslamaTarihi INT(4),
    Islem VARCHAR(200),
    CalisanNO INT,
    PNO INT,
    FOREIGN KEY (CalisanNO) REFERENCES Calisan (CalisanNO),
    FOREIGN KEY (PNO) REFERENCES Proje (PNO)
);

-- Bölüm Tablosuna Veri Ekleme
INSERT INTO Bolum (BNO, BADI, YERI)
VALUES (1, 'Yazılım', 'İstanbul'),
       (2, 'Pazarlama', 'Ankara'),
       (3, 'İnsan Kaynakları', 'İzmir');

-- Çalışan Tablosuna Veri Ekleme
INSERT INTO Calisan (CalisanNO, CAdi, CSoyadi, BNO)
VALUES (101, 'Ali', 'Yılmaz', 1),
       (102, 'Mehmet', 'Çelik', 2),
       (103, 'Ayşe', 'Kaya', 3);

-- Proje Tablosuna Veri Ekleme
INSERT INTO Proje (PNO, ProjeAdi, Butce)
VALUES (1001, 'Yazılım Geliştirme', 50000.00),
       (1002, 'Pazarlama Kampanyası', 30000.00),
       (1003, 'Yeni İnsan Kaynağı Yönetim Sistemi', 20000.00);

-- Çalıştığı Proje Tablosuna Veri Ekleme
INSERT INTO CalistigiProje (CalistigiProjeNO, BaslamaTarihi, Islem, CalisanNO, PNO)
VALUES (1, 2023, 'Yazılım geliştirme', 101, 1001),
       (2, 2024, 'Pazarlama analizleri', 102, 1002),
       (3, 2023, 'İK sistemi tasarımı', 103, 1003);

-- 1. Tüm çalışanları listeler
SELECT * FROM Calisan;

-- 2. Her bölümdeki çalışan sayısını gösterir (COUNT)
SELECT BNO, COUNT(CalisanNO) AS CalisanSayisi FROM Calisan GROUP BY BNO;

-- 3. Projelerin adını ve bütçesini listeler (DISTINCT)
SELECT DISTINCT ProjeAdi, Butce FROM Proje;

-- 4. Çalışanların ad ve soyadını listeler (ORDER BY)
SELECT CAdi, CSoyadi FROM Calisan ORDER BY CAdi;

-- 5. Her projenin bütçesinin toplamını hesaplar (SUM)
SELECT SUM(Butce) AS ToplamButce FROM Proje;

-- 6. Bütçesi 60000'den büyük olan projeleri listeler (HAVING)
SELECT ProjeAdi, Butce FROM Proje GROUP BY ProjeAdi HAVING Butce > 60000;

-- 7. İstanbul'da yer alan bölümleri listeler (WHERE)
SELECT * FROM Bolum WHERE YERI = 'İstanbul';

-- 8. Çalışanların projelerdeki görevlerini listeler (JOIN)
SELECT Calisan.CAdi, Calisan.CSoyadi, CalistigiProje.Islem 
FROM Calisan 
JOIN CalistigiProje ON Calisan.CalisanNO = CalistigiProje.CalisanNO;

-- 9. 2023 yılında başlayan projeleri listeler (YEAR() Fonksiyonu)
SELECT * FROM CalistigiProje WHERE YEAR(BaslamaTarihi) = 2023;

-- 10. En yüksek bütçeye sahip projeyi bulur (LIMIT ve ORDER BY)
SELECT * FROM Proje ORDER BY Butce DESC LIMIT 1;

-- 11. Bölümlerin yerlerine göre gruplandırarak gösterir (GROUP BY)
SELECT YERI, COUNT(*) AS BolumSayisi FROM Bolum GROUP BY YERI;

-- 12. Çalışan numarasına göre çalışanları sıralı listeler (ORDER BY)
SELECT * FROM Calisan ORDER BY CalisanNO;

-- 13. Projeye göre çalışanları listeler (INNER JOIN)
SELECT CalistigiProje.PNO, Calisan.CAdi, Calisan.CSoyadi 
FROM CalistigiProje 
INNER JOIN Calisan ON CalistigiProje.CalisanNO = Calisan.CalisanNO;

-- 14. Çalışanların bölüm adlarını gösterir (JOIN ve GROUP_CONCAT)
SELECT Calisan.CAdi, Calisan.CSoyadi, GROUP_CONCAT(Bolum.BAdi) AS BolumAdi 
FROM Calisan 
JOIN Bolum ON Calisan.BNO = Bolum.BNO
GROUP BY Calisan.CalisanNO;

-- 15. Tüm projelerde çalışanların sayısını gösterir (COUNT ve GROUP BY)
SELECT PNO, COUNT(*) AS CalisanSayisi FROM CalistigiProje GROUP BY PNO;

-- 16. Çalışanların bulunduğu projelerin bütçelerini listeler (JOIN ve SELECT DISTINCT)
SELECT DISTINCT Calisan.CAdi, Calisan.CSoyadi, Proje.Butce 
FROM CalistigiProje 
JOIN Calisan ON CalistigiProje.CalisanNO = Calisan.CalisanNO 
JOIN Proje ON CalistigiProje.PNO = Proje.PNO;

-- 17. En eski projeyi bulur (ORDER BY ve LIMIT)
SELECT * FROM CalistigiProje ORDER BY BaslamaTarihi ASC LIMIT 1;

-- 18. Bölüm başına düşen ortalama bütçeyi hesaplar (AVG ve JOIN)
SELECT BNO, AVG(Butce) AS OrtalamaButce 
FROM CalistigiProje 
JOIN Proje ON CalistigiProje.PNO = Proje.PNO 
GROUP BY BNO;

-- 19. Çalışan başına düşen proje sayısını gösterir (COUNT ve GROUP BY)
SELECT CalisanNO, COUNT(*) AS ProjeSayisi FROM CalistigiProje GROUP BY CalisanNO;

-- 20. Her bölümdeki projelerin toplam bütçesini gösterir (SUM, JOIN ve GROUP BY)
SELECT Bolum.BAdi, SUM(Proje.Butce) AS ToplamButce 
FROM Bolum 
JOIN Calisan ON Bolum.BNO = Calisan.BNO 
JOIN CalistigiProje ON Calisan.CalisanNO = CalistigiProje.CalisanNO 
JOIN Proje ON CalistigiProje.PNO = Proje.PNO 
GROUP BY Bolum.BAdi;

-- 21. Projelerin bütçe ortalamasını hesaplar (AVG)
SELECT AVG(Butce) AS OrtalamaButce FROM Proje;

-- 22. Aynı bölümde çalışanların listesini gösterir (WHERE ve DISTINCT)
SELECT DISTINCT CAdi, CSoyadi FROM Calisan WHERE BNO = 1;

-- 23. Bölüm başına düşen çalışan sayısını gösterir (LEFT JOIN ve GROUP BY)
SELECT Bolum.BAdi, COUNT(Calisan.CalisanNO) AS CalisanSayisi 
FROM Bolum 
LEFT JOIN Calisan ON Bolum.BNO = Calisan.BNO 
GROUP BY Bolum.BAdi;

-- 24. Her projede görev alan çalışanların bilgilerini gösterir (JOIN)
SELECT Proje.ProjeAdi, Calisan.CAdi, Calisan.CSoyadi 
FROM CalistigiProje
JOIN Proje ON CalistigiProje.PNO = Proje.PNO
JOIN Calisan ON CalistigiProje.CalisanNO = Calisan.CalisanNO;

-- 25. Çalışanların hangi projelerde çalıştığını ve projelerin bütçelerini listeler (JOIN ve SELECT DISTINCT)
SELECT Calisan.CAdi, Calisan.CSoyadi, Proje.ProjeAdi, Proje.Butce
FROM CalistigiProje
JOIN Calisan ON CalistigiProje.CalisanNO = Calisan.CalisanNO
JOIN Proje ON CalistigiProje.PNO = Proje.PNO;
