import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/item_model.dart';
import 'marketplace_screen.dart'; 

class BuyerHomeScreen extends StatefulWidget {
  final ApiService apiService;
  final String userId;

  BuyerHomeScreen({required this.apiService, required this.userId});

  @override
  _BuyerHomeScreenState createState() => _BuyerHomeScreenState();
}

class _BuyerHomeScreenState extends State<BuyerHomeScreen> {
  late Future<double> balanceFuture;
  late Future<List<Item>> itemsFuture;
  int _currentIndex = 0; 

  @override
  void initState() {
    super.initState();
    
    balanceFuture = widget.apiService.getBuyerBalance(widget.userId);
    itemsFuture = ApiService.getItemsBoughtByBuyer(widget.userId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buyer Home'),
      ),
      body: _buildBody(), 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
      
          setState(() {
            _currentIndex = index;
          });
          if (index == 1) {
          
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MarketplaceScreen(apiService: widget.apiService, userId: widget.userId),
              ),
            );
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_cart),
            label: 'Marketplace',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  Widget _buildBody() {
    return Padding(
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
                  'Balance: \$${snapshot.data}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                );
              }
            },
          ),
          SizedBox(height: 16),
          FutureBuilder<List<Item>>(
            future: itemsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }  else if (snapshot.data == null) {
                return Text('No items purchased yet.');
              } else {
                return Expanded(
                  child: ListView.builder(
                    itemCount: snapshot.data!.length,
                    itemBuilder: (context, index) {
                      Item item = snapshot.data![index];
                      return Card(
                        elevation: 4,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(item.imageUrl, height: 150, width: double.infinity, fit: BoxFit.cover),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.description,
                                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    'Price: \$${item.price}',
                                    style: TextStyle(fontSize: 16, color: Colors.green),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
