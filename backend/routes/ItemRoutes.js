const express = require('express');
const router = express.Router();
const ItemController = require('../controllers/ItemController');


router.post('/create', ItemController.createItem);
router.get('/unsold', ItemController.getUnsoldItems);
router.put('/:itemId', ItemController.updateItem);
router.get('/buyer/:buyerId', ItemController.getItemsByBuyer);
router.get('/sold/:sellerId', ItemController.getSoldItems);

module.exports = router;
