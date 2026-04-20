# Bawane's Hotel | Premium Restaurant Management System

A full-stack web application for managing restaurants, menus, and orders, built with Node.js, Express, MySQL, and a Single Page Application (SPA) frontend.

## Features

- **User Authentication**: Secure register and login with JWT and bcrypt.
- **Restaurant Search**: Filter restaurants by location, cuisine, or rating.
- **Dynamic Menu**: View and browse menu items for each restaurant.
- **Cart System**: Add items, modify quantities, and calculate totals.
- **Order Management**: Place orders with simulated payment.
- **Order History**: View past orders and their status.
- **Admin Panel**: Manage orders and mark them as delivered.
- **Modern UI**: Single-file SPA with premium glassmorphism styling.

## Tech Stack

- **Backend**: Node.js, Express, MySQL (requires XAMPP/phpMyAdmin)
- **Frontend**: Vanilla HTML5, CSS3, JavaScript (Single File)
- **Database**: MySQL (3rd Normal Form)

## Setup Instructions

### 1. Database Setup (XAMPP)
1. Open **XAMPP Control Panel** and start **Apache** and **MySQL**.
2. Go to [http://localhost/phpmyadmin](http://localhost/phpmyadmin).
3. Create a new database named `restaurant_db`.
4. Select `restaurant_db` and go to the **Import** tab.
5. Choose the SQL file located at `database/schema.sql` and click **Import**.

### 2. Backend Installation
1. Open a terminal in the project root directory.
2. Install dependencies:
   ```bash
   npm install
   ```
3. Ensure the `.env` file has the correct database credentials:
   ```env
   DB_HOST=localhost
   DB_USER=root
   DB_PASS=
   DB_NAME=restaurant_db
   ```

### 3. Running the Server
1. Start the Node.js server:
   ```bash
   node backend/server.js
   ```
2. The server should be running on `http://localhost:5000`.

### 4. Running the Frontend
1. Simply open `frontend/index.html` in any modern web browser.
2. Tip: Use a "Live Server" extension if possible, or just open the file directly.

## Credentials for Testing
- **Admin**: `admin@example.com` / `password123`
- **User**: `john@example.com` / `password123`

## Project Structure
```text
restaurant-management-system/
│
├── frontend/
│   └── index.html         # Single-file SPA
│
├── backend/
│   ├── server.js          # Entry point
│   ├── routes/            # API endpoints
│   ├── controllers/       # Business logic
│   ├── models/            # Database queries
│   └── middleware/        # JWT Auth
│
├── database/
│   └── schema.sql         # DB Design & Sample Data
│
├── config/
│   └── db.js              # MySQL Connection
│
├── .env                   # Configuration
└── README.md              # Documentation
```
