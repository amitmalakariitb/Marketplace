import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';
import '../models/item_model.dart';


class ApiService {
  static const String baseUrl = 'http://127.0.0.1:3001'; 

  static Future<bool> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 201) {
        // Registration successful
        print('Registration successful');
        return true;
      } else {
        // Registration failed
        print('Registration failed. Error: ${response.body}');
        return false;
      }
    } catch (error) {
      print('Error during registration: $error');
      return false;
    }
  }


  static Future<String?> login(String contactNumber, String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'contactNumber': contactNumber,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      // Login successful
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String token = data['token'];
      print('Login successful. Token: $token');
      return token;
    } else {
      // Login failed
      print('Login failed. Error: ${response.body}');
      return null;
    }
  }
  static Future<List<Item>> getItemsBoughtByBuyer(String buyerId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/items/bought?buyerId=$buyerId'), 
    );

    if (response.statusCode == 200) {
      final List<dynamic> data = jsonDecode(response.body);
      return data.map((itemJson) => Item.fromJson(itemJson)).toList();
    } else {
      throw Exception('Failed to load items bought by the buyer');
    }
  }
  Future<double> getBuyerBalance(String userId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/api/user/$userId'),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = jsonDecode(response.body);
      final String userType = data['userType'];
      final double balance = data['balance'] ?? 0.0; 
      return balance;
    } else {
      throw Exception('Failed to load buyer balance');
    }
  }

  Future<void> sellItem(String sellerId, String description, double price, String imageUrl) async {
    try {
      final Map<String, dynamic> requestData = {
        'description': description,
        'price': price, 
        'image': imageUrl,
        'sellerId': sellerId,
      };

      final response = await http.post(
        Uri.parse('$baseUrl/api/items/create'), 
        body: jsonEncode(requestData),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 201) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        if (responseBody.containsKey('message') && responseBody.containsKey('itemId')) {
          print('Item sold successfully. Item ID: ${responseBody['itemId']}');
        } else {
          print('Failed to sell item. Unexpected response format: ${response.body}');
        }
      } else {
        print('Failed to sell item. Status code: ${response.statusCode}');
        print('Response body: ${response.body}');
      }
    } catch (error) {
      print('Error selling item: $error');
    }
  }


  Future<List<Item>> getUnsoldItems() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/api/items/unsold'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body)['items'] as List<dynamic>;
        List<Item> items = data.map((item) => Item.fromJson(item)).toList();
        return items;
      } else {
        throw Exception('Failed to load unsold items');
      }
    } catch (e) {
      throw Exception('Error fetching unsold items: $e');
    }
  }

  Future<void> purchaseItem(String itemId, String buyerId) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/items/$itemId'),
        body: {'buyerId': buyerId},
      );
      print(response);

      if (response.statusCode != 200) {
        throw Exception('Failed to purchase item');
      }
    } catch (e) {
      throw Exception('Error purchasing item: $e');
    }
  }
  Future<List<SoldItem>> getSoldItems(String sellerId) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/items/sold/$sellerId'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['items'];
        List<SoldItem> items = data.map((itemJson) => SoldItem.fromJson(itemJson)).toList();
        return items;
      } else {
        throw Exception('Failed to load sold items');
      }
    } catch (e) {
      throw Exception('Error fetching sold items: $e');
    }
  }
}

class SoldItem {
  final String description;
  final double price;
  final String imageUrl;

  SoldItem({
    required this.description,
    required this.price,
    required this.imageUrl,
  });

  factory SoldItem.fromJson(Map<String, dynamic> json) {
    return SoldItem(
      description: json['description'],
      price: (json['price'] is int) ? (json['price'] as int).toDouble() : json['price'].toDouble(),
      imageUrl: json['imageUrl'],
    );
  }
}

