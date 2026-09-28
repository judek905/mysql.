
DROP DATABASE IF EXISTS online_store;
CREATE DATABASE online_store
  CHARACTER SET utf8mb4
  COLLATE utf8mb4_unicode_ci;
USE online_store;

-- ---------- TABLES ----------

CREATE TABLE customers (
  customer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  first_name  VARCHAR(50)  NOT NULL,
  last_name   VARCHAR(50)  NOT NULL,
  email       VARCHAR(100) NOT NULL UNIQUE,
  phone       VARCHAR(20),
  address     VARCHAR(255),
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

CREATE TABLE categories (
  category_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  name        VARCHAR(80) NOT NULL UNIQUE
) ENGINE=InnoDB;

CREATE TABLE products (
  product_id  INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  category_id INT UNSIGNED NOT NULL,
  name        VARCHAR(120) NOT NULL,
  description TEXT,
  price       DECIMAL(10,2) NOT NULL,
  stock       INT UNSIGNED NOT NULL DEFAULT 0,
  created_at  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  CONSTRAINT chk_price CHECK (price >= 0),
  CONSTRAINT fk_products_category FOREIGN KEY (category_id)
    REFERENCES categories(category_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_products_name (name)
) ENGINE=InnoDB;

CREATE TABLE orders (
  order_id    INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
  customer_id INT UNSIGNED NOT NULL,
  order_date  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
  status      ENUM('pending','paid','shipped','delivered','cancelled')
              NOT NULL DEFAULT 'pending',
  CONSTRAINT fk_orders_customer FOREIGN KEY (customer_id)
    REFERENCES customers(customer_id)
    ON UPDATE CASCADE ON DELETE RESTRICT,
  INDEX idx_orders_customer (customer_id),
  INDEX idx_orders_date (order_date)
) ENGINE=InnoDB;

CREATE TABLE order_items (
  order_id   INT UNSIGNED NOT NULL,
  product_id INT UNSIGNED NOT NULL,
  quantity   INT UNSIGNED NOT NULL,
  unit_price DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (order_id, product_id),
  CONSTRAINT chk_qty CHECK (quantity > 0),
  CONSTRAINT fk_items_order FOREIGN KEY (order_id)
    REFERENCES orders(order_id)
    ON UPDATE CASCADE ON DELETE CASCADE,
  CONSTRAINT fk_items_product FOREIGN KEY (product_id)
    REFERENCES products(product_id)
    ON UPDATE CASCADE ON DELETE RESTRICT
) ENGINE=InnoDB;

-- ---------- TRIGGER: reduce stock when an item is ordered ----------
-- If stock would go below 0, the UNSIGNED column makes the insert fail,
-- which prevents overselling.

DELIMITER //
CREATE TRIGGER trg_reduce_stock
AFTER INSERT ON order_items
FOR EACH ROW
BEGIN
  UPDATE products
  SET stock = stock - NEW.quantity
  WHERE product_id = NEW.product_id;
END//
DELIMITER ;

-- ---------- VIEW: order totals ----------

CREATE VIEW order_totals AS
SELECT o.order_id,
       CONCAT(c.first_name, ' ', c.last_name) AS customer,
       o.order_date,
       o.status,
       SUM(oi.quantity * oi.unit_price) AS total
FROM orders o
JOIN customers c   ON c.customer_id = o.customer_id
JOIN order_items oi ON oi.order_id = o.order_id
GROUP BY o.order_id, customer, o.order_date, o.status;

-- ---------- SAMPLE DATA ----------

INSERT INTO customers (first_name, last_name, email, phone, address) VALUES
  ('Amina', 'Nakato',  'amina@example.com', '0700000001', 'Mukono'),
  ('John',  'Okello',  'john@example.com',  '0700000002', 'Kampala'),
  ('Grace', 'Mugisha', 'grace@example.com', '0700000003', 'Entebbe');

INSERT INTO categories (name) VALUES ('Electronics'), ('Books'), ('Clothing');

INSERT INTO products (category_id, name, description, price, stock) VALUES
  (1, 'Wireless Mouse', 'USB wireless mouse',   25000.00, 50),
  (1, 'Headphones',     'Over-ear headphones',  80000.00, 30),
  (2, 'SQL Basics',     'Beginner SQL book',    45000.00, 20),
  (3, 'T-Shirt',        'Cotton T-shirt',       20000.00, 100);

INSERT INTO orders (customer_id, status) VALUES (1, 'paid'), (2, 'pending');

INSERT INTO order_items (order_id, product_id, quantity, unit_price) VALUES
  (1, 1, 2, 25000.00),
  (1, 3, 1, 45000.00),
  (2, 4, 3, 20000.00);

-- ---------- APP USER (least privilege) ----------
-- Change the password before real use.

CREATE USER IF NOT EXISTS 'store_app'@'localhost' IDENTIFIED BY 'ChangeMe_123!';
GRANT SELECT, INSERT, UPDATE, DELETE ON online_store.* TO 'store_app'@'localhost';
FLUSH PRIVILEGES;

-- ---------- EXAMPLE QUERIES ----------

-- All orders with totals
SELECT * FROM order_totals;

-- Products low on stock
SELECT name, stock FROM products WHERE stock < 25;

-- Best-selling products
SELECT p.name, SUM(oi.quantity) AS units_sold
FROM order_items oi
JOIN products p ON p.product_id = oi.product_id
GROUP BY p.product_id, p.name
ORDER BY units_sold DESC;

-- Update an order's status
UPDATE orders SET status = 'shipped' WHERE order_id = 1;

-- Backup (run in the terminal, not inside MySQL):
-- mysqldump -u root -p online_store > online_store_backup.sql