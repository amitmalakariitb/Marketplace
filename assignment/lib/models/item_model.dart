class Item {
  final String id;
  final String description;
  final String imageUrl;
  final double price;
  final String sellerId;
  final String buyerId;
  final bool isSold;

  Item({
    required this.id,
    required this.description,
    required this.imageUrl,
    required this.price,
    required this.sellerId,
    required this.buyerId,
    required this.isSold,
  });

  @override
  String toString() {
    return 'Item(id: $id, description: $description, imageUrl: $imageUrl, price: $price, sellerId: $sellerId, buyerId: $buyerId, isSold: $isSold)';
  }

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] ?? '',
      description: json['description'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      price: (json['price'] is num) ? json['price'].toDouble() : 0,
      sellerId: json['sellerId'] ?? '',
      buyerId: json['buyerId'] ?? '',
      isSold: json['isSold'] == false, 
    );
  }
}
