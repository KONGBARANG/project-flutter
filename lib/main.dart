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
import 'providers/profile_provider.dart';
import 'providers/theme_provider.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  final bool _isDarkMode = false;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()), // បន្ថែម LanguageProvider ទៅក្នុង MultiProvider
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
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
          // Use ThemeProvider to control theme
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

          initialRoute: '/',
          routes: {
            // 3. Provide current theme mode and onThemeChanged to AuthGate
            '/': (context) => AuthGate(
                  isDarkMode: themeProvider.isDarkMode,
                  onThemeChanged: (value) {
                    themeProvider.toggleTheme(value);
                  },
                ),
            '/login': (context) => const LoginScreen(),
            '/register': (context) => const RegisterScreen(),
            '/products': (context) => const ProductListScreen(),
            '/checkout': (context) => const CheckoutScreen(),
          },
        ),
      ),
    );
  }
}