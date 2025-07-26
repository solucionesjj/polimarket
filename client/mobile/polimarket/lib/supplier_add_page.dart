import 'package:flutter/material.dart';
import 'package:polimarket/Models/Supplier.dart';
import 'package:polimarket/services/api_service.dart';

class SupplierAddPage extends StatefulWidget {
  const SupplierAddPage({super.key});

  @override
  _SupplierAddPageState createState() => _SupplierAddPageState();
}

class _SupplierAddPageState extends State<SupplierAddPage> {
  final api = ApiService();
  final _formKey = GlobalKey<FormState>();
  String _name = '';

  bool _isLoading = false;

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    _formKey.currentState!.save();

    setState(() {
      _isLoading = true;
    });

    final supplier = Supplier(id: 0, name: _name);

    final response = await api.addSupplier(supplier);

    setState(() {
      _isLoading = false;
    });

    if (response) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Supplier added successfully!')));
      Navigator.pop(context, true);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to add supplier')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Add Supplier')),
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
              SizedBox(height: 24),
              _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : ElevatedButton(
                      onPressed: _submit,
                      child: Text('Add Supplier'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
