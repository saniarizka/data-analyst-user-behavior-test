-- menggali insight bermanfaat dari data transaksi
-- transaksi per harian 
SELECT 
    DATE(date_tr) AS tgl,
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS total_spending,
    SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS total_refund,
    SUM(amount) AS jumlah_transaksi,
    COUNT(*) AS frekuensi_transaksi
FROM transaction
GROUP BY DATE(date_tr);

-- mencari jumlah transaksi berdasarkan tanggal dan rentang waktu(jam)
SELECT 
	DATE(date_tr) AS tgl,
	CASE 
        WHEN HOUR(date_tr) BETWEEN 0 AND 5 THEN '00:00 - 06:00'
        WHEN HOUR(date_tr) BETWEEN 6 AND 8 THEN '06:00 - 09:00'
        WHEN HOUR(date_tr) BETWEEN 9 AND 11 THEN '09:00 - 12:00'
        WHEN HOUR(date_tr) BETWEEN 12 AND 14 THEN '12:00 - 15:00'
        WHEN HOUR(date_tr) BETWEEN 15 AND 17 THEN '15:00 - 18:00'
        ELSE '18:00 - 24:00'
    END AS jam,
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS total_spending,
    SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS total_refund,
    SUM(amount) AS jumlah_transaksi,
    COUNT(*) AS total_transaksi
FROM transaction
GROUP BY tgl, jam;

-- jumlah dan banyaknya/frekuensi transaksi berdasarkan rentang waktu(jam)
SELECT 
	CASE 
        WHEN HOUR(date_tr) BETWEEN 0 AND 5 THEN '00:00 - 06:00'
        WHEN HOUR(date_tr) BETWEEN 6 AND 8 THEN '06:00 - 09:00'
        WHEN HOUR(date_tr) BETWEEN 9 AND 11 THEN '09:00 - 12:00'
        WHEN HOUR(date_tr) BETWEEN 12 AND 14 THEN '12:00 - 15:00'
        WHEN HOUR(date_tr) BETWEEN 15 AND 17 THEN '15:00 - 18:00'
        ELSE '18:00 - 24:00'
    END AS jam,
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS total_spending,
    SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS total_refund,
    SUM(amount) AS jumlah_transaksi,
    COUNT(*) AS frekuensi_transaksi
FROM transaction
GROUP BY jam
ORDER BY jumlah_transaksi DESC;

-- transaksi periode bulanan 
SELECT 
	DATE_FORMAT(date_tr, '%Y-%m') AS bulan,
	COUNT(*) AS frekuensi_transaksi,
    SUM(amount) AS jumlah_transaksi
FROM transaction
GROUP BY bulan
ORDER BY bulan;

-- data transaksi bulanan berdasarkan wilayah
SELECT  
    DATE_FORMAT(date_tr, '%Y-%m') AS bulan, 
    merchant_state,
    SUM(CASE WHEN amount > 0 THEN amount ELSE 0 END) AS total_spending,
    SUM(CASE WHEN amount < 0 THEN amount ELSE 0 END) AS total_refund,
    SUM(amount) AS jumlah_transaksi,
    COUNT(*) AS frekuensi_transaksi
FROM transaction
GROUP BY bulan, merchant_state;

-- transaksi berdasarkan use_chip, mcc, dan card_brand
SELECT 
    t.mcc, 
    t.use_chip, 
    t.error_msg,                         
    t.client_id,
    c.card_type, 
    c.id AS card_id,
    c.card_brand,
    COUNT(*) AS frekuensi_transaksi,
    SUM(t.amount) AS jumlah_transaksi,
    SUM(CASE WHEN t.amount < 0 THEN t.amount ELSE 0 END) AS total_refund,
    SUM(CASE WHEN t.error_msg IS NULL THEN 1 ELSE 0 END) AS sukses,
    SUM(CASE WHEN t.error_msg IS NOT NULL THEN 1 ELSE 0 END) AS gagal
FROM transaction t
LEFT JOIN card c 
    ON c.id = t.card_id
GROUP BY 
    t.client_id,
    t.mcc, 
    t.use_chip, 
    t.error_msg,
    c.card_type,
    c.card_brand, c.id
ORDER BY 
    c.card_brand, t.mcc;
    
-- error message dengan keterangan jumlah, frekuensi, dan jenis transaksi  
SELECT 
    t.mcc, 
    t.use_chip, 
    t.error_msg,                         
    c.card_type, 
    c.card_brand,
    COUNT(*) AS frekuensi_transaksi,
    SUM(t.amount) AS jumlah_transaksi,
    SUM(CASE WHEN t.amount < 0 THEN t.amount ELSE 0 END) AS total_refund,
    SUM(CASE WHEN t.amount > 0 THEN t.amount ELSE 0 END) AS total_spending
FROM transaction t
LEFT JOIN card c
    ON c.id = t.card_id
GROUP BY t.use_chip, t.error_msg, c.card_type, t.mcc, c.card_brand
ORDER BY t.use_chip, t.error_msg, c.card_type, t.mcc, c.card_brand;
