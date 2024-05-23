import 'dart:convert';
import 'package:crud_app_assignment/models/product_model_class.dart';
import 'package:crud_app_assignment/screens/add_product_screen.dart';
import 'package:crud_app_assignment/screens/update_product_screen.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<ProductModel> productList = [];
  bool _getProductInProgress = false;

  @override
  void initState() {
    super.initState();
    _getProductList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crud App'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddProductScreen(),
              ));
        },
        child: const Icon(Icons.add),
      ),
      body: SingleChildScrollView(
        child: RefreshIndicator(
          onRefresh: _getProductList,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Visibility(
                  visible: _getProductInProgress == false,
                  replacement: const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orange,
                    ),
                  ),
                  child: ListView.builder(
                    itemCount: productList.length,
                    primary: false,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(6)),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 5,
                                  blurRadius: 7,
                                  offset: const Offset(
                                      0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: _productItemBuild(productList[index]),
                          ),
                          const SizedBox(
                            height: 15,
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _productItemBuild(ProductModel productModel) {
    return ListTile(
      title: Text(productModel.productName ?? 'unknown'),
      subtitle: Wrap(
        children: [
          Text('QTY: ${productModel.qty}'),
          const SizedBox(width: 10),
          Text('Unit Price: ${productModel.unitPrice}'),
          const SizedBox(width: 10),
          Text('Total Price: ${productModel.totalPrice}'),
        ],
      ),
      trailing: Wrap(
        children: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          UpdateScreen(productModel: productModel),
                    ));
              },
              icon: const Icon(Icons.edit)),
          IconButton(
            onPressed: () {
              _showDeleteBox(productModel.sId!);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      leading: Image.network(  'https://fossil.scene7.com/is/image/FossilPartners/FS5304_main?',),
    );
  }


  Future<void> _getProductList() async {
    _getProductInProgress = true;
    productList.clear();
    setState(() {});
    const String productUrl = 'https://crud.teamrabbil.com/api/v1/ReadProduct';
    Uri uri = Uri.parse(productUrl);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      final decodeData = jsonDecode(response.body);
      final jsonProductList = decodeData['data'];
      for (Map<String, dynamic> json in jsonProductList) {
        ProductModel productModel = ProductModel.fromJson(json);
        productList.add(productModel);
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Get Product List Failed')));
    }
    _getProductInProgress = false;
    setState(() {});
  }

  void _showDeleteBox(String productModelsId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            textAlign: TextAlign.center,
            'Are You Delete it?',
            style: TextStyle(
                color: Colors.orange,
                fontSize: 20,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  _deleteProductItem(productModelsId);
                  Navigator.pop(context);
                },
                child: const Text(
                  'Yes! Delete',
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )),
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(
                      color: Colors.orange,
                      fontSize: 16,
                      fontWeight: FontWeight.w500),
                )),
          ],
          actionsAlignment: MainAxisAlignment.center,
        );
      },
    );
  }

  Future<void> _deleteProductItem(String productModelsId) async {
    _getProductInProgress = false;
    setState(() {});
    String deleteProductUrl =
        'https://crud.teamrabbil.com/api/v1/DeleteProduct/$productModelsId';
    Uri uri = Uri.parse(deleteProductUrl);
    Response response = await get(uri);

    if (response.statusCode == 200) {
      _getProductList();
    } else {
      _getProductInProgress = true;
      setState(() {});
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(' Product delete Failed')));
    }
  }
}
