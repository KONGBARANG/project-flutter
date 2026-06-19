import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart';
import '../../providers/cart_provider.dart'; 
import '../products/product_list_screen.dart';
import '../../models/product.dart';
import '../orders/order_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  // អនុគមន៍ជំនួយសម្រាប់បកប្រែឈ្មោះ Category
  String _getTranslatedCategory(String categoryName, LanguageProvider langProvider) {
    switch (categoryName) {
      case 'Clothes':
        return langProvider.translate('cat_clothes');
      case 'Jewelry':
        return langProvider.translate('cat_jewelry');
      case 'Tech':
        return langProvider.translate('cat_tech');
      case 'Bags':
        return langProvider.translate('cat_bags');
      default:
        return categoryName;
    }
  }

@override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);

    // ត្រឡប់មកវិញនូវ Scaffold ដែលមាន AppBar និង body
    return Scaffold(
      appBar: AppBar(
        title: const Text("Shopify"),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'My Orders',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const OrderScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildPromoBanner(context, langProvider),
              const SizedBox(height: 24),
              Text(
                langProvider.translate('top_categories'), 
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildCategoryRow(context, langProvider),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    langProvider.translate('trending_now'), 
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const ProductListScreen()),
                      );
                    },
                    child: Text(
                      langProvider.translate('see_all'), 
                      style: const TextStyle(color: Color(0xFFBB86FC)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildTrendingList(context, langProvider), 
            ],
          ),
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildPromoBanner(BuildContext context, LanguageProvider langProvider) {
    return Container(
      width: double.infinity,
      height: 200, 
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50, 
        borderRadius: BorderRadius.circular(16),
        image: const DecorationImage(
          image: NetworkImage('https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=800&q=80'),
          fit: BoxFit.cover,
          opacity: 0.7,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              langProvider.translate('summer_sale'), 
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              langProvider.translate('up_to_50'), 
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ProductListScreen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
              ),
              child: Text(langProvider.translate('shop_now')), 
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(BuildContext context, LanguageProvider langProvider) {
    final categories = [
      {'icon': Icons.checkroom, 'name': 'Clothes', 'apiValue': "men's clothing"},
      {'icon': Icons.watch, 'name': 'Jewelry', 'apiValue': 'jewelery'},
      {'icon': Icons.devices, 'name': 'Tech', 'apiValue': 'electronics'},
      {'icon': Icons.backpack, 'name': 'Bags', 'apiValue': "women's clothing"},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((cat) {
        final rawName = cat['name'] as String;
        final apiValue = cat['apiValue'] as String;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductListScreen(initialCategory: apiValue),
              ),
            );
          },
          child: Column(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundColor: Colors.grey.shade200,
                child: Icon(cat['icon'] as IconData, color: Colors.deepPurple, size: 28),
              ),
              const SizedBox(height: 8),
              Text(
                _getTranslatedCategory(rawName, langProvider),
                style: const TextStyle(fontWeight: FontWeight.w500),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildTrendingList(BuildContext context, LanguageProvider langProvider) {
    final List<String> trendingImages = [
      'https://images.unsplash.com/photo-1603252109303-2751441dd157?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTJ8fENsZWFuJTIwY2xvdGhlc3xlbnwwfHwwfHx8MA%3D%3D', 
      'https://media.istockphoto.com/id/946468798/photo/men-select-new-shirt-in-shopping-mall.webp?a=1&b=1&s=612x612&w=0&k=20&c=Xo_9XnctWAul4X3eSTZ0iI2ps9ycztYub4KgQWCErgA=', 
      'https://images.unsplash.com/photo-1687226425845-2f2ab8bf9dcf?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDIxfHx8ZW58MHx8fHx8', 
      'https://images.unsplash.com/photo-1731865383721-0fd2f97ee077?w=400&auto=format&fit=crop&q=60&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1yZWxhdGVkfDIzfHx8ZW58MHx8fHx8', 
    ];

    final bool isKhmer = langProvider.currentLocale == 'km';

    return SizedBox(
      height: 235, 
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), 
        itemCount: trendingImages.length, 
        itemBuilder: (itemContext, index) { 
          final String title = isKhmer
              ? "ទំនិញពេញនិយមទី ${index + 1}"
              : "Trending Item ${index + 1}";
          const double price = 29.99;
          final String imageUrl = trendingImages[index];
          final String productId = "trending_p_${index + 1}";

          return GestureDetector(
            onTap: () {
              // 🟢 FIX LOGIC: បើកទៅទំព័រផលិតផលពិតៗ តាមប្រភេទផ្សេងៗគ្នា ដើម្បីកុំឱ្យចេញ "No products found"
              List<String> mockCategories = ["men's clothing", "jewelery", "electronics", "women's clothing"];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ProductListScreen(initialCategory: mockCategories[index]),
                ),
              );
            },
            child: Container(
              width: 165,
              margin: const EdgeInsets.only(right: 14, bottom: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E2E), 
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Stack(
                      children: [
                        Image.network(
                          imageUrl,
                          height: 135,
                          width: double.infinity,
                          fit: BoxFit.cover, 
                          errorBuilder: (imgContext, error, stackTrace) {
                            return Container(
                              height: 135,
                              color: Colors.grey.shade800,
                              child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                            );
                          },
                        ),
                        Positioned(
                          top: 8,
                          left: 8,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text(
                              'HOT',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "\$$price",
                              style: const TextStyle(
                                color: Color(0xFFBB86FC), 
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                            ),
                            
                            // Circular Add to Cart Button
                            Material(
                              color: Colors.transparent,
                              child: InkWell(
                                borderRadius: BorderRadius.circular(20),
                                onTap: () {
                                  // 🟢 FIX ADD_TO_CART: បានតម្រូវទម្រង់ផ្ញើតម្លៃទៅកាន់ CartProvider ឱ្យបានត្រឹមត្រូវ
                                  final newProduckt = Product(
                                    id: index + 100,
                                    title: title,
                                    price: price,
                                    description: 'Description for $title',
                                    category: 'trending',
                                    image: imageUrl,
                                    rating: 4.5,
                                  );
                                  Provider.of<CartProvider>(context, listen: false).addToCart(newProduckt);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text(isKhmer 
                                          ? 'បានដាក់ $title ចូលកន្ត្រក!' 
                                          : 'Added $title to cart!'),
                                      backgroundColor: Colors.green,
                                      duration: const Duration(seconds: 1),
                                      behavior: SnackBarBehavior.floating,
                                    ),
                                  );
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF673AB7), 
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.add_shopping_cart,
                                    size: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}