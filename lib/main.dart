import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/orders/controllers/cart_controller.dart';
import 'features/orders/models/product_model.dart';
import 'features/orders/presentation/cart_flow_screen.dart';
import 'features/orders/presentation/orders_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => CartController(),
      child: const MyApp(),
    ),
  );
}

String getProductImage(String name) {
  final normalizedName = name.toLowerCase();

  if (normalizedName.contains('romper')) {
    return 'https://alayajunior.com/cdn/shop/files/Carters-Pack-Of-3-Baby-Rompers-Bear-And-Stars-Beige.webp?v=1768772145&width=1445';
  }
  if (normalizedName.contains('teddy') || normalizedName.contains('bear')) {
    return 'https://toyshutch.pk/cdn/shop/files/soft-stuffed-teddy-bear-with-cap-101905.webp?v=1778759066';
  }
  if (normalizedName.contains('bib')) {
    return 'https://snugnplay.com/cdn/shop/files/all.jpg?v=1738902803';
  }
  if (normalizedName.contains('stack') || normalizedName.contains('toy')) {
    return 'https://www.jaqueslondon.co.uk/cdn/shop/products/SHAPE-_1.jpg?v=1666870911&width=500';
  }
  if (normalizedName.contains('shampoo')) {
    return 'https://images.unsplash.com/photo-1608571424352-9261f4f0b8d8?auto=format&fit=crop&w=500&q=80';
  }
  if (normalizedName.contains('body wash') || normalizedName.contains('wash')) {
    return 'https://images.unsplash.com/photo-1515377905703-c4788e51af15?auto=format&fit=crop&w=500&q=80';
  }
  if (normalizedName.contains('diaper') || normalizedName.contains('diapers')) {
    return 'https://images.unsplash.com/photo-1512436991641-6745cdb1723f?auto=format&fit=crop&w=500&q=80';
  }
  if (normalizedName.contains('bottle') || normalizedName.contains('lotion') || normalizedName.contains('blanket')) {
    return 'https://images.unsplash.com/photo-1516627145497-ae6968895b74?auto=format&fit=crop&w=500&q=80';
  }

  return 'https://images.unsplash.com/photo-1519345182560-3f2917c472ef?auto=format&fit=crop&w=500&q=80';
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Poppins',
        scaffoldBackgroundColor: const Color(0xFFFDFBF7),
      ),
      home: const BabyHubHomeScreen(),
    );
  }
}

class BabyHubHomeScreen extends StatefulWidget {
  const BabyHubHomeScreen({super.key});

  @override
  State<BabyHubHomeScreen> createState() => _BabyHubHomeScreenState();
}

class _BabyHubHomeScreenState extends State<BabyHubHomeScreen> {
  final List<Map<String, dynamic>> categories = [
    {'name': 'Clothes', 'icon': Icons.checkroom, 'color': Color(0xFFFFEAD2)},
    {'name': 'Accessories', 'icon': Icons.child_care, 'color': Color(0xFFE8E2FA)},
    {'name': 'Toys', 'icon': Icons.smart_toy_outlined, 'color': Color(0xFFD6E6F2)},
    {'name': 'Feeding', 'icon': Icons.child_friendly, 'color': Color(0xFFFDE2E4)},
    {'name': 'Baby Gear', 'icon': Icons.accessible_forward, 'color': Color(0xFFE2D4F0)},
    {'name': 'More', 'icon': Icons.grid_view, 'color': Color(0xFFEAD9CE)},
  ];

  final List<Map<String, dynamic>> bannerOffers = [
    {'title': 'New Arrivals', 'desc': 'Check out our\nlatest collection', 'action': 'Explore', 'color': Color(0xFFF0E6FF)},
    {'title': 'Special Offers', 'desc': 'Up to 30% off on\nselected items', 'action': 'Shop Now', 'color': Color(0xFFFFF1E6)},
    {'title': 'Free Delivery', 'desc': 'On orders above\nPKR 3,000', 'action': 'Learn More', 'color': Color(0xFFE3F2FD)},
  ];

