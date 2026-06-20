import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../home/home_screen.dart';
import '../notification/notification_screen.dart';
import '../profile/profile_screen.dart';
import '../setting/setting_screen.dart';
import '../api_test/api_test_screen.dart';
import '../products/product_list_screen.dart';
import '../cart/cart_screen.dart';
import '../../providers/cart_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/language_provider.dart';

class MainWrapperScreen extends StatefulWidget {
  final bool isDarkMode;
  final ValueChanged<bool> onThemeChanged;

  const MainWrapperScreen({
    super.key,
    required this.isDarkMode,
    required this.onThemeChanged,
  });

  @override
  State<MainWrapperScreen> createState() => _MainWrapperScreenState();
}

class _MainWrapperScreenState extends State<MainWrapperScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    // កែសម្រួលចំណុចនេះ៖ ហៅ CartScreen() ដោយមិនចាំបាច់បញ្ជូន cartProvider
    _pages = [
      const HomeScreen(),         // Index 0
      const NotificationScreen(), // Index 1
      const ProfileScreen(),      // Index 2
      SettingScreen(              // Index 3
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),
      const ApiTestScreen(),      // Index 4
      const ProductListScreen(),  // Index 5
      const CartScreen(),         // Index 6 (បានកែត្រង់នេះ)
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);
    final langProvider = Provider.of<LanguageProvider>(context);

    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const SizedBox.shrink();
    }

    final List<int> navBarIndices = [0, 3, 4, 5];
    int currentNavBarIndex = navBarIndices.indexOf(_selectedIndex);
    if (currentNavBarIndex == -1) {
      currentNavBarIndex = 0;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Project Mobile App'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: langProvider.translate('logout'),
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          Consumer<CartProvider>(
            builder: (context, cartProvider, _) => Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Stack(
                alignment: Alignment.topRight,
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart),
                    onPressed: () => _onItemTapped(6),
                  ),
                  if (cartProvider.itemCount > 0)
                    Container(
                      padding: const EdgeInsets.all(2),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                      child: Text(
                        '${cartProvider.itemCount}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.deepPurple),
              child: Text(
                langProvider.translate('settings'),
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(langProvider.translate('home')),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: Text(langProvider.translate('shop')),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(5);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text(langProvider.translate('cart')),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(6);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(langProvider.translate('profile')),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(langProvider.translate('settings')),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(langProvider.translate('notif')),
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                langProvider.translate('logout'),
                style: const TextStyle(color: Colors.red),
              ),
              onTap: () {
                Navigator.pop(context);
                auth.logout();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentNavBarIndex,
        onTap: (index) {
          _onItemTapped(navBarIndices[index]);
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: langProvider.translate('home'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: langProvider.translate('settings'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.api),
            label: langProvider.translate('api'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.store),
            label: langProvider.translate('shop'),
          ),
        ],
      ),
    );
  }
}