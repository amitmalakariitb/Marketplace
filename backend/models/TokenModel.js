const db = require('../db');

class TokenModel {
    static createToken(userId, userType, expiresIn, callback) {
        const query = 'INSERT INTO tokens (user_id, user_type, expires_in) VALUES (?, ?, ?)';
        db.query(query, [userId, userType, expiresIn], (error, results) => {
            if (error) {
                console.error('Error creating token:', error);
                callback(error, null);
            } else {
                callback(null, results);
            }
        });
    }

    static getTokenByUserId(userId, callback) {
        const query = 'SELECT * FROM tokens WHERE user_id = ?';
        db.query(query, [userId], (error, results) => {
            if (error) {
                console.error('Error fetching token:', error);
                callback(error, null);
            } else {
                callback(null, results[0]);
            }
        });
    }

}

module.exports = TokenModel;