  final List<Map<String, dynamic>> popularPicks = [
    {'name': 'Cotton Romper Set', 'price': 'PKR 1,650', 'rating': '4.8', 'reviews': '120'},
    {'name': 'Soft Teddy Bear', 'price': 'PKR 1,250', 'rating': '4.9', 'reviews': '85'},
    {'name': 'Silicone Bib', 'price': 'PKR 650', 'rating': '4.7', 'reviews': '60'},
    {'name': 'Stacking Toy', 'price': 'PKR 950', 'rating': '4.8', 'reviews': '70'},
    {'name': 'Nexon Shampoo', 'price': 'PKR 1,100', 'rating': '4.6', 'reviews': '52'},
    {'name': 'Nexon Body Wash', 'price': 'PKR 1,200', 'rating': '4.7', 'reviews': '48'},
    {'name': 'Comfy Diapers', 'price': 'PKR 2,300', 'rating': '4.9', 'reviews': '96'},
    {'name': 'Baby Bottle Set', 'price': 'PKR 1,480', 'rating': '4.8', 'reviews': '74'},
    {'name': 'Soft Baby Blanket', 'price': 'PKR 1,780', 'rating': '4.7', 'reviews': '63'},
    {'name': 'Baby Lotion', 'price': 'PKR 890', 'rating': '4.6', 'reviews': '41'},
  ];

  int _bottomNavIndex = 0;

  String _getProductImage(String name) => getProductImage(name);

