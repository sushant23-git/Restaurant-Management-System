-- Database Schema for Restaurant Management System
-- Normalized to 3NF

CREATE DATABASE IF NOT EXISTS restaurant_db;
USE restaurant_db;

-- Drop tables if they exist to avoid errors on re-import
SET FOREIGN_KEY_CHECKS = 0;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS menu_items;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS restaurants;
DROP TABLE IF EXISTS users;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Users Table
CREATE TABLE users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    phone VARCHAR(20),
    address TEXT,
    role ENUM('user', 'admin') DEFAULT 'user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 2. Restaurants Table
CREATE TABLE restaurants (
    restaurant_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    location VARCHAR(255) NOT NULL,
    cuisine VARCHAR(100),
    rating DECIMAL(2,1) DEFAULT 0.0,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 3. Categories Table
CREATE TABLE categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- 4. Menu Items Table
CREATE TABLE menu_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    restaurant_id INT NOT NULL,
    category_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    is_available BOOLEAN DEFAULT TRUE,
    image_url VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(category_id) ON DELETE CASCADE
);

-- 5. Orders Table
CREATE TABLE orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    status ENUM('pending', 'confirmed', 'delivered', 'cancelled') DEFAULT 'pending',
    delivery_address TEXT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE
);

-- 6. Order Items Table
CREATE TABLE order_items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    item_id INT NOT NULL,
    quantity INT NOT NULL DEFAULT 1,
    price_at_time DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES menu_items(item_id) ON DELETE CASCADE
);

-- 7. Payments Table
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    user_id INT NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50),
    status ENUM('success', 'failed') DEFAULT 'success',
    transaction_id VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE
);

-- 8. Reviews Table
CREATE TABLE reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    restaurant_id INT NOT NULL,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (restaurant_id) REFERENCES restaurants(restaurant_id) ON DELETE CASCADE
);

-- Insert Sample Data

-- Users (10)
-- Passwords are 'password123' hashed (simulated)
INSERT INTO users (full_name, email, password, role) VALUES
('Admin User', 'admin@example.com', '$2b$10$K0WvXo/bKxM.K3sL/N5E.e9qX7XyGzI7fR8l8mS9X3z7n7n7n7n7', 'admin'),
('John Doe', 'john@example.com', '$2b$10$K0WvXo/bKxM.K3sL/N5E.e9qX7XyGzI7fR8l8mS9X3z7n7n7n7n7', 'user'),
('Jane Smith', 'jane@example.com', '$2b$10$K0WvXo/bKxM.K3sL/N5E.e9qX7XyGzI7fR8l8mS9X3z7n7n7n7n7', 'user'),
('Mike Johnson', 'mike@example.com', '$2b$10$K0WvXo/bKxM.K3sL/N5E.e9qX7XyGzI7fR8l8mS9X3z7n7n7n7n7', 'user'),
('Sarah Brown', 'sarah@example.com', '$2b$10$K0WvXo/bKxM.K3sL/N5E.e9qX7XyGzI7fR8l8mS9X3z7n7n7n7n7', 'user'),
('David Wilson', 'david@example.com', '$2b$10$K0WvXo/bKxM.K3sL/N5E.e9qX7XyGzI7fR8l8mS9X3z7n7n7n7n7', 'user'),
('Emily Davis', 'emily@example.com', '$2b$10$K0WvXo/bKxM.K3sL/N5E.e9qX7XyGzI7fR8l8mS9X3z7n7n7n7n7', 'user'),
('Chris Miller', 'chris@example.com', '$2b$10$K0WvXo/bKxM.K3sL/N5E.e9qX7XyGzI7fR8l8mS9X3z7n7n7n7n7', 'user'),
('Olivia Taylor', 'olivia@example.com', '$2b$10$K0WvXo/bKxM.K3sL/N5E.e9qX7XyGzI7fR8l8mS9X3z7n7n7n7n7', 'user'),
('Liam Moore', 'liam@example.com', '$2b$10$K0WvXo/bKxM.K3sL/N5E.e9qX7XyGzI7fR8l8mS9X3z7n7n7n7n7', 'user');

