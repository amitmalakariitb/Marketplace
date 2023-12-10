const ItemModel = require('../models/ItemModel');

const createItem = async (req, res) => {
    try {
        const { description, image, sellerId, buyerId, isSold, price } = req.body;
        console.log("seller", sellerId);

        await ItemModel.createItem(description, image, sellerId, buyerId, isSold, price, (error, results) => {
            if (error) {
                console.error('Error creating item:', error);
                res.status(500).json({ message: 'Internal server error' });
            } else {
                console.log('Item created successfully:', results);
                res.status(201).json({ message: 'Item created successfully', itemId: results.insertId });
            }
        });
    } catch (error) {
        console.error('Error creating item:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

const getUnsoldItems = async (req, res) => {
    try {
        await ItemModel.getUnsoldItems((error, results) => {
            if (error) {
                console.error('Error fetching unsold items:', error);
                res.status(500).json({ message: 'Internal server error' });
            } else {
                console.log(results)
                console.log('Unsold items fetched successfully');
                res.status(200).json({ items: results });
            }
        });
    } catch (error) {
        console.error('Error fetching unsold items:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

const updateItem = async (req, res) => {
    try {
        const { itemId } = req.params;
        const { buyerId } = req.body;

        await ItemModel.updateItem(itemId, buyerId, (error, results) => {
            if (error) {
                console.error('Error updating item:', error);
                res.status(500).json({ message: 'Internal server error' });
            } else {
                console.log('Item updated successfully:', results);
                res.status(200).json({ message: 'Item updated successfully' });
            }
        });
    } catch (error) {
        console.error('Error updating item:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

const getItemsByBuyer = async (req, res) => {
    try {
        const { buyerId } = req.params;

        await ItemModel.getItemsByBuyer(buyerId, (error, results) => {
            if (error) {
                console.error('Error fetching items by buyer:', error);
                res.status(500).json({ message: 'Internal server error' });
            } else {
                console.log('Items fetched successfully');
                res.status(200).json({ items: results });
            }
        });
    } catch (error) {
        console.error('Error fetching items by buyer:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
};

const getSoldItems = (req, res) => {
    const sellerId = req.params.sellerId;
    console.log('hiting this api')

    ItemModel.getSoldItemsBySeller(sellerId, (error, items) => {
        if (error) {
            res.status(500).json({ message: 'Internal server error' });
        } else {
            console.log(items)
            res.status(200).json({ items: items });
        }
    });
};

module.exports = { createItem, updateItem, getUnsoldItems, getItemsByBuyer, getSoldItems };
