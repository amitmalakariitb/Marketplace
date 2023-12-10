const db = require('../db');

class SellerModel {
    static createSeller(name, contactNumber, balance, password, callback) {
        const query = 'INSERT INTO sellers (name, contact_number, balance, password) VALUES (?, ?, ?, ?)';
        db.query(query, [name, contactNumber, balance, password], (error, results) => {
            if (error) {
                console.error('Error creating seller:', error);
                callback(error, null);
            } else {
                callback(null, results);
            }
        });
    }

    static getSellers(callback) {
        const query = 'SELECT * FROM sellers';
        db.query(query, (error, results) => {
            if (error) {
                console.error('Error fetching sellers:', error);
                callback(error, null);
            } else {
                callback(null, results);
            }
        });
    }

    static getSellerByContactNumber(contactNumber, callback) {
        const query = 'SELECT * FROM sellers WHERE contact_number = ?';
        db.query(query, [contactNumber], (error, results) => {
            if (error) {
                console.error('Error fetching seller by contact number:', error);
                callback(error, null);
            } else {
                callback(null, results[0]);
            }
        });
    }
    static getSellerById(sellerId) {
        return new Promise((resolve, reject) => {
            const query = 'SELECT * FROM sellers WHERE id = ?';
            db.query(query, [sellerId], (error, results) => {
                if (error) {
                    console.error('Error fetching seller by ID:', error);
                    reject(error);
                } else {
                    resolve(results[0]);
                }
            });
        });
    }
}

module.exports = SellerModel;
