import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/auth_gate.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/products/product_list_screen.dart';
import 'features/checkout/checkout_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        ),
        initialRoute: '/',
        routes: {
          '/': (context) => const AuthGate(),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/products': (context) => const ProductListScreen(),
          '/checkout': (context) => const CheckoutScreen(),
        },
      ),
    );
  }
}
