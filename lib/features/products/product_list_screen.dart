import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../services/api_services.dart';
import '../product_detail/product_detail_screen.dart';
import '../../providers/language_provider.dart'; // ១. Import LanguageProvider ចូលមក

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  State<ProductListScreen> createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productsFuture;
  List<Product> _allProducts = [];
  List<Product> _filteredProducts = [];
  final _searchC = TextEditingController();
  String _selectedCategory = 'All';
  List<String> _categories = ['All'];

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
  }

  void _loadProducts() {
    _productsFuture = ApiServices.getProducts();
  }

  void _loadCategories() async {
    try {
      final cats = await ApiServices.getCategories();
      setState(() {
        _categories = ['All', ...cats];
      });
    } catch (e) {
      debugPrint('Error loading categories: $e');
    }
  }

  void _applyFilter() {
    List<Product> filtered = _allProducts;
    
    // Filter by category
    if (_selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    // Filter by search
    if (_searchC.text.isNotEmpty) {
      filtered = filtered.where((p) => p.title.toLowerCase().contains(_searchC.text.toLowerCase())).toList();
    }

    setState(() {
      _filteredProducts = filtered;
    });
  }

  // អនុគមន៍ជំនួយសម្រាប់បកប្រែឈ្មោះ Category ដែលបានមកពី API
  String _getTranslatedCategory(String category, LanguageProvider langProvider) {
    switch (category) {
      case 'All':
        return langProvider.translate('cat_all');
      case 'electronics':
        return langProvider.translate('cat_electronics');
      case 'jewelery':
        return langProvider.translate('cat_jewelery_filter');
      case "men's clothing":
        return langProvider.translate('cat_men_clothing');
      case "women's clothing":
        return langProvider.translate('cat_women_clothing');
      default:
        return category; // បើអត់មានក្នុងសៀវភៅពាក្យ ឱ្យបង្ហាញតម្លៃដើមពី API
    }
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // ២. ហៅប្រើ LanguageProvider នៅក្នុងទំព័រនេះ
    final langProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
      // ៣. ប្ដូរចំណងជើង App Bar ទៅជាភាសាតាមការកំណត់ (Products -> ផលិតផល)
      appBar: AppBar(title: Text(langProvider.translate('products_title'))),
      body: FutureBuilder<List<Product>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          _allProducts = snapshot.data ?? [];
          if (_filteredProducts.isEmpty && _allProducts.isNotEmpty) {
            _filteredProducts = _allProducts;
          }

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchC,
                  onChanged: (_) => _applyFilter(),
                  decoration: InputDecoration(
                    // ៤. ប្ដូរអក្សរ Hint ក្នុងប្រឡោះស្វែងរក (Search products -> ស្វែងរកផលិតផល)
                    labelText: langProvider.translate('search_hint'),
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              ),
              
              // Category filter
              SizedBox(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  itemBuilder: (context, index) {
                    final cat = _categories[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: FilterChip(
                        // ៥. ហៅអនុគមន៍បកប្រែឈ្មោះប្រភេទទំនិញពី API ដើម្បីបង្ហាញជាភាសាខ្មែរ/អង់គ្លេស
                        label: Text(_getTranslatedCategory(cat, langProvider)),
                        selected: _selectedCategory == cat,
                        onSelected: (selected) {
                          setState(() {
                            _selectedCategory = selected ? cat : 'All';
                          });
                          _applyFilter();
                        },
                      ),
                    );
                  },
                ),
              ),
              
              // Product list
              Expanded(
                child: _filteredProducts.isEmpty
                    ? const Center(child: Text('No products found'))
                    : GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.75,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: _filteredProducts.length,
                        itemBuilder: (context, index) {
                          final product = _filteredProducts[index];
                          return ProductCard(product: product);
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => ProductDetailScreen(product: product)),
        );
      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                color: Colors.grey[200],
                width: double.infinity,
                child: Image.network(
                  product.image, 
                  fit: BoxFit.cover, 
                  errorBuilder: (_, _, _) => const Icon(Icons.image),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.title, 
                    maxLines: 2, 
                    overflow: TextOverflow.ellipsis, 
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\$${product.price.toStringAsFixed(2)}', 
                        style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, size: 14, color: Colors.amber),
                          Text('${product.rating}', style: const TextStyle(fontSize: 12)),
                        ],
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
  }
}