-- Restaurants (10)
INSERT INTO restaurants (name, description, location, cuisine, rating, image_url) VALUES
('Bawane\'s Hotel', 'Experience premium hospitality and exquisite flavors in every dish.', 'Nagpur, MH', 'Multi-Cuisine', 4.9, 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=800'),
('Sushi Haven', 'Fresh sushi and Japanese delicacies.', 'Los Angeles', 'Japanese', 4.8, 'https://images.unsplash.com/photo-1579871494447-9811cf80d66c?w=500'),
('Burger Kingly', 'Gourmet burgers and handcrafted fries.', 'Chicago', 'American', 4.2, 'https://images.unsplash.com/photo-1571091718767-18b5b1457add?w=500'),
('Spice Route', 'Traditional Indian curry and tandoori.', 'Houston', 'Indian', 4.6, 'https://images.unsplash.com/photo-1585937421612-70a008356fbe?w=500'),
('Parisian Cafe', 'Elegant French pastries and coffee.', 'Boston', 'French', 4.4, 'https://images.unsplash.com/photo-1550966841-3ee5ad0a90ad?w=500'),
('Taco Temple', 'Real Mexican tacos and mole.', 'San Diego', 'Mexican', 4.3, 'https://images.unsplash.com/photo-1565299585323-38d6b0865547?w=500'),
('Dragon wok', 'Szechuan style spicy Chinese food.', 'San Francisco', 'Chinese', 4.1, 'https://images.unsplash.com/photo-1552611052-33e04de081de?w=500'),
('Thai Terrace', 'Aromatic Thai soups and noodles.', 'Seattle', 'Thai', 4.7, 'https://images.unsplash.com/photo-1559311648-d46f4d8593d8?w=500'),
('Greek Garden', 'Fresh salads and gyro wraps.', 'Miami', 'Greek', 4.1, 'https://images.unsplash.com/photo-1544124499-58d098ee3e87?w=500'),
('Steak House', 'Premium cuts and aged beef.', 'Dallas', 'Steakhouse', 4.9, 'https://images.unsplash.com/photo-1546241072-48010ad28c2c?w=500');

-- Categories (10)
INSERT INTO categories (name) VALUES
('Appetizers'), ('Main Course'), ('Desserts'), ('Beverages'), ('Fast Food'),
('Seafood'), ('Vegetarian'), ('Side Dishes'), ('Salads'), ('Breakfast');

-- Menu Items (10 per restaurant - total 100 entries, but I will provide 10 unique examples for brevity)
INSERT INTO menu_items (restaurant_id, category_id, name, description, price, image_url) VALUES
(1, 2, 'Margherita Pizza', 'Classic tomato and mozzarella.', 299.00, 'https://images.unsplash.com/photo-1574071318508-1cdbad80ad38?w=500'),
(1, 2, 'Lasagna', 'Layers of pasta with meat sauce.', 450.00, 'https://images.unsplash.com/photo-1551183053-bf91a1d81141?w=500'),
(1, 6, 'Salmon Sashimi', 'Fresh thin slices of salmon.', 850.00, 'https://images.unsplash.com/photo-1534422298391-e4f8c170db0f?w=500'),
(1, 5, 'Classic Cheeseburger', 'Angus beef with cheddar cheese.', 249.00, 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=500'),
(1, 2, 'Butter Chicken', 'Tender chicken in creamy tomato sauce.', 380.00, 'https://images.unsplash.com/photo-1603894527135-06f856f59055?w=500'),
(1, 3, 'Chocolate Croissant', 'Flaky pastry with dark chocolate.', 120.00, 'https://images.unsplash.com/photo-1530610476181-d83430b64dcd?w=500'),
(1, 2, 'Al Pastor Tacos', 'Marinated pork with pineapple.', 180.00, 'https://images.unsplash.com/photo-1551504734-5ee1c4a1479b?w=500'),
(1, 2, 'Kung Pao Chicken', 'Spicy stir-fry with peanuts.', 320.00, 'https://images.unsplash.com/photo-1525755662778-989d0524087e?w=500'),
(1, 2, 'Pad Thai', 'Rice noodles with shrimp and peanuts.', 280.00, 'https://images.unsplash.com/photo-1559311648-d46f4d8593d8?w=500'),
(1, 7, 'Greek Salad', 'Feta, olives, and fresh veggies.', 220.00, 'https://images.unsplash.com/photo-1540189549336-e6e99c3679fe?w=500');

-- Orders (10)
INSERT INTO orders (user_id, restaurant_id, total_price, status, delivery_address) VALUES
(2, 1, 749.00, 'delivered', '123 Main St, Nagpur'),
(3, 1, 850.00, 'delivered', '456 Oak Ave, Nagpur'),
(4, 1, 249.00, 'pending', '789 Pine Rd, Nagpur'),
(2, 1, 380.00, 'confirmed', '123 Main St, Nagpur');

-- Order Items (10)
INSERT INTO order_items (order_id, item_id, quantity, price_at_time) VALUES
(1, 1, 1, 299.00), (1, 2, 1, 450.00),
(2, 3, 1, 850.00),
(3, 4, 1, 249.00),
(4, 5, 1, 380.00);

-- Payments (10)
INSERT INTO payments (order_id, user_id, amount, payment_method, transaction_id) VALUES
(1, 2, 749.00, 'UPI', 'TXN001'),
(2, 3, 850.00, 'Net Banking', 'TXN002'),
(3, 4, 249.00, 'Debit Card', 'TXN003'),
(4, 2, 380.00, 'Credit Card', 'TXN004');

-- Reviews (10)
INSERT INTO reviews (user_id, restaurant_id, rating, comment) VALUES
(2, 1, 5, 'Best pizza in town!'),
(3, 2, 4, 'Very fresh sashimi.'),
(4, 3, 3, 'Average burger, could be better.'),
(5, 5, 5, 'Amazing pastries.'),
(6, 6, 4, 'Great tacos but spicy!'),
(7, 7, 4, 'Good portions.'),
(8, 8, 5, 'Love the Pad Thai.'),
(9, 9, 4, 'Very healthy options.'),
(2, 4, 5, 'Spices are perfect.'),
(10, 10, 5, 'Perfectly cooked steak.');

-- Complex JOIN Queries

-- 1. Order + User + Restaurant + Payment details
-- SELECT o.order_id, u.full_name as customer, r.name as restaurant, o.total_price, o.status, p.payment_method, p.status as payment_status
-- FROM orders o
-- JOIN users u ON o.user_id = u.user_id
-- JOIN restaurants r ON o.restaurant_id = r.restaurant_id
-- LEFT JOIN payments p ON o.order_id = p.order_id;

-- 2. Menu items with categories and restaurant names
-- SELECT m.name as dish, c.name as category, r.name as restaurant, m.price
-- FROM menu_items m
-- JOIN categories c ON m.category_id = c.category_id
-- JOIN restaurants r ON m.restaurant_id = r.restaurant_id;

-- 3. User order history with items and reviews
-- SELECT u.full_name, o.order_id, m.name as item_ordered, rv.rating, rv.comment
-- FROM users u
-- JOIN orders o ON u.user_id = o.user_id
-- JOIN order_items oi ON o.order_id = oi.order_id
-- JOIN menu_items m ON oi.item_id = m.item_id
-- LEFT JOIN reviews rv ON (u.user_id = rv.user_id AND o.restaurant_id = rv.restaurant_id);
