const db = require('../db');

class ItemModel {
    static createItem(description, image, sellerId, buyerId, isSold, price, callback) {
        const query = 'INSERT INTO items (description, image, seller_id, buyer_id, is_sold, price) VALUES (?, ?, ?, ?, false, ?)';
        db.query(query, [description, image, sellerId, buyerId, isSold, price || null, isSold, price], (error, results) => {
            if (error) {
                console.error('Error creating item:', error);
                callback(error, null);
            } else {
                callback(null, results);
            }
        });
    }


    static getItems(callback) {
        const query = 'SELECT * FROM items';
        db.query(query, (error, results) => {
            if (error) {
                console.error('Error fetching items:', error);
                callback(error, null);
            } else {
                callback(null, results);
            }
        });
    }

    static getUnsoldItems(callback) {
        const query = 'SELECT * FROM items WHERE is_sold IS NULL OR is_sold = false';
        db.query(query, (error, results) => {
            if (error) {
                console.error('Error fetching unsold items:', error);
                callback(error, null);
            } else {
                const unsoldItems = results.map(item => ({
                    description: item.description,
                    price: parseFloat(item.price) || 0,
                    imageUrl: item.imageUrl,
                    isSold: item.is_sold === 1,
                }));
                callback(null, unsoldItems);
            }
        });
    }


    static getItemById(itemId, callback) {
        const query = 'SELECT * FROM items WHERE id = ?';
        db.query(query, [itemId], (error, results) => {
            if (error) {
                console.error('Error fetching item by ID:', error);
                callback(error, null);
            } else {
                callback(null, results[0]);
            }
        });
    }
    static updateItem(itemId, buyerId, callback) {
        const query = 'UPDATE items SET is_sold = true, buyer_id = ? WHERE id = ?';
        db.query(query, [buyerId, itemId], (error, results) => {
            if (error) {
                console.error('Error updating item:', error);
                callback(error, null);
            } else {
                callback(null, results);
            }
        });
    }
    static getItemsByBuyer(buyerId, callback) {
        const query = 'SELECT * FROM items WHERE buyer_id = ?';
        db.query(query, [buyerId], (error, results) => {
            if (error) {
                console.error('Error fetching items by buyer:', error);
                callback(error, null);
            } else {
                callback(null, results);
            }
        });
    }
    static getSoldItemsBySeller(sellerId, callback) {
        const query = 'SELECT * FROM items WHERE seller_id = ? AND is_sold = NULL';
        db.query(query, [sellerId], (error, results) => {
            if (error) {
                console.error('Error fetching sold items by seller:', error);
                callback(error, null);
            } else {
                const soldItems = results.map(item => ({
                    description: item.description,
                    price: parseFloat(item.price),
                    imageUrl: item.imageUrl,
                }));
                callback(null, soldItems);
            }
        });
    }
}

module.exports = ItemModel;
