import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/user_model.dart';
import './welcome_screen.dart';

class RegisterScreen extends StatelessWidget {
  final String userType;
  final ApiService apiService;

  RegisterScreen({required this.userType, required this.apiService});

  final TextEditingController nameController = TextEditingController();
  final TextEditingController contactNumberController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> _showRegistrationResultDialog(BuildContext context, bool success) async {
    String message = success
        ? 'Registered successfully. Please login to continue.'
        : 'Registration failed. Please try again.';

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(success ? 'Success' : 'Failure'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                if (success) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => WelcomeScreen(apiService: apiService),
                    ),
                  );
                }
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Register')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (userType == 'seller') ...[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: contactNumberController,
                decoration: InputDecoration(labelText: 'Contact Number'),
              ),
            ] else ...[
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
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
                User user = User(
                  name: nameController.text,
                  contactNumber: contactNumberController.text,
                  email: emailController.text,
                  password: passwordController.text,
                );

                bool success = await ApiService.register(user);
                await _showRegistrationResultDialog(context, success);
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
