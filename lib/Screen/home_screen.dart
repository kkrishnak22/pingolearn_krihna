import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Api Services/product.dart';
import '../../Api Services/remote_config_service.dart';
import '../../Models/product_model.dart';
import '../../Provider/auth_provider.dart';
import '../Widget/card.dart';
import 'login.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final remoteConfigService = Provider.of<RemoteConfigService>(context);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text(
          "e-Shop",
          style: TextStyle(
            color: Color(0xFFf5f9fd),
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700, // text color here
          ),
        ),
        backgroundColor: const Color(0xFF0c54be),
        actions: [
          IconButton(
            icon: Icon(Icons.logout, color: Colors.white),
            onPressed: () async {
              await authProvider.logout();
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => LoginScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        color: const Color(0xFFf5f9fd),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Remote Config > showDiscountedPrice: ${remoteConfigService.showDiscountedPrice}",
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: FutureBuilder<List<Product>>(
                  future: ApiService.fetchProducts(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No products found'));
                    } else {
                      final products = snapshot.data!;
                      final showDiscountedPrice = remoteConfigService.showDiscountedPrice;
                      return GridView.builder(
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns
                          crossAxisSpacing: 8.0, // Space between columns
                          mainAxisSpacing: 8.0, // Space between rows
                          childAspectRatio: 0.7, // Aspect ratio of each card
                        ),
                        itemCount: products.length,
                        itemBuilder: (context, index) {
                          final product = products[index];
                          final price = showDiscountedPrice
                              ? product.price - (product.price * (product.discountPercentage / 100))
                              : product.price;


                          final padding = (index == 0 || index == 1)
                              ? const EdgeInsets.only(top: 16.0)
                              : EdgeInsets.zero;

                          return Padding(
                            padding: padding,
                            child: ProductCard(
                              imageUrl: product.thumbnail,
                              title: product.title,
                              price: price,
                              discountPercentage: product.discountPercentage,
                              showDiscountedPrice: showDiscountedPrice,
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
