import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:provider/provider.dart';
import 'package:store/providers/products_provider.dart';
import 'package:store/providers/cart_provider.dart';
import 'package:smartstore2/design/colors.dart';
import 'package:smartstore2/pages/home.dart';

class BasketChecked extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ShoppingPageChecked(),
    );
  }
}

class ShoppingPageChecked extends StatefulWidget {
  @override
  _ShoppingPageCheckedState createState() => _ShoppingPageCheckedState();
}

class _ShoppingPageCheckedState extends State<ShoppingPageChecked> {
  @override
  void initState() {
    super.initState();
    // Загружаем продукты при инициализации
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<ProductsProvider>(context, listen: false).loadProducts();
    });
  }

  void _openScanner() async {
    final scannedBarcode = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => BarcodeScanPageChecked()),
    );

    if (scannedBarcode != null) {
      // TODO: Implement barcode scanning logic with API
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.account_circle_outlined,
              color: Colors.black, size: 40),
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Home()));
          },
        ),
        title: TextField(
          decoration: InputDecoration(
            hintText: "Поиск",
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_none, color: Colors.black, size: 40),
            onPressed: () {},
          ),
        ],
      ),
      body: Consumer<ProductsProvider>(
        builder: (context, productsProvider, child) {
          if (productsProvider.isLoading) {
            return Center(child: CircularProgressIndicator());
          }

          if (productsProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Ошибка: ${productsProvider.error}'),
                  ElevatedButton(
                    onPressed: () => productsProvider.loadProducts(),
                    child: Text('Попробовать снова'),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Banner section
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage("assets/images/banner.png"),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Icon(Icons.arrow_forward_ios, color: Colors.black54),
                  ),
                ),
              ),

              // Filter buttons
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    FilterButton(
                      icon: Icons.filter_alt,
                      text: "Фильтр",
                      onPressed: () {
                        // TODO: Implement filtering
                      },
                    ),
                    FilterButton(
                      icon: Icons.currency_ruble,
                      text: "Цена",
                      onPressed: () {
                        // TODO: Implement price sorting
                      },
                    ),
                    FilterButton(
                      icon: Icons.percent,
                      text: "Скидки",
                      onPressed: () {
                        // TODO: Implement discount filtering
                      },
                    ),
                  ],
                ),
              ),

              // Products list
              Expanded(
                child: ListView.builder(
                  itemCount: productsProvider.products.length,
                  itemBuilder: (context, index) {
                    final product = productsProvider.products[index];
                    return ProductCard(
                      product: product,
                      onAddToCart: () {
                        Provider.of<CartProvider>(context, listen: false)
                            .addToCart(product['id'], 1);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Товар добавлен в корзину')),
                        );
                      },
                    );
                  },
                ),
              ),

              // Scanner and age verification
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    InkWell(
                      onTap: _openScanner,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.camera_alt, color: Colors.black),
                          SizedBox(width: 8),
                          Text(
                            "Используйте камеру",
                            style: TextStyle(color: primaryColor, fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 8),
                    InkWell(
                      onTap: () {
                        print("Подтверждение возраста");
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.verified, color: Colors.green),
                          SizedBox(width: 8),
                          Text(
                            "Подтвердите ваш возраст",
                            style: TextStyle(color: Colors.green, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  final IconData icon;
  final String text;
  final VoidCallback onPressed;

  FilterButton({
    required this.icon,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.black),
      label: Text(text, style: TextStyle(color: Colors.black)),
      style: ElevatedButton.styleFrom(
        backgroundColor: secondaryColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
    );
  }
}

class ProductCard extends StatelessWidget {
  final Map<String, dynamic> product;
  final VoidCallback onAddToCart;

  ProductCard({
    required this.product,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: ListTile(
        leading: Image.network(
          product["imageUrl"] ?? "",
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.image_not_supported, size: 50);
          },
        ),
        title: Text(product["name"]),
        subtitle: Text("${product["price"]}₽"),
        trailing: IconButton(
          icon: Icon(Icons.add_shopping_cart),
          onPressed: onAddToCart,
        ),
      ),
    );
  }
}

class BarcodeScanPageChecked extends StatelessWidget {
  final Map<String, Map<String, dynamic>> barcodeToProduct = {
    '123456': {
      "name": "Новое молоко",
      "price": "80.00₽",
      "image": "assets/images/milk.png"
    },
    '789012': {
      "name": "Шоколад",
      "price": "99.99₽",
      "image": "assets/images/chocolate.png"
    },
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Сканер штрихкода')),
      body: MobileScanner(
        controller: MobileScannerController(),
        onDetect: (capture) {
          final barcode = capture.barcodes.first;
          final code = barcode.rawValue ?? '';
          final product = barcodeToProduct[code];

          if (product != null) {
            Navigator.pop(context, product);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Товар с таким штрихкодом не найден")),
            );
          }
        },
      ),
    );
  }
}
