import 'dart:convert';
import 'package:crud_app_assignment/models/product_model_class.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateScreen extends StatefulWidget {
  const UpdateScreen({super.key, required this.productModel});
  final ProductModel productModel;

  @override
  State<UpdateScreen> createState() => _UpdateScreenState();
}

class _UpdateScreenState extends State<UpdateScreen> {
  final TextEditingController _nameTEController = TextEditingController();
  final TextEditingController _productCodeTEController = TextEditingController();
  final TextEditingController _unitPriceTEController = TextEditingController();
  final TextEditingController _qtyTEController = TextEditingController();
  final TextEditingController _totalPriceTEController = TextEditingController();
  final TextEditingController _imageTEController = TextEditingController();
  bool _udateProductInProgress = false;
  final GlobalKey<FormState> _globalKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _nameTEController.text = widget.productModel.productName ?? 'Unknown';
    _unitPriceTEController.text = widget.productModel.unitPrice ?? '';
    _productCodeTEController.text = widget.productModel.productCode ?? '';
    _totalPriceTEController.text = widget.productModel.totalPrice ?? '';
    _qtyTEController.text = widget.productModel.qty ?? '';
    _imageTEController.text = widget.productModel.img ?? '';


  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Update Product'),
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
                      visible: _udateProductInProgress == false,
                      replacement: const Center(
                        child: CircularProgressIndicator(
                          color: Colors.orange,
                        ),
                      ),
                      child: ElevatedButton(
                          onPressed: () {
                            if (_globalKey.currentState!.validate()) {
                              _updateProductList();
                            }
                          },
                          child: const Text('Update Product')),
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _updateProductList() async {
    _udateProductInProgress = true;
    setState(() {});
     String addProductUrl =
        'https://crud.teamrabbil.com/api/v1/UpdateProduct/${widget.productModel.sId}';
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
    _udateProductInProgress = false;
    setState(() {});

    if (response.statusCode == 200) {
      Navigator.pop(context);

      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product Update Success!')));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Product Update Failed!')));
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
