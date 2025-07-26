import 'package:flutter/material.dart';
import 'package:polimarket/Models/Product.dart';
import 'package:polimarket/services/api_service.dart';

class ProductAddPage extends StatefulWidget {
  const ProductAddPage({super.key});

  @override
  _ProductAddPageState createState() => _ProductAddPageState();
}

class _ProductAddPageState extends State<ProductAddPage> {
  final api = ApiService();
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  String _description = '';
  int _stock = 0;


  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    final product = Product(
      id: 0, 
      name: _name,
      description: _description,
      stock: _stock,
      supplierId: 1
    );


 final response = await api.addProduct(product);




    setState(() {
      _isLoading = false;
    });

    if (response) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Product added successfully!')),
      );
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add product')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Product')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Name'),
                onSaved: (value) => _name = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                onSaved: (value) => _description = value ?? '',
                validator: (value) =>
                    value == null || value.isEmpty ? 'Enter a description' : null,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Stock'),
                keyboardType: TextInputType.number,
                onSaved: (value) => _stock = int.tryParse(value ?? '0') ?? 0,
                validator: (value) {
                  final price = double.tryParse(value ?? '');
                  if (price == null || price <= 0) {
                    return 'Enter a valid price';
                  }
                  return null;
                },
              ),
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text('Add Product'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}