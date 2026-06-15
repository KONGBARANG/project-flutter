import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'features/auth/auth_gate.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/register_screen.dart';
import 'features/products/product_list_screen.dart';
import 'features/checkout/checkout_screen.dart';
import 'providers/auth_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/language_provider.dart';

void main() {
  runApp(const MyApp());
}

// 1. ប្តូរទៅជា StatefulWidget ដើម្បីអាចកាន់ State នៃ Dark Mode បាន
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // បង្កើត variable សម្រាប់ផ្ទុក State នៃ Dark Mode (ដំបូងឱ្យស្មើ false គឺ Light Mode)
  bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()), // បន្ថែម LanguageProvider ទៅក្នុង MultiProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        
        // 2. រៀបចំកំណត់ Theme សម្រាប់ Light និង Dark Mode
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.light,
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.deepPurple,
            brightness: Brightness.dark,
          ),
        ),
        // បញ្ជាប្តូរ Mode ទៅតាមតម្លៃ variable _isDarkMode
        themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
        
        initialRoute: '/',
        routes: {
          // 3. បោះតម្លៃ _isDarkMode និង function onThemeChanged ទៅឱ្យ AuthGate
          '/': (context) => AuthGate(
                isDarkMode: _isDarkMode,
                onThemeChanged: (value) {
                  setState(() {
                    _isDarkMode = value; // ធ្វើការ update ទូទាំង App ពេលមានការដូរ Switch
                  });
                },
              ),
          '/login': (context) => const LoginScreen(),
          '/register': (context) => const RegisterScreen(),
          '/products': (context) => const ProductListScreen(),
          '/checkout': (context) => const CheckoutScreen(),
        },
      ),
    );
  }
}