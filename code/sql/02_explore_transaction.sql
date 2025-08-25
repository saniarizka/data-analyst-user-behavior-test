-- periode waktu transaksi
SELECT MAX(date_tr) FROM transaction;
SELECT MIN(date_tr) FROM transaction;

-- liat preferensi transaksi
SELECT 
    u.current_age,
    u.gender,
    YEAR(t.date_tr) AS tahun,
    AVG(t.amount) AS avg_spent,
    AVG(u.per_capita_income) AS avg_income_capita, 
    AVG(u.yearly_income) AS avg_income_yearly
FROM transaction AS t
LEFT JOIN user_profile AS u 
    ON t.client_id = u.id
GROUP BY u.current_age, u.gender, YEAR(t.date_tr)
ORDER BY YEAR(t.date_tr), avg_spent DESC, u.gender;

-- error msg tiap client dan sebaran lokasi merchant 
SELECT 
    t.merchant_id, 
    t.merchant_city, 
    t.merchant_state, 
    t.zip,
    t.error_msg, 
    c.has_chip
FROM transaction AS t
LEFT JOIN user_profile AS u
    ON t.client_id = u.id
LEFT JOIN card AS c
    ON c.id = t.card_id
ORDER BY t.client_id;

-- rata-rata jumlah_transaksi per gender, tahun
SELECT 
    u.gender,
    YEAR(t.date_tr) AS tahun,
    AVG(t.amount) AS avg_jumlah_transaksi
FROM transaction AS t
JOIN user_profile AS u
    ON t.client_id = u.id
GROUP BY u.gender, YEAR(t.date_tr)
ORDER BY avg_jumlah_transaksi DESC;

-- memeriksa data unik 
select 
	count(distinct mcc) as count_mcc,
    count(distinct zip) as count_zip,
    count(distinct merchant_city) 
from transaction;
-- memeriksa hubungan use_chip dengan ketika merchant_city
SELECT DISTINCT use_chip, merchant_city from transaction
WHERE merchant_city = 'ONLINE';

SELECT DISTINCT use_chip, merchant_city from transaction
WHERE use_chip = 'Online Transaction';

-- jumlah dan frekuensi transaksi berdasarkan kota 
SELECT 
    t.merchant_city,
    t.merchant_state, 
    COUNT(*) AS frekuensi_transaksi,
    SUM(t.amount) AS jumlah_transaksi
FROM transaction t
GROUP BY t.merchant_city, t.merchant_state
ORDER BY frekuensi_transaksi DESC;

-- jumlah transaksi yang mendapatkan error message berdasarkan jenis transaksi
SELECT 
    use_chip,
    COUNT(*) AS total_error
FROM transaction
WHERE error_msg IS NOT NULL 
  AND error_msg != '' 
GROUP BY use_chip
ORDER BY total_error DESC;

-- Rata-rata transaksi per hari
SELECT AVG(total_transaksi) AS rata_rata_transaksi_per_hari
FROM (
    SELECT DATE(date_tr) AS hari, COUNT(*) AS total_transaksi
    FROM transaction
    GROUP BY hari
) AS sub;

-- jenis transaksi yang error per hari
SELECT AVG(total_error) AS rata_rata_error_per_hari
FROM (
    SELECT DATE(date_tr) AS hari, COUNT(*) AS total_error
    FROM transaction
    WHERE error_msg IS NOT NULL 
      AND error_msg <> ''
    GROUP BY hari
) AS sub;

-- error transaksi berdasarkan metode transaksi (swipe vs online)
SELECT 
    use_chip,
    error_msg,
    SUM(amount) AS jumlah_transaksi,
    COUNT(*) AS jumlah_error
FROM transaction
WHERE error_msg IS NOT NULL 
  AND error_msg != '' 
GROUP BY use_chip, error_msg
ORDER BY use_chip, jumlah_error DESC, error_msg;

-- memeriksa jumlah error berdasarkan jam
SELECT 
    HOUR(t.date_tr) AS jam,
    COUNT(*) AS jumlah_error
FROM transaction t
WHERE t.error_msg IS NOT NULL AND t.error_msg <> ''
GROUP BY HOUR(t.date_tr)
ORDER BY jumlah_error DESC;

