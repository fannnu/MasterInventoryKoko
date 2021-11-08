import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:master_inventory_koko/AddProduct.dart';
import 'dart:js' as js;

import 'package:master_inventory_koko/EditProduct.dart';

const SERVER_IP = 'https://koko-backend.herokuapp.com';

class Products extends StatefulWidget {
  Products({required this.id});
  final String id;

  @override
  _ProductsState createState() => _ProductsState();
}

class _ProductsState extends State<Products> {
  Future<dynamic> getProducts() async {
    //var input = widget.oid == null ? id : widget.oid;
    var res = await http.get(Uri.parse('$SERVER_IP/Category/${widget.id}'),
        headers: {"Access-Control-Allow-Origin": "*"});
    print(res.statusCode);
    print(widget.id);
    if (res.statusCode == 200) {
      if (res.body == '[]') {
        //Map<String, dynamic> resMap = {};
        List<dynamic> resMap = [];
        return resMap;
      } else {
        List<dynamic> resMap = json.decode(res.body);
        print(res.statusCode);
        return (resMap);
      }
    } else {
      print('*@*@*@*@*@*@*2');
      print('order NOT working');
      print('get dashboard status code: ${res.statusCode}');
      print("****");
      //throw Exception('Error collecting the data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Master Inventory for Koko'),
      ),
      body: FutureBuilder(
        future: getProducts(),
        builder: (context, AsyncSnapshot<dynamic> snapshot) {
          if (snapshot.hasData) {
            //List<Map<String, dynamic>> data = snapshot.data;
            var data = snapshot.data;
            var id = data[0]['_id'];
            var products = data[0]['products'];
            var pName = data[0]['name'];
            print(data);
            return SingleChildScrollView(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: 25,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => AddProduct(
                                  id: widget.id,
                                ),
                                settings: RouteSettings(name: '/AddProduct'),
                              ),
                            );
                          },
                          child: Text('Add a Product to $pName')),
                    ),
                    Container(
                      height: 600,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: products.length,
                        itemBuilder: (BuildContext context, int index) {
                          var name = products[index]['name'];
                          var pid = products[index]['_id'];
                          var pic =
                              products[index]['productDetails']['photoLink'];

                          print('**********');
                          print(products.isEmpty);
                          if (data.length == 0) {
                            return ListTile(
                                title: Text('No Children categories found!'));
                          }
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              elevation: 5,
                              child: Container(
                                height: 90,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                      height: 70,
                                      child: Image.network(
                                        pic != null
                                            ? pic
                                            : "https://cdn-images-1.medium.com/max/1000/0*uupkS61FxPU9xb-L",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Text(
                                        '$name',
                                        style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500),
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: ElevatedButton(
                                              onPressed: () {
                                                Navigator.of(context).push(
                                                  MaterialPageRoute(
                                                    builder: (context) =>
                                                        EditProducts(
                                                      id: id,
                                                      map: products[index],
                                                    ),
                                                    settings: RouteSettings(
                                                        name: '/Login'),
                                                  ),
                                                );
                                              },
                                              child: Text('Edit Product')),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          }
          if (snapshot.hasError) {
            return SingleChildScrollView(
                child: Center(child: Text(snapshot.error.toString())));
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}
