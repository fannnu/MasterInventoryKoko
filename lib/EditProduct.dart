import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:js' as js;

const SERVER_IP = 'https://koko-backend.herokuapp.com';

class EditProducts extends StatefulWidget {
  EditProducts({required this.map, required this.id});
  Map<String, dynamic> map;
  String id;

  @override
  _EditProductsState createState() => _EditProductsState();
}

class _EditProductsState extends State<EditProducts> {
  // Future<dynamic> getChildren() async {
  //   //var input = widget.oid == null ? id : widget.oid;
  //   var res = await http.get(Uri.parse('$SERVER_IP/getChildren/${widget.oid}'),
  //       headers: {"Access-Control-Allow-Origin": "*"});
  //   print(res.statusCode);

  //   if (res.statusCode == 200) {
  //     if (res.body == '[]') {
  //       //Map<String, dynamic> resMap = {};
  //       List<dynamic> resMap = [];
  //       return resMap;
  //     } else {
  //       List<dynamic> resMap = json.decode(res.body);
  //       print(res.statusCode);
  //       return (resMap);
  //     }
  //   } else {
  //     print('*@*@*@*@*@*@*2');
  //     print('order NOT working');
  //     print('get dashboard status code: ${res.statusCode}');
  //     print("****");
  //     //throw Exception('Error collecting the data');
  //   }
  // }
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  TextEditingController controller3 = TextEditingController();
  TextEditingController controller4 = TextEditingController();
  TextEditingController controller5 = TextEditingController();
  TextEditingController controller6 = TextEditingController();
  TextEditingController controller7 = TextEditingController();
  TextEditingController controller8 = TextEditingController();
  TextEditingController controller9 = TextEditingController();

  Widget textField(
      {required double h,
      required double w,
      required String name,
      bool num = false,
      required TextEditingController controller}) {
    return Align(
      alignment: Alignment.center,
      child: Container(
        height: h * 0.1,
        width: w * 0.4,
        child: TextField(
            controller: controller,
            keyboardType:
                num == true ? TextInputType.number : TextInputType.text,
            decoration: InputDecoration(
                labelText: "$name",
                hintText: "$name",
                border: OutlineInputBorder())),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var w = MediaQuery.of(context).size.width;
    var h = MediaQuery.of(context).size.height;
    Map<String, dynamic> map = widget.map;
    controller1.text = map['name'];
    controller2.text = map['price'].toString();
    controller3.text = map['productType'];
    controller4.text = map['productDetails']['availableStock'].toString();
    controller5.text = map['productDetails']['weight'].toString();
    controller6.text = map['productDetails']['photoLink'];
    return Scaffold(
        appBar: AppBar(
          title: Text('Master Inventory for Koko'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Editing product listing for: ${widget.map['name']}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            textField(h: h, w: w, name: "Name", controller: controller1),
            textField(
                h: h, w: w, name: "Price in INR", controller: controller2),
            textField(
                h: h, w: w, name: "Product Type", controller: controller3),
            textField(
                h: h, w: w, name: "Available Stock", controller: controller4),
            textField(h: h, w: w, name: "Weight", controller: controller5),
            textField(h: h, w: w, name: "Photo Link", controller: controller6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                    onPressed: () async {
                      print('*********** see below ******');
                      print(widget.map);
                      var res = await http.patch(
                        Uri.parse(
                            '$SERVER_IP/updateProductMI/${widget.id}/${map['_id']}'),
                        headers: {"Access-Control-Allow-Origin": "*"},
                        body: jsonEncode(<String, dynamic>{
                          "name": controller1.text,
                          "price": int.parse(controller2.text),
                          'productType': controller3.text,
                          'productDetails': {
                            'availableStock': int.parse(controller4.text),
                            'weight': int.parse(controller5.text),
                            'photoLink': controller6.text
                          }
                        }),
                      );
                      print(res.statusCode);
                      print(widget.id);
                      if (res.statusCode == 200) {
                        // if (res.body == '{}') {
                        //   //Map<String, dynamic> resMap = {};
                        //   var resMap = {};
                        // } else {
                        //   var resMap = json.decode(res.body);
                        //   print(res.statusCode);
                        //   Navigator.pop(context);
                        // }
                        var resMap = json.decode(res.body);
                        print(resMap);
                        print(res.statusCode);
                        Navigator.pop(context);
                      }
                    },
                    child: Text('Edit')),
                ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.red),
                    ),
                    onPressed: () {},
                    child: Text('Delete Product'))
              ],
            ),
          ],
        ));
  }
}
