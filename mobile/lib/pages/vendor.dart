import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;

// http package
import 'package:http/http.dart' as http;
// pretty loading package
import 'package:shimmer/shimmer.dart';

// models
import '../models/Store.dart';
// pages
import './createStore.dart' as create;
import './storefront.dart' as storefront;
import './orders.dart' as orders;

import 'package:url_launcher/url_launcher.dart';

class VendorPage extends StatefulWidget {
  VendorPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _VendorPageState createState() => new _VendorPageState();
}

class _VendorPageState extends State<VendorPage> {
  Future<List<Store>> _getStores() async {
    var url =
        'http://ec2-13-250-45-244.ap-southeast-1.compute.amazonaws.com/store';
    var response = await http.get(url);

    if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      var bytesData = convert.utf8.decode(response.bodyBytes);
      print(bytesData);
      var jsonData = convert.json.decode(bytesData);
      print(jsonData);
      List<Store> stores = [];
      print(jsonData.keys);
      for (final s in jsonData.keys) {
        if (jsonData[s]['owner'] == 'razerid4') {
          Store store = Store(
              jsonData[s]['name'],
              jsonData[s]['owner'],
              jsonData[s]['location'],
              jsonData[s]['store_type'],
              jsonData[s]['description'],
              jsonData[s]['logo']);
          stores.add(store);
        }
      }
      print(stores.length);
      return stores;
    } else {
      // If the server did not return a 200 OK response,
      // then throw an exception.
      throw Exception('Failed to load stores');
    }
  }

   _launchURL() async {
  const url = 'http://f2d8405a.ngrok.io/view/-M7Uxd38h4VrBpRe6Mk-';
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text(widget.title), actions: <Widget>[
        new IconButton(
          icon: new Icon(Icons.shopping_basket),
          tooltip: 'Orders',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => orders.OrdersPage()));
          },
        ),
        new IconButton(
          icon: new Icon(Icons.add),
          tooltip: 'Create',
          onPressed: () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => create.Create()));
          },
        ),
      ]),
      body: Container(
        color: Colors.grey[200],
        child: FutureBuilder(
          future: _getStores(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.data == null) {
              return LoadingList();
            } else {
              // grid view
              return new GridView.builder(
                  itemCount: snapshot.data.length,
                  gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                      mainAxisSpacing: 2.0,
                      crossAxisSpacing: 0.0,
                      childAspectRatio: 1.0,
                      crossAxisCount: 2),
                  itemBuilder: (context, index) {
                    return new Card(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        margin: EdgeInsets.fromLTRB(10.0, 5.0, 10.0, 5.0),
                        child: new InkResponse(
                          child: new GridTile(
                              child: new Column(children: <Widget>[
                            new Container(
                              width: 80,
                              height: 80,
                              margin: const EdgeInsets.fromLTRB(
                                  40.0, 20.0, 40.0, 0.0),
                              child:
                                  new Image.network(snapshot.data[index].logo),
                            ),
                            SizedBox(height: 15),
                            new Text(snapshot.data[index].name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize:15.0)),
                            SizedBox(height: 5),
                            new Text(snapshot.data[index].storeType,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 12.0)),
                            SizedBox(height: 5),
                            new Text(snapshot.data[index].location,
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 10.0)),
                          ])),
                          onTap: () {
                            _launchURL();
                            // Navigator.push(
                            //     context,
                            //     new MaterialPageRoute(
                            //         builder: (context) => storefront.StoreFront(
                            //               title: snapshot.data[index].name,
                            //               selectedUrl:
                            //                   "https://f2d8405a.ngrok.io/create-store/-M7Uxd38h4VrBpRe6Mk-",
                            //             )));
                          },
                        ));
                  });
              // List view
              // ListView.builder(
              //   itemCount: snapshot.data.length,
              //   itemBuilder: (BuildContext context, int index) {
              //     return new Card(
              //       color: Colors.white,
              //       shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10.0)),
              //       margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
              //       child: new Column(
              //         mainAxisSize: MainAxisSize.min,
              //         children: <Widget>[
              //           new ListTile(
              //             leading: CircleAvatar(
              //               backgroundColor: Colors.white,
              //               backgroundImage:
              //                   NetworkImage(snapshot.data[index].logo),
              //             ),
              //             title: Text(snapshot.data[index].name),
              //             subtitle: Text(snapshot.data[index].location +
              //                 "\n" +
              //                 snapshot.data[index].storeType),
              //             onTap: () {
              //               Navigator.push(
              //                   context,
              //                   new MaterialPageRoute(
              //                       builder: (context) =>
              //                       // storefront.StoreFront(
              //                       //       title: snapshot.data[index].name,
              //                       //       selectedUrl:
              //                       //           "https://zhiqisim.github.io/",
              //                       //     )));
              //               profiles.Profiles()));
              //               // DetailPage(snapshot.data[index])));
              //             },
              //           ),
              //         ],
              //       ),
              //     );
              //   },
              // );
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
      child:
          // ListView.builder(
          GridView.builder(
        itemCount: 10,
        gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
            mainAxisSpacing: 2.0,
            crossAxisSpacing: 0.0,
            childAspectRatio: 1.0,
            crossAxisCount: 2),
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

// for gridview
class LoadingLayout extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double containerWidth = 150;
    double containerHeight = 15;

    return Container(
      margin: EdgeInsets.symmetric(vertical: 7.5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              )),
          SizedBox(height: 15),
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
          ),
          SizedBox(height: 5),
          Container(
            height: containerHeight,
            width: containerWidth * 0.75,
            color: Colors.grey,
          ),
        ],
      ),
    );
  }
}

// for listview
// class LoadingLayout extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     double containerWidth = 280;
//     double containerHeight = 15;

//     return Container(
//       margin: EdgeInsets.symmetric(vertical: 7.5),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Container(
//               width: 50,
//               height: 50,
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: Colors.grey,
//               )),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Container(
//                 height: containerHeight,
//                 width: containerWidth,
//                 color: Colors.grey,
//               ),
//               SizedBox(height: 5),
//               Container(
//                 height: containerHeight,
//                 width: containerWidth * 0.75,
//                 color: Colors.grey,
//               )
//             ],
//           )
//         ],
//       ),
//     );
//   }
// }
