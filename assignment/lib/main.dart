import 'package:flutter/material.dart';
import './screens/welcome_screen.dart';
import './services/api_service.dart';

void main() {
  ApiService apiService = ApiService();

  WelcomeScreen welcomeScreen = WelcomeScreen(apiService: apiService);

  // Run the app
  runApp(MyApp(welcomeScreen));
}

class MyApp extends StatelessWidget {
  final WelcomeScreen welcomeScreen;

  MyApp(this.welcomeScreen);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: welcomeScreen,
    );
  }
}
