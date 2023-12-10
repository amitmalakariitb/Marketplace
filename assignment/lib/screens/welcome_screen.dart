import 'package:flutter/material.dart';
import 'register_screen.dart';
import 'login_screen.dart';
import '../services/api_service.dart';

class WelcomeScreen extends StatelessWidget {
  final ApiService apiService;

  WelcomeScreen({required this.apiService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 100.0,
            ),
            SizedBox(height: 16),
            Text(
              'Welcome!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Container(
              height: 80.0,
            ),
            ElevatedButton(
              onPressed: () {
                _showRegisterOptions(context);
              },
              child: Text('Register'),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                _showLoginOptions(context);
              },
              child: Text('Login'),
            ),
          ],
        ),
      ),
    );
  }

  void _showRegisterOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Register as Seller'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen(userType: 'seller', apiService: apiService)));
              },
            ),
            ListTile(
              title: Text('Register as Buyer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => RegisterScreen(userType: 'buyer', apiService: apiService)));
              },
            ),
          ],
        );
      },
    );
  }

  void _showLoginOptions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('Login as Seller'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen(userType: 'seller', apiService: apiService)));
              },
            ),
            ListTile(
              title: Text('Login as Buyer'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen(userType: 'buyer', apiService: apiService)));
              },
            ),
          ],
        );
      },
    );
  }
}
