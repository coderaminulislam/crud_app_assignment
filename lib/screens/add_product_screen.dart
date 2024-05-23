import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({super.key});

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _productCodeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _qtyTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  bool _addProductInProgress = false;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add New Product'),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _globalKey,
              child: Column(
                children: [
                  TextFormField(
                    controller: _nameTEController,
                    decoration:
                        const InputDecoration(labelText: 'Product Name'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write Product Name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _productCodeTEController,
                    keyboardType: TextInputType.number,
                    decoration:
                        const InputDecoration(labelText: 'Product Code'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write Product Code';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _unitPriceTEController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Unit Price'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write Unit Price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _qtyTEController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Quantity'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write Product QTY';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _totalPriceTEController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(labelText: 'Total Price'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Write Total Price';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  TextFormField(
                    controller: _imageTEController,
                    keyboardType: TextInputType.url,
                    decoration: const InputDecoration(labelText: 'Image'),
                    validator: (String? value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Product Image';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  SizedBox(
                    width: double.maxFinite,
                    child: Visibility(
                      visible: _addProductInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      ),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_globalKey.currentState!.validate()) {
                              _addProductList();
                            }
                          },
                          child: const Text('Add Product')),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _addProductList() async {
    _addProductInProgress = true;
    setState(() {});
    const String addProductUrl =
        'https://crud.teamrabbil.com/api/v1/CreateProduct';
    Uri uri = Uri.parse(addProductUrl);

    Map<String, dynamic> inputData = {
      "Img": _imageTEController.text.trim(),
      "ProductCode": _productCodeTEController.text,
      "ProductName": _nameTEController.text,
      "Qty": _qtyTEController.text,
      "TotalPrice": _totalPriceTEController.text,
      "UnitPrice": _unitPriceTEController.text
    };

    Response response = await post(uri, body: jsonEncode(inputData), headers: {
      'content-type': 'application/json',
    });
    _addProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      _nameTEController.clear();
      _imageTEController.clear();
      _productCodeTEController.clear();
      _qtyTEController.clear();
      _totalPriceTEController.clear();
      _unitPriceTEController.clear();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product Add Success!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product Add Failed!')));
    }
  }

  @override
  void dispose() {
    super.dispose();
    _nameTEController.dispose();
    _imageTEController.dispose();
    _productCodeTEController.dispose();
    _qtyTEController.dispose();
    _totalPriceTEController.dispose();
    _unitPriceTEController.dispose();
  }
}
