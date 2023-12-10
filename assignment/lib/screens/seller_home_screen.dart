import 'package:flutter/material.dart';
import '../services/api_service.dart';

class SellerHomeScreen extends StatefulWidget {
  final ApiService apiService;
  final String sellerId;

  SellerHomeScreen({required this.apiService, required this.sellerId});

  @override
  _SellerHomeScreenState createState() => _SellerHomeScreenState();
}

class _SellerHomeScreenState extends State<SellerHomeScreen> {
  late Future<double> balanceFuture;
  late Future<List<SoldItem>> soldItemsFuture;

  @override
  void initState() {
    super.initState();
    balanceFuture = widget.apiService.getBuyerBalance(widget.sellerId);
    soldItemsFuture = widget.apiService.getSoldItems(widget.sellerId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Seller Home'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FutureBuilder<double>(
              future: balanceFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading balance: ${snapshot.error}');
                } else {
                  return Text(
                    'Total Balance: \$${snapshot.data}',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            FutureBuilder<List<SoldItem>>(
              future: soldItemsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator();
                } else if (snapshot.hasError) {
                  return Text('Error loading sold items: ${snapshot.error}');
                } else {
                  return Expanded(
                    child: ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        SoldItem soldItem = snapshot.data![index];
                        return ListTile(
                          title: Text(soldItem.description),
                          subtitle: Text('\$${soldItem.price.toString()}'),
                          leading: Image.network(soldItem.imageUrl),
                        );
                      },
                    ),
                  );
                }
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showSellItemPopup(context);
              },
              child: Text('Sell New Item'),
            ),
          ],
        ),
      ),
    );
  }

  void _showSellItemPopup(BuildContext context) {
    TextEditingController descriptionController = TextEditingController();
    TextEditingController priceController = TextEditingController();
    TextEditingController imageController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Sell New Item'),
          content: Column(
            children: [
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(labelText: 'Item Description'),
              ),
              TextField(
                controller: priceController,
                decoration: InputDecoration(labelText: 'Item Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: imageController,
                decoration: InputDecoration(labelText: 'Item Image URL'),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () async {
                await widget.apiService.sellItem(
                  widget.sellerId,
                  descriptionController.text,
                  double.parse(priceController.text),
                  imageController.text,
                );

                setState(() {
                  balanceFuture = widget.apiService.getBuyerBalance(widget.sellerId);
                  soldItemsFuture = widget.apiService.getSoldItems(widget.sellerId);
                });

                Navigator.pop(context);
              },
              child: Text('Sell Item'),
            ),
          ],
        );
      },
    );
  }
}
