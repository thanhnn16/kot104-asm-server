drop database if exists kotlin;
create database kotlin;

use kotlin;

CREATE TABLE users
(
    id                INT AUTO_INCREMENT PRIMARY KEY,
    full_name         VARCHAR(255),
    username          VARCHAR(255) UNIQUE,
    email             VARCHAR(255) UNIQUE,
    email_verified_at TIMESTAMP    NULL DEFAULT NULL,
    password          VARCHAR(255),
    remember_token    VARCHAR(100) NULL DEFAULT NULL,
    created_at        TIMESTAMP         DEFAULT CURRENT_TIMESTAMP,
    updated_at        TIMESTAMP         DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE password_reset_tokens
(
    email      VARCHAR(255) PRIMARY KEY,
    token      VARCHAR(255),
    created_at TIMESTAMP NULL DEFAULT NULL,
    FOREIGN KEY (email) REFERENCES users (email)
);

CREATE TABLE sessions
(
    id            VARCHAR(255) PRIMARY KEY,
    user_id       INT,
    ip_address    VARCHAR(45),
    user_agent    TEXT,
    payload       LONGTEXT,
    last_activity INT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users (id),
    INDEX user_sessions_index (user_id),
    INDEX last_activity_index (last_activity)
);

CREATE TABLE cache
(
    `key`      VARCHAR(255) PRIMARY KEY,
    `value`    MEDIUMTEXT,
    expiration INT
);

CREATE TABLE cache_locks
(
    `key`      VARCHAR(255) PRIMARY KEY,
    owner      VARCHAR(255),
    expiration INT
);

CREATE TABLE personal_access_tokens
(
    id             INT AUTO_INCREMENT PRIMARY KEY,
    tokenable_id   INT,
    tokenable_type VARCHAR(255),
    name           VARCHAR(255),
    token          VARCHAR(64) UNIQUE,
    abilities      TEXT,
    last_used_at   TIMESTAMP NULL DEFAULT NULL,
    expires_at     TIMESTAMP NULL DEFAULT NULL,
    created_at     TIMESTAMP      DEFAULT CURRENT_TIMESTAMP,
    updated_at     TIMESTAMP      DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE jobs
(
    id           INT AUTO_INCREMENT PRIMARY KEY,
    queue        VARCHAR(255)     NOT NULL,
    payload      LONGTEXT,
    attempts     TINYINT UNSIGNED NOT NULL,
    reserved_at  INT,
    available_at INT              NOT NULL,
    created_at   INT              NOT NULL
);

CREATE TABLE job_batches
(
    id             VARCHAR(255) PRIMARY KEY,
    name           VARCHAR(255),
    total_jobs     INT,
    pending_jobs   INT,
    failed_jobs    INT,
    failed_job_ids TEXT,
    options        MEDIUMTEXT,
    cancelled_at   INT,
    created_at     INT NOT NULL,
    finished_at    INT
);

CREATE TABLE failed_jobs
(
    id         INT AUTO_INCREMENT PRIMARY KEY,
    uuid       VARCHAR(255) UNIQUE,
    connection TEXT,
    queue      TEXT,
    payload    LONGTEXT,
    exception  LONGTEXT,
    failed_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE product_categories
(
    id   INT PRIMARY KEY AUTO_INCREMENT,
    name VARCHAR(255) NOT NULL,
    icon VARCHAR(255)
);

CREATE TABLE products
(
    id          INT PRIMARY KEY AUTO_INCREMENT,
    category_id INT,
    name        VARCHAR(255)   NOT NULL,
    description TEXT,
    price       DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (category_id) REFERENCES product_categories (id)
);

CREATE TABLE product_images
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    image_url  VARCHAR(255) NOT NULL,
    FOREIGN KEY (product_id) REFERENCES products (id)
);

CREATE TABLE reviews
(
    id         INT PRIMARY KEY AUTO_INCREMENT,
    product_id INT,
    rating     INT NOT NULL,
    comment    TEXT,
    FOREIGN KEY (product_id) REFERENCES products (id)
);

CREATE TABLE favorites
(
    user_id    INT,
    product_id INT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, product_id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    FOREIGN KEY (product_id) REFERENCES products (id)
);

-- Dữ liệu mẫu
INSERT INTO product_categories (name, icon)
VALUES ('Popular', 'product_categories/popular.svg'),
       ('Chair', 'product_categories/chair.svg'),
       ('Table', 'product_categories/table.svg'),
       ('Armchair', 'product_categories/armchair.svg'),
       ('Bed', 'product_categories/bed.svg'),
       ('Lamb', 'product_categories/lamb.svg');

INSERT INTO products (category_id, name, description, price)
VALUES (2, 'Chair 1', 'Description of chair 1', 100),
       (2, 'Chair 2', 'Description of chair 2', 200),
       (3, 'Table 1', 'Description of table 1', 300),
       (3, 'Table 2', 'Description of table 2', 400),
       (4, 'Armchair 1', 'Description of armchair 1', 500),
       (4, 'Armchair 2', 'Description of armchair 2', 600),
       (5, 'Bed 1', 'Description of bed 1', 700),
       (5, 'Bed 2', 'Description of bed 2', 800);

INSERT INTO product_images (product_id, image_url)
VALUES (1, 'product_images/chair1-1.jpg'),
       (1, 'product_images/chair1-2.jpg'),
       (2, 'product_images/chair2-1.jpg'),
       (2, 'product_images/chair2-2.jpg'),
       (3, 'product_images/table1-1.jpg'),
       (3, 'product_images/table1-2.jpg'),
       (4, 'product_images/table2-1.jpg'),
       (4, 'product_images/table2-2.jpg'),
       (5, 'product_images/armchair1-1.jpg'),
       (5, 'product_images/armchair1-2.jpg'),
       (6, 'product_images/armchair2-1.jpg'),
       (6, 'product_images/armchair2-2.jpg'),
       (7, 'product_images/bed1-1.jpg'),
       (7, 'product_images/bed1-2.jpg'),
       (8, 'product_images/bed2-1.jpg'),
       (8, 'product_images/bed2-2.jpg');

INSERT INTO reviews (product_id, rating, comment)
VALUES (1, 5, 'Good product'),
       (1, 4, 'Nice chair'),
       (2, 3, 'Normal chair'),
       (2, 2, 'Bad chair'),
       (3, 5, 'Good table'),
       (3, 4, 'Nice table'),
       (4, 3, 'Normal table'),
       (4, 2, 'Bad table'),
       (5, 5, 'Good armchair'),
       (5, 4, 'Nice armchair'),
       (6, 3, 'Normal armchair'),
       (6, 2, 'Bad armchair'),
       (7, 5, 'Good bed'),
       (7, 4, 'Nice bed'),
       (8, 3, 'Normal bed'),
       (8, 2, 'Bad bed');
#
# INSERT INTO favorites (user_id, product_id)
# VALUES (1, 1),
#        (1, 3),
#        (1, 4),
#        (1, 8);
