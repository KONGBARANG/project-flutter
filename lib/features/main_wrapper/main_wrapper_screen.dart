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
import '../../providers/language_provider.dart'; // ១. Import LanguageProvider ចូលមក

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
    _pages = [
      const HomeScreen(),         // Index 0
      const NotificationScreen(), // Index 1
      const ProfileScreen(),      // Index 2
      
      // បោះតម្លៃ variables ទៅឱ្យ SettingScreen ដើម្បីបញ្ជាដូរ Theme
      SettingScreen(
        isDarkMode: widget.isDarkMode,
        onThemeChanged: widget.onThemeChanged,
      ),                          // Index 3
      
      const ApiTestScreen(),      // Index 4
      const ProductListScreen(),  // Index 5
      Consumer<CartProvider>(
        builder: (context, cartProvider, _) => CartScreen(cartProvider: cartProvider),
      ),                          // Index 6
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
    
    // ២. ហៅប្រើ LanguageProvider ដើម្បីទាញពាក្យបកប្រែ
    final langProvider = Provider.of<LanguageProvider>(context);

    if (!auth.isLoggedIn) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, '/');
      });
      return const SizedBox.shrink();
    }

    // បង្កើតបញ្ជី index សម្រាប់ម៉ាបជាមួយ BottomNavigationBar (ដែលមានតែ ៤ ប៊ូតុង)
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
            tooltip: langProvider.translate('logout'), // ៣. ប្រើភាសាតាម Provider លើ Tooltip
            onPressed: () {
              auth.logout();
              Navigator.pushReplacementNamed(context, '/');
            },
          ),
          // Cart badge លើ AppBar
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
                langProvider.translate('settings'), // ៤. ប្ដូរចំណងជើង Menu ធំ
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(langProvider.translate('home')), // ៥. ភាសាខ្មែរ/អង់គ្លេស លើ Home
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(0);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_bag),
              title: Text(langProvider.translate('shop')), // ៦. ភាសាខ្មែរ/អង់គ្លេស លើ Products
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(5);
              },
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart),
              title: Text(langProvider.translate('cart')), // ៧. ភាសាខ្មែរ/អង់គ្លេស លើ Cart
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(6);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(langProvider.translate('profile')), // ៨. ភាសាខ្មែរ/អង់គ្លេស លើ Profile
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(2);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings),
              title: Text(langProvider.translate('settings')), // ៩. ភាសាខ្មែរ/អង់គ្លេស លើ Settings
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(3);
              },
            ),
            ListTile(
              leading: const Icon(Icons.notifications),
              title: Text(langProvider.translate('notif')), // ១០. ភាសាខ្មែរ/អង់គ្លេស លើ Notifications
              onTap: () {
                Navigator.pop(context);
                _onItemTapped(1);
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(
                langProvider.translate('logout'), // ១១. ភាសាខ្មែរ/អង់គ្លេស លើ Logout
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
      
      // ១២. ប្ដូរអក្សរនៅលើរបារខាងក្រោម (BottomNavigationBar) ទាំង ៤ គ្រាប់
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