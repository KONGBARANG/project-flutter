import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/product.dart';
import '../../services/api_services.dart';
import '../product_detail/product_detail_screen.dart';
import '../../providers/language_provider.dart'; 

class ProductListScreen extends StatefulWidget {
  final String? initialCategory;
  final String? initialSearch;

  const ProductListScreen({super.key, this.initialCategory, this.initialSearch});

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
  bool _initializedFilters = false;

  @override
  void initState() {
    super.initState();
    _loadProducts();
    _loadCategories();
  }

  void _loadProducts() {
    // ទាញយកទិន្នន័យពី API មកទុកក្នុង Future
    _productsFuture = ApiServices.getProducts().then((products) {
      _allProducts = products;
      
      // រៀបចំ Filter ដើមដំបូង (Initial Filters) តែម្តងគត់នៅពេលទាញទិន្នន័យបានជោគជ័យ
      if (!_initializedFilters) {
        _initializedFilters = true;
        if (widget.initialCategory != null && widget.initialCategory!.isNotEmpty) {
          _selectedCategory = widget.initialCategory!;
        }
        if (widget.initialSearch != null && widget.initialSearch!.isNotEmpty) {
          _searchC.text = widget.initialSearch!;
        }
      }

      // អនុវត្ត Filter ភ្លាមៗបន្ទាប់ពីបានទិន្នន័យ
      _applyFilterWithoutState();
      return products;
    });
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

  // បំបែកមុខងារ Filter មួយទៀតដែលមិនប្រើ setState ដើម្បីជៀសវាង Infinite Loop ក្នុង Future
  void _applyFilterWithoutState() {
    List<Product> filtered = _allProducts;
    
    // Filter តាមប្រភេទ (Category)
    if (_selectedCategory != 'All') {
      filtered = filtered.where((p) => p.category == _selectedCategory).toList();
    }

    // Filter តាមការស្វែងរក (Search)
    if (_searchC.text.isNotEmpty) {
      filtered = filtered.where((p) => p.title.toLowerCase().contains(_searchC.text.toLowerCase())).toList();
    }

    _filteredProducts = filtered;
  }

  // មុខងារ Filter សម្រាប់ហៅប្រើប្រាស់នៅលើ UI (នៅពេលអ្នកប្រើប្រាស់ចុចផ្លាស់ប្តូរដោយផ្ទាល់)
  void _applyFilter() {
    setState(() {
      _applyFilterWithoutState();
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
        return category; 
    }
  }

  @override
  void dispose() {
    _searchC.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final langProvider = Provider.of<LanguageProvider>(context);

    return Scaffold(
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

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: TextField(
                  controller: _searchC,
                  onChanged: (_) => _applyFilter(),
                  decoration: InputDecoration(
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