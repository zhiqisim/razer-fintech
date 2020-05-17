import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;

// http package
import 'package:http/http.dart' as http;
// pretty loading package
import 'package:shimmer/shimmer.dart';

// models
import '../models/Item.dart';

class OrdersPage extends StatefulWidget {
  OrdersPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _OrdersPageState createState() => new _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  _OrdersPageState({Key key});
  Future<List<dynamic>> _getItems() async {
    var url =
        'http://ec2-13-250-45-244.ap-southeast-1.compute.amazonaws.com/orders';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var bytesData = convert.utf8.decode(response.bodyBytes);
      print(bytesData);
      var jsonData = convert.json.decode(bytesData);
      print(jsonData);
      List<Item> items = [];
      print(jsonData.keys);
      for (final s in jsonData.keys) {
        String storename = jsonData[s]['storename'];
        for (final l in jsonData[s]['items'].keys) {
          Item item = Item(
              jsonData[s]['items'][l]['name'],
              jsonData[s]['items'][l]['price'],
              jsonData[s]['items'][l]['quantity'],
              storename);
          items.add(item);
        }
      }
      print(items.length);
      return items;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load stores');
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Orders"),
      ),
      body: Container(
        color: Colors.grey[200],
        child: FutureBuilder(
          future: _getItems(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return LoadingList();
            } else {
              return new ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  return new Card(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                    child: new Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        new ListTile(
                          leading:Text(snapshot.data[index].quantity,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15.0)),
                          title: Text(snapshot.data[index].name),
                          subtitle: Text("\$" +snapshot.data[index].price
                          +"\n"+ "Storename: " + snapshot.data[index].storename),
                          onTap: () {},
                        ),
                      ],
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}

class LoadingList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    int time = 800;

    return SafeArea(
      child: ListView.builder(
        // GridView.builder(
        itemCount: 10,
        itemBuilder: (BuildContext context, int index) {
          return new Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
            child: new Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: Shimmer.fromColors(
                      highlightColor: Colors.white,
                      baseColor: Colors.grey[300],
                      child: LoadingLayout(),
                      period: Duration(milliseconds: time),
                    ))
              ],
            ),
          );
        },
      ),
    );
  }
}

// for listview
class LoadingLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 280;
    double containerHeight = 15;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: containerHeight,
                width: containerWidth,
                color: Colors.grey,
              ),
              SizedBox(height: 5),
              Container(
                height: containerHeight,
                width: containerWidth * 0.75,
                color: Colors.grey,
              )
            ],
          )
        ],
      ),
    );
  }
}
