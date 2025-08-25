-- caek tabel transaksi
SELECT COUNT(distinct client_id) FROM transaction;
-- memeriksa awal-akhir periode transaksi
SELECT min(date_tr) AS awal_periode, max(date_tr) AS akhir_periode FROM transaction;

-- user yang bekum pernah melakukan transaksi
SELECT u.*
FROM user_profile AS u
LEFT JOIN transaction AS t
    ON u.id = t.client_id
WHERE t.client_id IS NULL;

-- membagi user yang tidak melakukan transaksi berdasarkan usia produktif atau pensiun 
SELECT 
    CASE 
        WHEN u.current_age < u.retirement_age THEN 'Produktif'
        ELSE 'Pensiun'
    END AS kategori_usia,
    COUNT(*) AS jumlah_user
FROM user_profile AS u
LEFT JOIN transaction AS t
    ON u.id = t.client_id
WHERE t.client_id IS NULL
GROUP BY 
    CASE 
        WHEN u.current_age < u.retirement_age THEN 'Produktif'
        ELSE 'Pensiun'
    END;
    
-- analisis lebih lanjut yang usia produktiF
SELECT u.*
FROM user_profile AS u
LEFT JOIN transaction AS t
    ON u.id = t.client_id
WHERE t.client_id IS NULL
AND u.current_age < u.retirement_age
ORDER BY u.birth_year, u.birth_month;

-- memeriksa credit_score dari yang tidak pernah melakukan transaksi
SELECT 
    u.id,
    u.current_age,
    u.per_capita_income,
    u.total_debt,
    u.credit_score,
    CASE
        WHEN u.credit_score BETWEEN 300 AND 579 THEN 'High Risk'
        WHEN u.credit_score BETWEEN 580 AND 669 THEN 'Medium Risk'
        WHEN u.credit_score BETWEEN 670 AND 739 THEN 'Good'
        WHEN u.credit_score BETWEEN 740 AND 799 THEN 'Very Good'
        WHEN u.credit_score BETWEEN 800 AND 850 THEN 'Excellent'
        ELSE 'Unknown'
    END AS credit_risk_category
FROM user_profile AS u
LEFT JOIN transaction AS t
    ON u.id = t.client_id
WHERE t.client_id IS NULL;
  
-- melakukan kategorisasi seluruh data user
SELECT 
    u.id, 
    CASE
        WHEN u.credit_score BETWEEN 300 AND 579 THEN 'High Risk'
        WHEN u.credit_score BETWEEN 580 AND 669 THEN 'Medium Risk'
        WHEN u.credit_score BETWEEN 670 AND 739 THEN 'Good'
        WHEN u.credit_score BETWEEN 740 AND 799 THEN 'Very Good'
        WHEN u.credit_score BETWEEN 800 AND 850 THEN 'Excellent'
        ELSE 'Unknown'
    END AS credit_risk_category
FROM user_profile AS u;

-- cek data transaksi 
SELECT 
	COUNT(DISTINCT lower(merchant_state)) as count_state, 
	COUNT(DISTINCT lower(merchant_city)) as count_city,
    COUNT(distinct(concat(lower(merchant_city), lower(merchant_state)))) as count_city_state 
FROM transaction;

SELECT distinct merchant_city from transaction;
SELECT 
    DISTINCT merchant_state,
    CASE 
        WHEN LENGTH(merchant_state) = 2 THEN 'not valid'
        ELSE 'valid'
    END AS cek
FROM transaction;

SELECT 
    SUM(CASE WHEN LENGTH(merchant_state) = 2 THEN 1 ELSE 0 END) AS state_not_full_name,
    SUM(CASE WHEN LENGTH(merchant_state) > 2 THEN 1 ELSE 0 END) AS state_full_name
FROM (
    SELECT DISTINCT merchant_state
    FROM transaction
) AS t;

-- cek tabel card
SELECT * FROM card;
-- memerika jumlah kartu tiap client
SELECT client_id, count(*) as jumlah_kartu
from card 
GROUP BY client_id;

SELECT client_id, card_type, count(*) as jumlah_kartu
from card 
GROUP BY client_id, card_type
order by card_type;

-- memeriksa kartu yang tidak memiliki chip
SELECT has_chip, count(*) FROM card GROUP BY has_chip;
SELECT * FROM card WHERE has_chip = 'NO';

-- cek berdasarkan tipe kartu
SELECT card_type, has_chip, COUNT(*) as count_card
FROM card 
WHERE has_chip = 'NO'
GROUP BY card_type, has_chip
ORDER BY card_type, count_card desc;

-- berdasarkan brand
SELECT card_brand, has_chip, COUNT(*) as count_card
FROM card 
GROUP BY card_brand, has_chip
ORDER BY card_brand, has_chip, count_card desc;

-- dikelompokkan berdasarkan keduanya
SELECT card_type, card_brand, has_chip, COUNT(*) as count_card
FROM card 
WHERE has_chip = 'NO'
GROUP BY card_type, card_brand, has_chip
ORDER BY card_type, count_card desc;
