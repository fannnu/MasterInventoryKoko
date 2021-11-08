import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:master_inventory_koko/AddCategory.dart';
import 'package:master_inventory_koko/EditCategory.dart';
import 'dart:js' as js;

import 'package:master_inventory_koko/products.dart';

const SERVER_IP = 'https://koko-backend.herokuapp.com';

class MyHomePage extends StatefulWidget {
  MyHomePage({
    required this.oid,
  });
  String oid;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String id =
      "6160a5dfecfd8b0e64f88c38"; //initial id set for Product root category

  Future<dynamic> getChildren() async {
    //var input = widget.oid == null ? id : widget.oid;
    var res = await http.get(Uri.parse('$SERVER_IP/getChildren/${widget.oid}'),
        headers: {"Access-Control-Allow-Origin": "*"});
    print(res.statusCode);

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

  // @override
  // void initState() {
  //   super.initState();

  //   js.context.callMethod("alert", <String>["Your debug message "]);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Master Inventory for Koko'),
        ),
        body: FutureBuilder(
          future: getChildren(),
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.hasData) {
              //List<Map<String, dynamic>> data = snapshot.data;
              var data = snapshot.data;

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
                                  builder: (context) => AddCategory(
                                    id: widget.oid,
                                  ),
                                  settings: RouteSettings(name: '/AddProduct'),
                                ),
                              );
                            },
                            child: Text('Add a category')),
                      ),
                      Container(
                        height: 600,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: data.length == 0 ? 1 : data.length,
                          itemBuilder: (BuildContext context, int index) {
                            if (data.length == 0) {
                              return ListTile(
                                  title: Text('No Children categories found!'));
                            } else {
                              var name = data[index]['name'];
                              var oid = data[index]['_id'];
                              var products = data[index]['products'];
                              print('**********');
                              print(products.isEmpty);
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Card(
                                  elevation: 5,
                                  child: Container(
                                    height: 70,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Text(
                                            '$name',
                                            style: TextStyle(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w600),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditCategory(
                                                          //oid: id,
                                                          id: oid,
                                                          map: data[index],
                                                        ),
                                                        settings: RouteSettings(
                                                            name: '/Login'),
                                                      ),
                                                    );
                                                  },
                                                  child: Text('Edit Category')),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: ElevatedButton(
                                                  onPressed: () {
                                                    Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            MyHomePage(
                                                          //oid: id,
                                                          oid: oid,
                                                        ),
                                                        settings: RouteSettings(
                                                            name: '/Login'),
                                                      ),
                                                    );
                                                  },
                                                  child: Text(
                                                      'Open Children Categories')),
                                            ),
                                            products.length != 0
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: ElevatedButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .push(
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Products(
                                                                //oid: id,
                                                                id: oid,
                                                              ),
                                                              settings:
                                                                  RouteSettings(
                                                                      name:
                                                                          '/Login'),
                                                            ),
                                                          );
                                                        },
                                                        child: Text(
                                                            'Open Products (${products.length})')),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            }

                            // return Card(
                            //   elevation: 5,
                            //   child: ListTile(
                            //     title: Text('yo?'),
                            //   ),
                            // );

                            // return Card(
                            //   elevation: 5,
                            //   child: ListTile(
                            //     title: Text(
                            //       '',
                            //       //'$name',
                            //       style: TextStyle(),
                            //     ),
                            //     // trailing: Row(
                            //     //   children: [
                            //     //     ElevatedButton(
                            //     //         onPressed: () {},
                            //     //         child:
                            //     //             Text('Open Children Categories')),
                            //     //     ElevatedButton(
                            //     //         onPressed: () {},
                            //     //         child: Text('Open Products')),
                            //     //   ],
                            //     // ),
                            //     onTap: () {
                            //       Navigator.of(context).push(
                            //         MaterialPageRoute(
                            //           builder: (context) => MyHomePage(
                            //               //oid: id,
                            //               //oid: oid,
                            //               ),
                            //           settings: RouteSettings(name: '/Login'),
                            //         ),
                            //       );
                            //     },
                            //   ),
                            // );
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
        )
        // This trailing comma makes auto-formatting nicer for build methods.
        );
  }
}

// FutureBuilder(
//       future: getProducts(),
//       builder: (context, AsyncSnapshot<dynamic> snapshot) {
//         if (snapshot.hasData) {
//           //List<Map<String, dynamic>> data = snapshot.data;
//           var data = snapshot.data;
//           print(data);
//           return Column(
//             children: [

//             ],
//           );
//         }
//         if (snapshot.hasError) {
//           return SingleChildScrollView(
//               child: Center(child: Text(snapshot.error.toString())));
//         } else {
//           return Center(child: CircularProgressIndicator());
//         }
//       },
//     );

// Navigator.pushReplacement(
//                                               context,
//                                               MaterialPageRoute(
//                                                   builder:
//                                                       (BuildContext context) =>
//                                                           super.widget));