SELECT 
    CASE 
        WHEN HOUR(t.date_tr) BETWEEN 0 AND 5 THEN '00:00 - 06:00'
        WHEN HOUR(t.date_tr) BETWEEN 6 AND 8 THEN '06:00 - 09:00'
        WHEN HOUR(t.date_tr) BETWEEN 9 AND 11 THEN '09:00 - 12:00'
        WHEN HOUR(t.date_tr) BETWEEN 12 AND 14 THEN '12:00 - 15:00'
        WHEN HOUR(t.date_tr) BETWEEN 15 AND 17 THEN '15:00 - 18:00'
        ELSE '18:00 - 24:00'
    END AS rentang_jam,
    COUNT(*) AS jumlah_error
FROM transaction t
WHERE t.error_msg IS NOT NULL 
  AND t.error_msg <> ''
GROUP BY rentang_jam
ORDER BY jumlah_error DESC;

-- memeriksa error per hari dan dalam rentang waktu
SELECT 
	DATE_FORMAT(date_tr, '%Y-%m-%d') AS tanggal,
    CASE 
        WHEN HOUR(t.date_tr) BETWEEN 0 AND 5 THEN '00:00 - 06:00'
        WHEN HOUR(t.date_tr) BETWEEN 6 AND 8 THEN '06:00 - 09:00'
        WHEN HOUR(t.date_tr) BETWEEN 9 AND 11 THEN '09:00 - 12:00'
        WHEN HOUR(t.date_tr) BETWEEN 12 AND 14 THEN '12:00 - 15:00'
        WHEN HOUR(t.date_tr) BETWEEN 15 AND 17 THEN '15:00 - 18:00'
        ELSE '18:00 - 24:00'
    END AS rentang_jam,
    COUNT(*) AS jumlah_error
FROM transaction t
WHERE t.error_msg IS NOT NULL 
  AND t.error_msg <> ''
GROUP BY tanggal, rentang_jam
ORDER BY tanggal, rentang_jam ;

-- sebaran transaksi error berdasarkan rentang waktu dan lokasi
SELECT 
    t.merchant_city,
    CASE 
        WHEN HOUR(t.date_tr) BETWEEN 0 AND 5 THEN '00:00 - 06:00'
        WHEN HOUR(t.date_tr) BETWEEN 6 AND 8 THEN '06:00 - 09:00'
        WHEN HOUR(t.date_tr) BETWEEN 9 AND 11 THEN '09:00 - 12:00'
        WHEN HOUR(t.date_tr) BETWEEN 12 AND 14 THEN '12:00 - 15:00'
        WHEN HOUR(t.date_tr) BETWEEN 15 AND 17 THEN '15:00 - 18:00'
        ELSE '18:00 - 24:00'
    END AS rentang_jam,
    COUNT(*) AS jumlah_error
FROM transaction t
WHERE t.error_msg IS NOT NULL 
  AND t.error_msg <> ''
GROUP BY t.merchant_city, rentang_jam
ORDER BY jumlah_error DESC;

-- memeriksa jumlah error saat transaksi online dan fisik
SELECT 
    use_chip,
    error_msg,
    COUNT(*) AS jumlah_error
FROM transaction
WHERE error_msg IS NOT NULL 
  AND error_msg <> ''
GROUP BY use_chip, error_msg
ORDER BY use_chip, jumlah_error DESC;

-- sebaran transaksi error berdasarkan rentang waktu dan lokasi
SELECT 
    error_msg, use_chip,
    CASE 
        WHEN HOUR(t.date_tr) BETWEEN 0 AND 5 THEN '00:00 - 06:00'
        WHEN HOUR(t.date_tr) BETWEEN 6 AND 8 THEN '06:00 - 09:00'
        WHEN HOUR(t.date_tr) BETWEEN 9 AND 11 THEN '09:00 - 12:00'
        WHEN HOUR(t.date_tr) BETWEEN 12 AND 14 THEN '12:00 - 15:00'
        WHEN HOUR(t.date_tr) BETWEEN 15 AND 17 THEN '15:00 - 18:00'
        ELSE '18:00 - 24:00'
    END AS rentang_jam,
    COUNT(*) AS jumlah_error
FROM transaction t
WHERE use_chip = 'Online Transaction'
  AND error_msg IS NOT NULL 
  AND error_msg <> ''
GROUP BY error_msg, rentang_jam
ORDER BY jumlah_error DESC;