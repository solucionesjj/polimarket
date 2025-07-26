import 'package:flutter/material.dart';
import 'package:polimarket/supplier_add_page.dart';
import 'services/api_service.dart';

class SupplierPage extends StatefulWidget {
  const SupplierPage({super.key});

  @override
  State<SupplierPage> createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  final api = ApiService();
  late Future<List<dynamic>> _suppliersFuture;

  @override
  void initState() {
    super.initState();
    _loadSuppliers();
  }

  void _loadSuppliers() {
    _suppliersFuture = api.getSuppliers();
  }

  void _refreshSuppliers() {
    setState(() {
      _loadSuppliers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Proveedores...'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: _refreshSuppliers,
            tooltip: 'Refresh suppliers',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SupplierAddPage()),
          );
          
          // Refresh the list if a supplier was added
          if (result == true) {
            _refreshSuppliers();
          }
        },
        child: Icon(Icons.add),
        tooltip: 'Add supplier',
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _refreshSuppliers();
          // Wait for the new future to complete
          await _suppliersFuture;
        },
        child: FutureBuilder<List<dynamic>>(
          future: _suppliersFuture,
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
                      onPressed: _refreshSuppliers,
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
                    Icon(Icons.inbox, size: 64, color: Colors.grey),
                    SizedBox(height: 16),
                    Text('No suppliers found'),
                    SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: _refreshSuppliers,
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
                            Text("Id:"),
                            Text(
                              items[index].id.toString(),
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Name:"),
                            Flexible(
                              child: Text(
                                items[index].name.toString(),
                                style: TextStyle(fontSize: 16),
                                overflow: TextOverflow.ellipsis,
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
}