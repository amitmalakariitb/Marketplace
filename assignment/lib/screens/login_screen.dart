import 'package:flutter/material.dart';
import 'package:jwt_decode/jwt_decode.dart';
import '../services/api_service.dart';
import '../screens/buyer_home_screen.dart';
import '../screens/seller_home_screen.dart';

class LoginScreen extends StatelessWidget {
  final String userType;
  final ApiService apiService;

  LoginScreen({required this.userType, required this.apiService});

  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userType == 'seller') ...[
              TextField(
                controller: contactNumberController,
                decoration: InputDecoration(labelText: 'Contact Number'),
              ),
            ] else ...[
              TextField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
              ),
            ],
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: 'Password'),
            ),
            ElevatedButton(
              onPressed: () async {
                String contactNumber = contactNumberController.text;
                String email = emailController.text;
                String password = passwordController.text;

                final response = await ApiService.login(contactNumber, email, password);

                if (response != null) {
                  Map<String, dynamic> tokenMap = Jwt.parseJwt(response);

                  final userId = tokenMap['userId'].toString();
                  if (userType == 'seller') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SellerHomeScreen(apiService: apiService, sellerId: userId),
                      ),
                    );
                  } else {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => BuyerHomeScreen(apiService: apiService, userId: userId),
                      ),
                    );
                  }
                } else {
                }
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }
}
