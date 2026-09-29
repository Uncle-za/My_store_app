import 'package:flutter/material.dart';
import 'models/app_state.dart';
import 'pages/home_page.dart';
import 'pages/login_page.dart';

void main() {
  runApp(const EcommerceApp());
}

class EcommerceApp extends StatelessWidget {
  const EcommerceApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Store',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
        ),
        useMaterial3: true,
      ),
      // Shows the login screen until the user signs in.
      home: ListenableBuilder(
        listenable: AppState.auth,
        builder: (context, _) {
          return AppState.auth.isLoggedIn
              ? const HomePage()
              : const LoginPage();
        },
      ),
    );
  }
}
