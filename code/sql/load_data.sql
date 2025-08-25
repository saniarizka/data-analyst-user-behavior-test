show databases;
use user_behavior;
SELECT DATABASE();
CREATE TABLE user_profile (
    id INT PRIMARY KEY,
    current_age INT,
    retirement_age INT,
    birth_year INT,
    birth_month INT,
    gender VARCHAR(10),
    address VARCHAR(255),
    latitude DECIMAL(6,2),
    longitude DECIMAL(6,2),
    per_capita_income DECIMAL(15,2),
    yearly_income DECIMAL(15,2),
    total_debt DECIMAL(15,2),
    credit_score INT,
    num_credit_cards INT
);

SELECT count(*) FROM user_profile;

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.4\\Uploads\\user_data_clean.csv' INTO TABLE user_profile
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

CREATE TABLE transaction(
id BIGINT PRIMARY KEY,
date_tr DATETIME,
client_id INT NULL,
card_id INT NULL,
amount DECIMAL(15,2),
use_chip VARCHAR(100) NULL,
merchant_id INT NULL,
merchant_city VARCHAR(100) NULL,
merchant_state CHAR(100) NULL,
zip CHAR(10) NULL,
mcc INT NULL,
error_msg VARCHAR(100) NULL
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.4\\Uploads\\transaction_data_clean.csv'
INTO TABLE transaction
FIELDS TERMINATED BY ','
OPTIONALLY ENCLOSED BY '"'
IGNORE 1 LINES
(id, date_tr, client_id, card_id, amount, use_chip, merchant_id, merchant_city, merchant_state, zip, mcc, error_msg);

select count(*) from transaction;

CREATE TABLE card (
    id INT PRIMARY KEY,
    client_id INT,
    card_brand VARCHAR(20),
    card_type VARCHAR(20),
    card_number VARCHAR(20),
    expires DATE,
    cvv SMALLINT,
    has_chip ENUM('YES','NO'),
    num_cards_issued TINYINT,
    credit_limit DECIMAL(15,2),
    acct_open_date DATE,
    year_pin_last_changed YEAR,
    card_on_dark_web ENUM('Yes','No')
);

LOAD DATA INFILE 'C:\\ProgramData\\MySQL\\MySQL Server 8.4\\Uploads\\cards_data_clean.csv' INTO TABLE card
FIELDS TERMINATED BY ','
IGNORE 1 LINES;

SELECT COUNT(*) from card;

ALTER TABLE card
ADD CONSTRAINT fk_card_user
FOREIGN KEY (client_id) REFERENCES user_profile(id);

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_user
FOREIGN KEY (client_id) REFERENCES user_profile(id);

ALTER TABLE transaction
ADD CONSTRAINT fk_transaction_card
FOREIGN KEY (card_id) REFERENCES card(id);

SELECT constraint_name, table_name
FROM information_schema.table_constraints
WHERE table_schema = 'user_behavior'
  AND table_name = 'transaction';
  
SHOW CREATE TABLE transaction;
