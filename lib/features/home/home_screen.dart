import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. Promotional Hero Banner
            _buildPromoBanner(),
            const SizedBox(height: 24),
            
            // 2. Quick Categories
            const Text(
              "Top Categories",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            _buildCategoryRow(),
            const SizedBox(height: 24),
            
            // 3. Trending Products (Horizontal Scroll)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Trending Now",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () {
                    // TODO: Navigate to the Shop page
                  },
                  child: const Text("See All"),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildTrendingList(),
          ],
        ),
      ),
    );
  }

  // --- Widget Builders ---

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      height: 200, // <-- INCREASED THIS FROM 160 TO 200
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
            const Text(
              "Summer Sale",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                shadows: [Shadow(color: Colors.black45, blurRadius: 4)],
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Up to 50% Off\non selected items",
              style: TextStyle(
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
              child: const Text("Shop Now"),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryRow() {
    // List of categories matching your shop page
    final categories = [
      {'icon': Icons.checkroom, 'name': 'Clothes'},
      {'icon': Icons.watch, 'name': 'Jewelry'},
      {'icon': Icons.devices, 'name': 'Tech'},
      {'icon': Icons.backpack, 'name': 'Bags'},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: categories.map((cat) {
        return Column(
          children: [
            CircleAvatar(
              radius: 30,
              backgroundColor: Colors.grey.shade200,
              child: Icon(cat['icon'] as IconData, color: Colors.deepPurple, size: 28),
            ),
            const SizedBox(height: 8),
            Text(cat['name'] as String, style: const TextStyle(fontWeight: FontWeight.w500)),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildTrendingList() {
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
        physics: const BouncingScrollPhysics(), // <-- This makes the scrolling feel bouncy and smooth
        itemCount: trendingImages.length, 
        itemBuilder: (context, index) {
          
          // <-- GESTURE DETECTOR ADDED HERE -->
          return GestureDetector(
            onTap: () {
              // This is what happens when the user clicks the item!
              // For now, we will show a little pop-up message at the bottom of the screen.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Opening Trending Item ${index + 1}...'),
                  duration: const Duration(seconds: 1),
                ),
              );
              
              // Later, your team will change this to navigate to a Product Detail Page:
              // Navigator.push(context, MaterialPageRoute(builder: (context) => ProductDetailPage()));
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
                          "Trending Item ${index + 1}",
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