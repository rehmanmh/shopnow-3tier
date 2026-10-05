-- ShopNow database schema
-- NOTE: Run this file AS the shopnow user (psql -U shopnow -d shopnow_db -f init.sql)
-- so the app user owns the tables it needs to read/write. If you run it as
-- postgres/another superuser instead, grant privileges afterwards:
--   GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO shopnow;
--   GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO shopnow;

CREATE TABLE IF NOT EXISTS products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    category VARCHAR(60) NOT NULL,
    price NUMERIC(10,2) NOT NULL,
    mrp NUMERIC(10,2) NOT NULL,
    rating NUMERIC(2,1) NOT NULL,
    reviews INTEGER NOT NULL DEFAULT 0,
    image TEXT,
    description TEXT
);

INSERT INTO products (name, category, price, mrp, rating, reviews, image, description) VALUES
('Wireless Bluetooth Headphones', 'Electronics', 1999, 3499, 4.3, 2140, 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?w=400', 'Over-ear wireless headphones with active noise cancellation and 30-hour battery life.'),
('Smartwatch Pro Series', 'Electronics', 4499, 6999, 4.1, 987, 'https://images.unsplash.com/photo-1523275335684-37898b6baf30?w=400', 'Fitness tracking smartwatch with heart-rate monitor, SpO2, and 7-day battery.'),
('Men''s Running Shoes', 'Fashion', 1299, 2499, 4.0, 3421, 'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400', 'Lightweight breathable running shoes with cushioned sole.'),
('Stainless Steel Cookware Set', 'Home & Kitchen', 2799, 4999, 4.5, 654, 'https://images.unsplash.com/photo-1584990347449-a5d9f800a783?w=400', '5-piece induction-friendly stainless steel cookware set.'),
('Laptop Backpack', 'Fashion', 899, 1599, 4.2, 5102, 'https://images.unsplash.com/photo-1553062407-98eeb64c6a62?w=400', 'Water-resistant 15.6-inch laptop backpack with USB charging port.'),
('4K Smart LED TV 43-inch', 'Electronics', 22999, 34999, 4.4, 1289, 'https://images.unsplash.com/photo-1593359677879-a4bb92f829d1?w=400', '43-inch 4K Ultra HD Smart LED TV with built-in streaming apps.'),
('Yoga Mat', 'Sports', 499, 999, 4.3, 2765, 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=400', 'Non-slip extra-thick yoga and exercise mat.'),
('Ceramic Coffee Mug Set', 'Home & Kitchen', 349, 699, 4.6, 1543, 'https://images.unsplash.com/photo-1514228742587-6b1558fcca3d?w=400', 'Set of 4 ceramic coffee mugs, microwave and dishwasher safe.')
ON CONFLICT DO NOTHING;
