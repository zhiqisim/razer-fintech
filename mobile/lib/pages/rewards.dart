import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert' as convert;

// http package
import 'package:http/http.dart' as http;
// pretty loading package
import 'package:shimmer/shimmer.dart';


class RewardsPage extends StatefulWidget {
  RewardsPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _RewardsPageState createState() => new _RewardsPageState();
}

class _RewardsPageState extends State<RewardsPage> {
  _RewardsPageState({Key key});
  Future<List<dynamic>> _getRewards() async {
    // var url =
    //     'http://ec2-13-250-45-244.ap-southeast-1.compute.amazonaws.com/vouchers';
    // var response = await http.get(url);

    // if (response.statusCode == 200) {
      // If the server did return a 200 OK response,
      // then parse the JSON.
      // var bytesData = convert.utf8.decode(response.bodyBytes);
      // print(bytesData);
      // var jsonData = convert.json.decode(bytesData);

      String filedata = await DefaultAssetBundle.of(context).loadString("assets/data.json");
      final jsonResult = convert.json.decode(filedata);
      print(jsonResult);
      List<dynamic> data = jsonResult['data'];
      List<dynamic> rewardData = [];
      for (var items in data) {
        rewardData.add(items);
      }
      print(rewardData.length);
      return rewardData;
  //   } else {
  //     // If the server did not return a 200 OK response,
  //     // then throw an exception.
  //     throw Exception('Failed to load stores');
  //   }
  }

  Future<bool> claimDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Congratulations"),
            content: new Text("You have claimed your vouchers from perx!"),
            actions: <Widget>[
              new FlatButton(
                child: const Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("perx Rewards"),
      ),
      body: Container(
        color: Colors.grey[200],
        child: FutureBuilder(
          future: _getRewards(),
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
                          leading: CircleAvatar(
                            backgroundColor: Colors.white,
                            backgroundImage:
                                NetworkImage(snapshot.data[index].images[0].url),
                          ),
                          title: Text(snapshot.data[index].name),
                          subtitle: Text(snapshot.data[index].merchant_name +
                              "\n" +
                              snapshot.data[index].description),
                          onTap: () {
                            claimDialog(context);
                          },
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
      child:
          ListView.builder(
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