  @override
  Widget build(BuildContext context) {
    List<Widget> screens = [
      _buildHomeScreen(),
      const CategoriesScreen(),
      const CartScreen(),
      const OrdersScreen(),
      const ProfileScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black87),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
        title: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.favorite, color: Colors.orange, size: 20),
                const SizedBox(width: 4),
                Text(
                  'BabyHub',
                  style: TextStyle(
                    color: Colors.indigo[900],
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
            const Text(
              'Everything for your little one 💜',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none_outlined, color: Colors.black87),
                onPressed: () {},
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Colors.orange),
                  child: const Text('3', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
              )
            ],
          )
        ],
      ),
      body: screens[_bottomNavIndex],
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.indigo[900]),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.account_circle, size: 50, color: Colors.white),
                  const SizedBox(height: 12),
                  const Text(
                    'Welcome to BabyHub',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'Everything for your baby',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home, color: Colors.indigo),
              title: const Text('Home'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.dashboard, color: Colors.indigo),
              title: const Text('Categories'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.favorite, color: Colors.indigo),
              title: const Text('Wishlist'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.shopping_cart, color: Colors.indigo),
              title: const Text('My Cart'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.local_mall, color: Colors.indigo),
              title: const Text('My Orders'),
              onTap: () => Navigator.pop(context),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person, color: Colors.indigo),
              title: const Text('My Profile'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.location_on, color: Colors.indigo),
              title: const Text('Addresses'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.indigo),
              title: const Text('Settings'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.help, color: Colors.indigo),
              title: const Text('Help & Support'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF5C8A),
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home_filled), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.dashboard_outlined), label: 'Categories'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart_outlined), label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.local_mall_outlined), label: 'Orders'),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: 'Profile'),
        ],
      ),
    );
  }

  Widget _buildHomeScreen() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: const TextField(
                      decoration: InputDecoration(
                        hintText: 'Search for products, brands and more...',
                        hintStyle: TextStyle(color: Colors.grey, fontSize: 13),
                        prefixIcon: Icon(Icons.search, color: Colors.grey),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(vertical: 12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                GestureDetector(
                  onTap: () => _openCamera(context),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.indigo[900],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(Icons.qr_code_scanner, color: Colors.white),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFEAE2FA),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Soft. Safe. Stylish.', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600)),
                  const SizedBox(height: 6),
                  Text(
                    'Everything your\nbaby needs',
                    style: TextStyle(color: Colors.indigo[900], fontSize: 24, fontWeight: FontWeight.bold, height: 1.2),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Shop Now', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                        SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                      ],
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: categories.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 14.0),
                    child: Column(
                      children: [
                        Container(
                          height: 60,
                          width: 60,
                          decoration: BoxDecoration(
                            color: categories[index]['color'],
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Icon(categories[index]['icon'], color: Colors.black, size: 28),
                        ),
                        const SizedBox(height: 6),
                        Text(categories[index]['name'], style: const TextStyle(fontSize: 12, color: Colors.black87)),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 130,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: bannerOffers.length,
                itemBuilder: (context, index) {
                  final item = bannerOffers[index];
                  return Container(
                    width: 150,
                    margin: const EdgeInsets.only(right: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: item['color'],
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item['title'], style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.indigo)),
                            const SizedBox(height: 4),
                            Text(item['desc'], style: const TextStyle(fontSize: 11, color: Colors.black54, height: 1.2)),
                          ],
                        ),
                        Row(
                          children: [
                            Text(item['action'], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.indigo)),
                            const Icon(Icons.arrow_right_alt, size: 14, color: Colors.indigo),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Popular Picks',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.indigo[900]),
                ),
                TextButton(
                  onPressed: () => _navigateToAllProducts(context),
                  child: const Row(
                    children: [
                      Text('View all', style: TextStyle(color: Colors.indigo, fontWeight: FontWeight.w600)),
                      SizedBox(width: 4),
                      Icon(Icons.arrow_forward_rounded, size: 16, color: Colors.indigo),
                    ],
                  ),
                )
              ],
            ),
            SizedBox(
              height: 250,
              child: ListView.builder(
                padding: const EdgeInsets.only(bottom: 4),
                scrollDirection: Axis.horizontal,
                itemCount: popularPicks.length,
                itemBuilder: (context, index) {
                  final product = popularPicks[index];
                  return Container(
                    width: 138,
                    margin: const EdgeInsets.only(right: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Stack(
                          children: [
                            ClipRRect(
                              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
                              child: Image.network(
                                _getProductImage(product['name']),
                                height: 112,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    height: 132,
                                    color: Colors.grey.shade50,
                                    child: const Center(child: Icon(Icons.image, color: Colors.grey, size: 40)),
                                  );
                                },
                              ),
                            ),
                            Positioned(
                              left: 8,
                              top: 8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.orange.withValues(alpha: 0.92),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Text(
                                  'Hot',
                                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                                ),
                              ),
                            ),
                            const Positioned(
                              right: 8,
                              top: 8,
                              child: CircleAvatar(
                                radius: 14,
                                backgroundColor: Colors.white,
                                child: Icon(Icons.favorite_border, color: Colors.orange, size: 16),
                              ),
                            )
                          ],
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  product['name'],
                                  style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF2D1E5C)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  product['price'],
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    const Icon(Icons.star, color: Colors.amber, size: 12),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${product['rating']} (${product['reviews']})',
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.indigo.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Add',
                                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Colors.indigo),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
              child: Wrap(
                alignment: WrapAlignment.center,
                spacing: 12,
                runSpacing: 12,
                children: [
                  SizedBox(width: 100, child: _buildFooterInfo(Icons.verified_user_outlined, 'Safe & Trusted')),
                  SizedBox(width: 100, child: _buildFooterInfo(Icons.local_shipping_outlined, 'Fast Delivery')),
                  SizedBox(width: 100, child: _buildFooterInfo(Icons.assignment_return_outlined, 'Easy Returns')),
                ],
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }

  void _navigateToAllProducts(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AllProductsScreen(products: popularPicks),
      ),
    );
  }

  void _openCamera(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Camera Access'),
          content: const Text('Opening camera for QR code scanning...'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFooterInfo(IconData icon, String text) {
    return Column(
      children: [
        Icon(icon, color: Colors.indigo[900], size: 24),
        const SizedBox(height: 4),
        Text(text, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.black87)),
      ],
    );
  }
}

class ProductCard extends StatefulWidget {
  const ProductCard({super.key, required this.product});

  final Map<String, dynamic> product;

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        height: 220,
        transform: Matrix4.identity()
          ..translateByDouble(0.0, _isHovered ? -2 : 0, 0.0, 0.0)
          ..scaleByDouble(1.0, _isHovered ? 1.01 : 1.0, 1.0, 1.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: _isHovered ? Colors.indigo.shade100 : Colors.grey.shade100),
          boxShadow: _isHovered
              ? [
                  BoxShadow(
                    color: Colors.indigo.withValues(alpha: 0.12),
                    blurRadius: 8,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(18),
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: () {
              final product = ProductModel(
                id: widget.product['name'].toString().toLowerCase().replaceAll(' ', '_'),
                name: widget.product['name'],
                variant: 'Baby essential',
                quantity: 1,
                price: double.tryParse(widget.product['price'].toString().replaceAll(RegExp(r'[^0-9]'), '')) ?? 1000,
                imageUrl: getProductImage(widget.product['name']),
              );
              context.read<CartController>().addToCart(product);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${widget.product['name']} added to cart'),
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: const Color(0xFFFF5C8A),
                ),
              );
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(18)),
                  child: Container(
                    height: 158,
                    color: Colors.grey.shade50,
                    padding: const EdgeInsets.all(8),
                    child: Image.network(
                      getProductImage(widget.product['name']),
                      width: double.infinity,
                      height: 142,
                      fit: BoxFit.contain,
                      alignment: Alignment.center,
                      errorBuilder: (context, error, stackTrace) {
                        return const Center(child: Icon(Icons.image, color: Colors.grey, size: 32));
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.product['name'],
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: Color(0xFF2D1E5C)),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.product['price'],
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange),
                        ),
                        const Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 12),
                                const SizedBox(width: 4),
                                Text('${widget.product['rating']} (${widget.product['reviews']})', style: const TextStyle(fontSize: 10.5, color: Colors.grey)),
                              ],
                            ),
                            Container(
                              padding: const EdgeInsets.all(5),
                              decoration: BoxDecoration(color: Colors.indigo.withValues(alpha: 0.1), shape: BoxShape.circle),
                              child: const Icon(Icons.add_shopping_cart, size: 14, color: Colors.indigo),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key, required this.products});

  final List<Map<String, dynamic>> products;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Popular Picks'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.indigo[900], fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          final childAspectRatio = constraints.maxWidth > 600 ? 0.82 : 0.78;

          return GridView.builder(
            padding: const EdgeInsets.all(12),
            physics: const BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: childAspectRatio,
            ),
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return ProductCard(product: product);
            },
          );
        },
      ),
    );
  }
}

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.indigo[900], fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            children: [
              _buildCategoryCard('Clothes', Icons.checkroom, Colors.orange),
              _buildCategoryCard('Accessories', Icons.child_care, Colors.pink),
              _buildCategoryCard('Toys', Icons.smart_toy_outlined, Colors.blue),
              _buildCategoryCard('Feeding', Icons.child_friendly, Colors.green),
              _buildCategoryCard('Baby Gear', Icons.accessible_forward, Colors.purple),
              _buildCategoryCard('More', Icons.grid_view, Colors.amber),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryCard(String name, IconData icon, Color color) {
    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 40, color: color),
          const SizedBox(height: 12),
          Text(name, textAlign: TextAlign.center, style: TextStyle(fontWeight: FontWeight.w600, color: color, fontSize: 14)),
        ],
      ),
    );
  }
}

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CartFlowScreen(
      onContinueShopping: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const BabyHubHomeScreen()),
          (route) => false,
        );
      },
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        titleTextStyle: TextStyle(color: Colors.indigo[900], fontSize: 20, fontWeight: FontWeight.bold),
        iconTheme: const IconThemeData(color: Colors.black87),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(color: Colors.indigo[50], borderRadius: BorderRadius.circular(16)),
                child: Column(
                  children: [
                    Container(width: 80, height: 80, decoration: BoxDecoration(color: Colors.indigo[900], shape: BoxShape.circle), child: const Icon(Icons.person, size: 40, color: Colors.white)),
                    const SizedBox(height: 12),
                    const Text('User Name', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.black87)),
                    const Text('user@example.com', style: TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              _buildProfileOption(Icons.location_on, 'Addresses'),
              _buildProfileOption(Icons.payment, 'Payment Methods'),
              _buildProfileOption(Icons.notifications, 'Notifications'),
              _buildProfileOption(Icons.privacy_tip, 'Privacy Settings'),
              _buildProfileOption(Icons.help, 'Help & Support'),
              _buildProfileOption(Icons.logout, 'Logout', isLogout: true),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, {bool isLogout = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
      child: ListTile(
        leading: Icon(icon, color: isLogout ? Colors.red : Colors.indigo[900]),
        title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isLogout ? Colors.red : Colors.black87)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
        onTap: () {},
      ),
    );
  }
}
