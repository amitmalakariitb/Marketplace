const SellerModel = require('../models/SellerModel');
const BuyerModel = require('../models/BuyerModel');

async function getUserDetails(req, res) {
    const userId = req.params.userId;

    try {
        const seller = await SellerModel.getSellerById(userId);

        if (seller) {
            return res.status(200).json({
                userType: 'seller',
                userDetails: seller,
                balance: seller.balance
            });
        }

        const buyer = await BuyerModel.getBuyerById(userId);

        if (buyer) {
            return res.status(200).json({
                userType: 'buyer',
                userDetails: buyer,
                balance: buyer.balance
            });
        }

        return res.status(404).json({ message: 'User not found' });
    } catch (error) {
        console.error('Error fetching user details:', error);
        return res.status(500).json({ message: 'Internal server error' });
    }
}

module.exports = {
    getUserDetails
};
