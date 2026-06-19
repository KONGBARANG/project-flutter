import 'package:flutter/material.dart';

class LanguageProvider extends ChangeNotifier {
  // 'en' សម្រាប់ English, 'km' សម្រាប់ ភាសាខ្មែរ
  String _currentLocale = 'en'; 

  String get currentLocale => _currentLocale;

  // អនុគមន៍សម្រាប់ប្ដូរភាសា
  void changeLanguage(String localeCode) {
    _currentLocale = localeCode;
    notifyListeners(); // ផ្ញើសញ្ញាទៅប្រាប់គ្រប់ទំព័រឱ្យប្ដូរអក្សរភ្លាមៗ
  }

  // កម្រងពាក្យ (Dictionary) ដែលបានបន្ថែមពាក្យថ្មីៗសម្រាប់គ្រប់ទំព័ររួចរាល់
  final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      // === ផ្នែកម៉ឺនុយ និងការកំណត់ (Menu & Settings) ===
      'settings': 'Settings',
      'preferences': 'Preferences',
      'push_notif': 'Push Notifications',
      'receive_updates': 'Receive updates on orders and sales',
      'dark_mode': 'Dark Mode',
      'change_theme': 'Change app theme',
      'language': 'Language',
      'support_about': 'Support & About',
      'help_center': 'Help Center',
      'privacy_policy': 'Privacy Policy',
      'terms': 'Terms of Service',
      'home': 'Home',
      'notif': 'Notifications',
      'profile': 'Profile',
      'api': 'API Test',
      'shop': 'Shop',
      'cart': 'Cart',
      'logout': 'Logout',

      // === ផ្នែកទំព័រដើម (HomeScreen) ===
      'summer_sale': 'Summer Sale',
      'up_to_50': 'Up to 50% Off\non selected items',
      'shop_now': 'Shop Now',
      'top_categories': 'Top Categories',
      'trending_now': 'Trending Now',
      'see_all': 'See All',
      'cat_clothes': 'Clothes',
      'cat_jewelry': 'Jewelry',
      'cat_tech': 'Tech',
      'cat_bags': 'Bags',

      // === ផ្នែកទំព័រផលិតផល (ProductListScreen) ===
      'products_title': 'Products',
      'search_hint': 'Search products',
      'cat_all': 'All',
      'cat_electronics': 'electronics',
      'cat_jewelery_filter': 'jewelery',
      'cat_men_clothing': "men's clothing",
      'cat_women_clothing': "women's clothing",
      // Auth related
      'login': 'Login',
      'register': 'Register',
      'please_fill_email_pass': 'Please fill in email and password',
      'logged_in_as': 'Logged in as',
      'name_required': 'Name is required',
      'email_required': 'Email is required',
      'invalid_email': 'Invalid email',
      'password_min_6': 'Password must be at least 6 characters',
      'registered': 'Registered',
        'add_to_cart': 'Add to Cart',
        'added_to_cart': 'added to cart',
          'proceed_to_checkout': 'Proceed to Checkout',
            'place_order': 'Place Order',
            'please_fill_all_fields': 'Please fill all fields',
            'order_placed_for': 'Order placed for',
    },
    'km': {
      // === ផ្នែកម៉ឺនុយ និងការកំណត់ (Menu & Settings) ===
      'settings': 'ការកំណត់',
      'preferences': 'ចំណង់ចំណូលចិត្ត',
      'push_notif': 'ការជូនដំណឹងផ្ដល់ដំណឹង',
      'receive_updates': 'ទទួលព័ត៌មានថ្មីៗអំពីការបញ្ជាទិញ និងការលក់',
      'dark_mode': 'មុខងារងងឹត',
      'change_theme': 'ផ្លាស់ប្តូរពណ៌ផ្ទៃកម្មវិធី',
      'language': 'ភាសា',
      'support_about': 'ជំនួយ និងព័ត៌មានកម្មវិធី',
      'help_center': 'មជ្ឈមណ្ឌលជំនួយ',
      'privacy_policy': 'គោលការណ៍ឯកជនភាព',
      'terms': 'លក្ខខណ្ឌប្រើប្រាស់',
      'home': 'ទំព័រដើម',
      'notif': 'ការជូនដំណឹង',
      'profile': 'ប្រវត្តិរូប',
      'api': 'តេស្ត API',
      'shop': 'ហាងទំនិញ',
      'cart': 'កន្ត្រកទំនិញ',
      'logout': 'ចាកចេញ',

      // === ផ្នែកទំព័រដើម (HomeScreen) ===
      'summer_sale': 'ការលក់បញ្ចុះតម្លៃរដូវក្ដៅ',
      'up_to_50': 'បញ្ចុះតម្លៃរហូតដល់ ៥០%\nលើមុខទំនិញដែលបានជ្រើសរើស',
      'shop_now': 'ទិញឥឡូវនេះ',
      'top_categories': 'ប្រភេទទំនិញពេញនិយម',
      'trending_now': 'ទំនិញកំពុងពេញនិយម',
      'see_all': 'មើលទាំងអស់',
      'cat_clothes': 'សម្លៀកបំពាក់',
      'cat_jewelry': 'គ្រឿងអលង្ការ',
      'cat_tech': 'បច្ចេកវិទ្យា',
      'cat_bags': 'កាបូប',

      // === ផ្នែកទំព័រផលិតផល (ProductListScreen) ===
      'products_title': 'ផលិតផល',
      'search_hint': 'ស្វែងរកផលិតផល',
      'cat_all': 'ទាំងអស់',
      'cat_electronics': 'គ្រឿងអេឡិចត្រូនិច',
      'cat_jewelery_filter': 'គ្រឿងអលង្ការ',
      'cat_men_clothing': 'សម្លៀកបំពាក់បុរស',
      'cat_women_clothing': 'សម្លៀកបំពាក់នារី',
      // Auth related
      'login': 'ចូលប្រព័ន្ធ',
      'register': 'ចុះឈ្មោះ',
      'please_fill_email_pass': 'សូមបំពេញអ៊ីមែល និងពាក្យសម្ងាត់',
      'logged_in_as': 'បានចូលជា',
      'name_required': 'ត្រូវការឈ្មោះ',
      'email_required': 'ត្រូវការអ៊ីមែល',
      'invalid_email': 'អ៊ីមែលមិនត្រឹមត្រូវ',
      'password_min_6': 'ពាក្យសម្ងាត់ត្រូវមានយ៉ាងហោចណាស់ 6 តួអក្សរ',
      'registered': 'បានចុះឈ្មោះ',
      'add_to_cart': 'ថែមចូលកន្ត្រក',
      'added_to_cart': 'បានបន្ថែមចូលកន្ត្រក',
      'proceed_to_checkout': 'ទៅកាន់ការទូទាត់',
      'place_order': 'ដាក់ការបញ្ជាទិញ',
      'please_fill_all_fields': 'សូមបំពេញទាំងអស់',
      'order_placed_for': 'ការបញ្ជាទិញបានដាក់សម្រាប់',
    }
  };

  // អនុគមន៍សម្រាប់ទាញយកពាក្យទៅតាមភាសាបច្ចុប្បន្ន
  String translate(String key) {
    return _localizedValues[_currentLocale]?[key] ?? key;
  }
}