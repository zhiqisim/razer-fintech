import 'package:flutter/material.dart';

// import 'package:shared_preferences/shared_preferences.dart';

//pages
import './stores.dart' as stores;
import './vendor.dart' as vendor;

class Login extends StatefulWidget {
  Login({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0);
  String _id;
  // SharedPreferences prefs;
  String _selectedType;

  // void _save() async {
  //   prefs = await SharedPreferences.getInstance();
  //   await prefs.setString('id', _id);
  // }

  void _onChangedType(String value) {
    setState(() {
      _selectedType = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Center(
      child: Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(36.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 155.0,
                ),
                SizedBox(height: 45.0),
                TextFormField(
                  validator: (value) {
                    if (value.isEmpty) {
                      return 'Please enter your ID!';
                    }
                  },
                  keyboardType: TextInputType.number,
                  onChanged: (String n) {
                    setState(() {
                      _id = n;
                    });
                  },
                  decoration: InputDecoration(
                      contentPadding:
                          EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                      hintText: "ID",
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(32.0))),
                ),
                SizedBox(
                  height: 35.0,
                ),
                new Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    new Text('User'),
                    new Radio(
                      value: 'User',
                      groupValue: _selectedType,
                      onChanged: (String value) {
                        _onChangedType(value);
                      },
                    ),
                    new Text('Vendor'),
                    new Radio(
                      value: 'Vendor',
                      groupValue: _selectedType,
                      onChanged: (String value) {
                        _onChangedType(value);
                      },
                    ),
                  ],
                ),
                SizedBox(
                  height: 35.0,
                ),
                Material(
                  elevation: 5.0,
                  borderRadius: BorderRadius.circular(30.0),
                  color: Colors.green,
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        if (_selectedType != null && _id != null) {
                          if (_selectedType == "Vendor") {
                            print(_id);
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) => vendor.VendorPage(
                                        title: "Store Management")));
                          } else {
                            print(_id);
                            Navigator.push(
                                context,
                                new MaterialPageRoute(
                                    builder: (context) =>
                                        stores.MyHomePage(title: "Stores")));
                          }
                        }
                      }
                    },
                    child: Text("Login",
                        textAlign: TextAlign.center,
                        style: style.copyWith(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
                SizedBox(
                  height: 15.0,
                ),
              ],
            ),
          ),
        ),
      ),
    )));
  }
}
