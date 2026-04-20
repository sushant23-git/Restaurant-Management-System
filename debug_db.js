const db = require('./config/db');

async function checkDB() {
    try {
        const [users] = await db.query('SELECT COUNT(*) as count FROM users');
        const [restaurants] = await db.query('SELECT COUNT(*) as count FROM restaurants');
        const [menu] = await db.query('SELECT COUNT(*) as count FROM menu_items');
        
        console.log('Users:', users[0].count);
        console.log('Restaurants:', restaurants[0].count);
        console.log('Menu Items:', menu[0].count);
    } catch (err) {
        console.error('Database Error:', err.message);
    } finally {
        process.exit();
    }
}

checkDB();
