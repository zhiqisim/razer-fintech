import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'dart:io';
import 'dart:async';
import 'dart:convert' as convert;

// http package
import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart' as dio;

// models
import '../models/Store.dart';
// pages
import './storefront.dart' as storefront;

class Create extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CreateState();
  }
}

class _CreateState extends State<Create> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

// Upload profile image:
  File _image;
  String _name;
  String _location;
  String _description;
  List<String> _store_type = new List<String>();
  String _type;

  @override
  void initState() {
    _store_type
        .addAll(["Food & Beverages", "Entertainment", "Fitness", "Events"]);
  }

  void _onChangedNat(String value) {
    setState(() {
      _type = value;
    });
  }

  // save to database (API call)
  void _save(BuildContext context) async {
    Store store =
        Store(_name, "razerid4", _location, _type, _description, null);
    var postData = store.toJson();
    //create multipart request for POST or PATCH method
    var request = http.MultipartRequest(
        "POST",
        Uri.parse(
            "http://ec2-13-250-45-244.ap-southeast-1.compute.amazonaws.com/store"));
    //add text fields
    request.fields["data"] = "{\"name\":" +
        postData['name'] +
        ", \"location\": " +
        postData['location'] +
        ", \"owner\": " +
        postData['owner'] +
        ", \"store_type\": " +
        postData['store_type'] +
        ", \"description\": " +
        postData['description'] +
        "}";
    //create multipart using filepath, string or bytes
    if (_image != null) {
      var pic = await http.MultipartFile.fromPath("logo", _image.path);
      //add multipart to request
      request.files.add(pic);
      request.files.add(pic);
    }
    //add multipart to request
    var response = await request.send();

    //Get the response from the server
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    var jsonData = convert.json.decode(responseString);
    print(jsonData['store_id']);
    Navigator.of(context).pop(true);
    Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => storefront.StoreFront(
                  title: postData['name'],
                  selectedUrl:
                      "https://pub.dev/packages/webview_flutter#-readme-tab-",
                )));
  }

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {
      _image = image;
      print(_image.path);
    });
  }

  Future<bool> nullDialog(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: new Text("Sorry"),
            content: new Text("Please fill up all the fields in the form!"),
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
          title: new Text("Create Virtual Store"),
        ),
        body: new Container(
            color: Colors.grey[200],
            child: new ListView(children: <Widget>[
              new Container(
                margin: EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 20.0),
                child: _image == null
                    ? Column(
                        children: <Widget>[
                          new Container(
                            padding: new EdgeInsets.all(10.0),
                            child: new FloatingActionButton(
                              heroTag: 1,
                              onPressed: getImage,
                              child: Icon(Icons.add_a_photo),
                            ),
                          ),
                          new Text(
                            'Add Logo File',
                            style: TextStyle(),
                          ),
                        ],
                      )
                    : Image.file(_image, width: 150, height: 150),
              ),
              new Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0)),
                  margin: EdgeInsets.fromLTRB(15.0, 5.0, 15.0, 5.0),
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 20.0),
                      child: Form(
                          key: _formKey,
                          child: Column(children: <Widget>[
                            AppBar(
                                title: Text('Store Information'),
                                automaticallyImplyLeading: false),
                            Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 20, vertical: 10),
                                child: Column(children: <Widget>[
                                  TextFormField(
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your store brand name!';
                                        }
                                      },
                                      onChanged: (String n) {
                                        setState(() {
                                          _name = n;
                                        });
                                      },
                                      decoration: new InputDecoration(
                                          icon: const Icon(Icons.person),
                                          labelText: 'Store Brand:')),
                                  SizedBox(height: 10),
                                  TextFormField(
                                      textCapitalization:
                                          TextCapitalization.words,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter your store location!';
                                        }
                                      },
                                      onChanged: (String n) {
                                        setState(() {
                                          _location = n;
                                        });
                                      },
                                      decoration: new InputDecoration(
                                          icon: const Icon(Icons.location_on),
                                          labelText: 'Location:')),
                                  SizedBox(height: 10),
                                  TextFormField(
                                      textCapitalization:
                                          TextCapitalization.sentences,
                                      validator: (value) {
                                        if (value.isEmpty) {
                                          return 'Please enter a simple description of your store!';
                                        }
                                      },
                                      onChanged: (String n) {
                                        setState(() {
                                          _description = n;
                                        });
                                      },
                                      decoration: new InputDecoration(
                                          icon: const Icon(Icons.description),
                                          labelText: 'Description:')),
                                  new InputDecorator(
                                      decoration: new InputDecoration(
                                          icon: Icon(
                                            Icons.category,
                                          ),
                                          labelText: 'Store Type:',
                                          labelStyle: TextStyle(fontSize: 20.0),
                                          contentPadding:
                                              EdgeInsets.only(top: 25.0)),
                                      isEmpty: _type == '',
                                      child: new DropdownButtonHideUnderline(
                                        child: DropdownButtonFormField<String>(
                                          value: _type,
                                          onChanged: (String value) {
                                            _onChangedNat(value);
                                          },
                                          validator: (value) => value == ''
                                              ? 'Please enter the kind of store you are creating!'
                                              : null,
                                          items:
                                              _store_type.map((String value) {
                                            return new DropdownMenuItem(
                                              value: value,
                                              child: new Row(children: <Widget>[
                                                new Text('${value}'),
                                              ]),
                                            );
                                          }).toList(),
                                        ),
                                      )),
                                ])),
                          ])))),
              new Container(
                padding: new EdgeInsets.only(
                    top: 20.0, left: 300.0, bottom: 20.0, right: 30.0),
                child: new ButtonTheme(
                  minWidth: 5.0,
                  height: 5.0,
                  child: new FloatingActionButton(
                      onPressed: () {
                        if (_formKey.currentState.validate()) {
                          _save(context);
                        } else {
                          nullDialog(context);
                        }
                      },
                      child: Center(
                        child: Icon(Icons.navigate_next),
                      )),
                ),
              )
            ])));
  }
}
