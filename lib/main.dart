import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_cart_app/Provider/cart_provider.dart';
import 'Screens/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: Builder(builder: (BuildContext context) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Shopping Cart App',
          theme: ThemeData(
            brightness: Brightness.dark,
            primarySwatch: Colors.blue,
            useMaterial3: true,
          ),
          home: const SplashScreen(),
        );
      }),
    );
  }
}
