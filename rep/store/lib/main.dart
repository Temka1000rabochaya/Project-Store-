import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:store/providers/auth_provider.dart';
import 'package:store/providers/cart_provider.dart';
import 'package:store/providers/products_provider.dart';
import 'package:store/pages/basket.dart';
import 'package:store/pages/basketcheck.dart';
import 'package:store/pages/basketnocheck.dart';
import 'package:store/pages/consult.dart';
import 'package:store/pages/home.dart';
import 'package:store/pages/login.dart';
import 'package:store/pages/register.dart';
import 'package:store/pages/profilepage.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => ProductsProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Store',
      theme: ThemeData(
        primaryColor: Colors.blue,
        scaffoldBackgroundColor: Colors.white,
      ),
      home: FutureBuilder(
        future: Provider.of<AuthProvider>(context, listen: false).checkAuthStatus(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          return Consumer<AuthProvider>(
            builder: (context, auth, _) {
              return auth.isAuthenticated ? Home() : LoginPage();
            },
          );
        },
      ),
      routes: {
        '/H': (context) => Home(),
        '/B': (context) => Basket(),
        '/BC': (context) => BasketChecked(),
        '/BNC': (context) => BasketNotChecked(),
        '/C': (context) => const Consult(),
        '/R': (context) => Register(),
        '/L': (context) => LoginPage(),
        'PP': (context) => ProfilePage(),
      },
    );
  }
} 