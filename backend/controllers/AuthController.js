const SellerModel = require('../models/SellerModel');
const BuyerModel = require('../models/BuyerModel');
const TokenModel = require('../models/TokenModel');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

require('dotenv').config();

const secretKey = process.env.JWT_SECRET;
const register = async (req, res) => {
    try {
        const { name, contactNumber, email, balance, password } = req.body;
        const userType = contactNumber ? 'seller' : 'buyer';
        const hashedPassword = await bcrypt.hash(password, 10);

        if (userType === 'seller') {
            await SellerModel.createSeller(name, contactNumber, balance, hashedPassword, async (error, results) => {
                if (error) {
                    console.error('Error creating seller:', error);
                    res.status(500).json({ message: 'Internal server error' });
                } else {
                    console.log('Seller created successfully:', results);
                    const token = jwt.sign({ userId: results.insertId, userType }, secretKey, { expiresIn: '1h' });
                    await TokenModel.createToken(results.insertId, userType, '1h', () => { });

                    res.status(201).json({ token, message: `${userType} registered successfully` });
                }
            });
        } else {
            await BuyerModel.createBuyer(name, email, balance, hashedPassword, async (error, results) => {
                if (error) {
                    console.error('Error creating buyer:', error);
                    res.status(500).json({ message: 'Internal server error' });
                } else {
                    console.log('Buyer created successfully:', results);
                    const token = jwt.sign({ userId: results.insertId, userType }, secretKey, { expiresIn: '1h' });
                    await TokenModel.createToken(results.insertId, userType, '1h', () => { });

                    res.status(201).json({ token, message: `${userType} registered successfully` });
                }
            });
        }
    } catch (error) {
        console.error('Error registering user:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};


const login = async (req, res) => {
    try {
        const { contactNumber, email, password } = req.body;

        const userType = contactNumber ? 'seller' : 'buyer';

        const user = userType === 'seller'
            ? await new Promise((resolve, reject) => {
                SellerModel.getSellerByContactNumber(contactNumber, (error, seller) => {
                    if (error) {
                        console.error('Error fetching seller:', error);
                        reject(error);
                    } else {
                        console.log('Fetched seller:', seller);
                        resolve(seller);
                    }
                });
            })
            : await new Promise((resolve, reject) => {
                BuyerModel.getBuyerByEmail(email, (error, buyer) => {
                    if (error) {
                        console.error('Error fetching buyer:', error);
                        reject(error);
                    } else {
                        console.log('Fetched buyer:', buyer);
                        resolve(buyer);
                    }
                });
            });

        if (!user) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const passwordMatch = await bcrypt.compare(password, user.password);
        console.log(passwordMatch)

        if (!passwordMatch) {
            return res.status(401).json({ message: 'Invalid credentials' });
        }

        const token = jwt.sign({ userId: String(user.id), userType }, secretKey, { expiresIn: '1h' });


        res.status(200).json({ token });

    } catch (error) {
        console.error('Error logging in user:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

module.exports = { register, login };
