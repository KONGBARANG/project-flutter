import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/language_provider.dart'; // ១. Import LanguageProvider ចូលមក

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  // អនុគមន៍ជំនួយសម្រាប់បកប្រែឈ្មោះ Category ដែលសរសេរចាក់ងាប់
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
    // ២. ហៅប្រើ LanguageProvider នៅក្នុងទំព័រនេះ
    final langProvider = Provider.of<LanguageProvider>(context);

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Promotional Hero Banner (ប្ដូរអក្សរខាងក្នុងតាមភាសា)
            _buildPromoBanner(langProvider),
            const SizedBox(height: 24),
            
            // 2. Quick Categories
            Text(
              langProvider.translate('top_categories'), // "ប្រភេទទំនិញពេញនិយម" / "Top Categories"
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildCategoryRow(langProvider),
            const SizedBox(height: 24),
            
            // 3. Trending Products (Horizontal Scroll)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  langProvider.translate('trending_now'), // "ទំនិញកំពុងពេញនិយម" / "Trending Now"
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to the Shop page
                  },
                  child: Text(langProvider.translate('see_all')), // "មើលទាំងអស់" / "See All"
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTrendingList(langProvider),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildPromoBanner(LanguageProvider langProvider) {
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
              langProvider.translate('summer_sale'), // "ការលក់បញ្ចុះតម្លៃរដូវក្ដៅ"
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              langProvider.translate('up_to_50'), // "បញ្ចុះតម្លៃរហូតដល់ ៥០%..."
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.deepPurple,
              ),
              child: Text(langProvider.translate('shop_now')), // "ទិញឥឡូវនេះ"
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow(LanguageProvider langProvider) {
    final categories = [
      {'icon': Icons.checkroom, 'name': 'Clothes'},
      {'icon': Icons.watch, 'name': 'Jewelry'},
      {'icon': Icons.devices, 'name': 'Tech'},
      {'icon': Icons.backpack, 'name': 'Bags'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((cat) {
        final rawName = cat['name'] as String;
        return Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              child: Icon(cat['icon'] as IconData, color: Colors.deepPurple, size: 28),
            ),
            const SizedBox(height: 8),
            Text(
              _getTranslatedCategory(rawName, langProvider), // ប្ដូរឈ្មោះប្រភេទតាមភាសា (Clothes -> សម្លៀកបំពាក់)
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTrendingList(LanguageProvider langProvider) {
    final List<String> trendingImages = [
      'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f?auto=format&fit=crop&w=400&q=80', 
      'https://images.unsplash.com/photo-1539109136881-3be0616acf4b?auto=format&fit=crop&w=400&q=80', 
      'https://images.unsplash.com/photo-1529139574466-a303027c1d8b?auto=format&fit=crop&w=400&q=80', 
      'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=400&q=80', 
    ];

    return SizedBox(
      height: 220,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(), 
        itemCount: trendingImages.length, 
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {
              // បកប្រែអក្សរលោតនៅក្នុង SnackBar ពេលចុចលើទំនិញ
              final currentLang = langProvider.currentLocale;
              final alertMsg = currentLang == 'km' 
                  ? 'កំពុងបើកទំនិញពេញនិយមទី ${index + 1}...' 
                  : 'Opening Trending Item ${index + 1}...';

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(alertMsg),
                  duration: const Duration(seconds: 1),
                ),
              );
            },
            child: Container(
              width: 150,
              margin: const EdgeInsets.only(right: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                    child: Image.network(
                      trendingImages[index],
                      height: 120,
                      width: 150,
                      fit: BoxFit.cover, 
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.grey.shade200,
                          child: const Center(child: Icon(Icons.broken_image, color: Colors.grey)),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          langProvider.currentLocale == 'km'
                              ? "ទំនិញពេញនិយមទី ${index + 1}"
                              : "Trending Item ${index + 1}",
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          "\$29.99",
                          style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
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