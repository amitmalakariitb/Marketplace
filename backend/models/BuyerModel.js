const db = require('../db');

class BuyerModel {
    static createBuyer(name, email, balance, password, callback) {
        const query = 'INSERT INTO buyers (name, email, balance, password) VALUES (?, ?, ?, ?)';
        db.query(query, [name, email, balance, password], (error, results) => {
            if (error) {
                console.error('Error creating buyer:', error);
                callback(error, null);
            } else {
                callback(null, results);
            }
        });
    }

    static getBuyers(callback) {
        const query = 'SELECT * FROM buyers';
        db.query(query, (error, results) => {
            if (error) {
                console.error('Error fetching buyers:', error);
                callback(error, null);
            } else {
                callback(null, results);
            }
        });
    }

    static getBuyerByEmail(email, callback) {
        const query = 'SELECT * FROM buyers WHERE email = ?';
        db.query(query, [email], (error, results) => {
            if (error) {
                console.error('Error fetching buyer by email:', error);
                callback(error, null);
            } else {
                callback(null, results[0]);
            }
        });
    }
    static getBuyerById(buyerId) {
        return new Promise((resolve, reject) => {
            const query = 'SELECT * FROM buyers WHERE id = ?';
            db.query(query, [buyerId], (error, results) => {
                if (error) {
                    console.error('Error fetching buyer by ID:', error);
                    reject(error);
                } else {
                    resolve(results[0]);
                }
            });
        });
    }
}

module.exports = BuyerModel;
