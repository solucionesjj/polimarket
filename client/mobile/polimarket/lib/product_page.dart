import 'package:flutter/material.dart';
import 'package:polimarket/product_add_page.dart';
import 'services/api_service.dart';

class ProductPage extends StatefulWidget {
  const ProductPage({super.key});

  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  final api = ApiService();
  late Future<List<dynamic>> _productsFuture;

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() {
    _productsFuture = api.getProducts();
  }

  void _refreshProducts() {
    setState(() {
      _loadProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Productos...'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshProducts,
            tooltip: 'Refresh products',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ProductAddPage()),
          );
          
          // Refresh the list if a product was added
          if (result == true) {
            _refreshProducts();
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add product',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshProducts();
          // Wait for the new future to complete
          await _productsFuture;
        },
        child: FutureBuilder<List<dynamic>>(
          future: _productsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(child: CircularProgressIndicator());

            if (snapshot.hasError)
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Error: ${snapshot.error}'),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _refreshProducts,
                      child: Text('Retry'),
                    ),
                  ],
                ),
              );

            final items = snapshot.data!;
            
            if (items.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.inventory, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No products found'),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _refreshProducts,
                      child: Text('Refresh'),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Nombre:"),
                            Flexible(
                              child: Text(
                                items[index].name.toString(),
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Descripción:"),
                            Flexible(
                              child: Text(
                                items[index].description.toString(),
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Stock:"),
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: _getStockColor(items[index].stock),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                items[index].stock.toString(),
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Color _getStockColor(dynamic stock) {
    final stockValue = int.tryParse(stock.toString()) ?? 0;
    
    if (stockValue == 0) {
      return Colors.red; // Out of stock
    } else if (stockValue < 10) {
      return Colors.orange; // Low stock
    } else {
      return Colors.green; // Good stock
    }
  }
}