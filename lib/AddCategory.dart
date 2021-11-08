import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:js' as js;

const SERVER_IP = 'https://koko-backend.herokuapp.com';

// ignore: must_be_immutable
class AddCategory extends StatefulWidget {
  AddCategory({required this.id});
  String id;

  @override
  _AddCategoryState createState() => _AddCategoryState();
}

class _AddCategoryState extends State<AddCategory> {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();

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

    return Scaffold(
        appBar: AppBar(
          title: Text('Master Inventory for Koko'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'Adding a new category',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              ),
            ),
            textField(
                h: h,
                w: w,
                name: "Name of new category",
                controller: controller1),
            // textField(
            //     h: h, w: w, name: "Price in INR", controller: controller2),
            // textField(
            //     h: h, w: w, name: "Product Type", controller: controller3),
            // textField(
            //     h: h, w: w, name: "Available Stock", controller: controller4),
            // textField(h: h, w: w, name: "Weight", controller: controller5),
            // textField(h: h, w: w, name: "Photo Link", controller: controller6),
            ElevatedButton(
                onPressed: () async {
                  print('*********** see below ******');

                  var res = await http.post(
                    Uri.parse('$SERVER_IP/masterInventory'),
                    headers: {"Access-Control-Allow-Origin": "*"},
                    body: jsonEncode(<String, dynamic>{
                      "name": controller1.text,
                      "parent": widget.id
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
                child: Text('Add Category')),
          ],
        ));
  }
}
