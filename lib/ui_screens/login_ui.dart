import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:preorder_flutter/api/login_api.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';
import 'package:preorder_flutter/ui_screens/city_list_ui.dart';
import 'package:preorder_flutter/utils/strings.dart';
import 'package:toast/toast.dart';

class Login extends StatefulWidget {
  static const routeName = '/login';
  Login({Key key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  var validation = false;
  TextEditingController mobileEditingContrller = TextEditingController();
  TextEditingController otpEditingContrller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
      // This is a main  container which has some background image
      // decoration: new BoxDecoration(
      //   image: new DecorationImage(
      //     image: new AssetImage("assets/images/food1.jpeg"),
      //     fit: BoxFit.cover,
      //   ),
      // ),
      child: Center(
        child: SingleChildScrollView(
          child: Container(
            child: Form(
              key: _formKey,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      margin: const EdgeInsets.only(
                          left: 70.0, right: 80.0, top: 10.0),
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.white,
                        elevation: 4,
                        borderRadius:  BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                        child: Theme(
                          child: TextFormField(
                            cursorColor: Colors.deepPurple,
                            style: TextStyle(color: Colors.deepPurple),
                            controller: mobileEditingContrller,
                            validator: (mobileEditingContrller) {
                              if (mobileEditingContrller.isEmpty) {
                                return 'Enter valid Number';
                              }
                              if (10 > mobileEditingContrller.length) {
                                return 'Mobile number must have 10 digits';
                              }
                              String patttern = r'(^(?:[+,0,4&6-9])[0-9]*$)';

                              RegExp regExp = RegExp(patttern);

                              if (!regExp.hasMatch(
                                  mobileEditingContrller.toString())) {
                                return 'Please enter valid number';
                              }
                              return null;
                            },
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(10),
                            ],
                            textAlign: TextAlign.center,
                            keyboardType: TextInputType.number,
                            obscureText: false,
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:  BorderSide(
                                        color: Colors.white, width: 0.0)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 10),
                                labelText: 'Mobile number',
                                border: InputBorder.none),
                          ),
                          data: ThemeData(
                              primaryColor: Colors.deepPurple,
                              hintColor: Colors.deepPurple),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(right: 10.0),

                          //Button for generating OTP for the mobile number which is stored in mobileNumber Text field.
                          child: MaterialButton(
                              minWidth: 5,
                              height: 25,
                              color: Colors.lightBlueAccent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(25),
                                  side: BorderSide(color: Colors.black45)),
                              child:  Text(
                                "Verify",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 15.0,
                                ),
                                textAlign: TextAlign.end,
                              ),

                              onPressed: () async {
                                var connectivityResult =
                                    await (Connectivity().checkConnectivity());
                                if (connectivityResult ==
                                        ConnectivityResult.mobile ||
                                    connectivityResult ==
                                        ConnectivityResult.wifi) {
                                  if (_formKey.currentState.validate()) {
                                    //Calling otpgenerator method for generating OTP from signup_api.dart file by passing arguments MobileNumber
                                    otpgnerator(
                                            context,
                                            mobileEditingContrller.text
                                                .toString())
                                        .then((result) => {
                                              print(result.body),
                                            })
                                        .catchError((e) {
                                      //  Toast.show(
                                      //             "please check your connetion.",
                                      //             context,
                                      //             duration:
                                      //                 Toast.LENGTH_LONG,
                                      //             gravity: Toast.BOTTOM);
                                    }).timeout(Duration(seconds: 30),
                                            onTimeout: () => {
                                                  Toast.show(
                                                      "poor internet connection",
                                                      context,
                                                      duration:
                                                          Toast.LENGTH_LONG,
                                                      gravity: Toast.BOTTOM)
                                                });
                                  }
                                } else {
                                  print("no-conn");

                                  Scaffold.of(context).showSnackBar(SnackBar(
                                    content: Text(
                                        "Please check your Internet Connection"),
                                    duration: Duration(seconds: 3),
                                  ));
                                }
                              }),
                        ),
                      ],
                    ),
                    Container(
                      margin: const EdgeInsets.only(
                          left: 70.0, right: 80.0, top: 10.0),
                      alignment: Alignment.center,
                      child: Material(
                        color: Colors.white,
                        elevation: 4,
                        borderRadius:  BorderRadius.all(
                          Radius.circular(25.0),
                        ),
                        child: Theme(
                          child: TextFormField(
                            cursorColor: Colors.deepPurple,
                            style: TextStyle(color: Colors.deepPurple),
                            controller: otpEditingContrller,
                            keyboardType: TextInputType.number,
                            validator: (otpEditingContrller) {
                              if (otpEditingContrller.isEmpty &&
                                  validation == true) {
                                return 'Enter valid otp';
                              }
                              return null;
                            },
                            textAlign: TextAlign.center,
                            obscureText: true,
                            decoration: InputDecoration(
                                enabledBorder: const OutlineInputBorder(
                                    borderSide:  BorderSide(
                                        color: Colors.white, width: 0.0)),
                                contentPadding:
                                    EdgeInsets.fromLTRB(10, 10, 10, 10),
                                labelText: 'OTP',
                                border: InputBorder.none),
                          ),
                          data: ThemeData(
                              primaryColor: Colors.deepPurple,
                              hintColor: Colors.deepPurple),
                        ),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 20.0),
                      alignment: Alignment.center,
                      child: MaterialButton(
                        minWidth: 100,
                        shape:  RoundedRectangleBorder(
                            borderRadius:  BorderRadius.circular(20.0)),
                        color: Colors.lightBlueAccent,
                        onPressed: () async {
                          var connectivityResult =
                              await (Connectivity().checkConnectivity());

                          if (connectivityResult == ConnectivityResult.mobile ||
                              connectivityResult == ConnectivityResult.wifi) {
                            if (validation == false)
                              setState(() {
                                validation = true;
                              });

                            if (_formKey.currentState.validate()) {
                              checkotp(context,
                                      mobileEditingContrller.text.toString())
                                  .then((response)  {
                                    
                                        if (response.otp ==
                                            otpEditingContrller.text)
                                          {
                                            print("login success");
                                          
                                            var storageInstance =
                                            locator<LocalStorageService>();

                                        storageInstance.saveToDisk(
                                            Strings.userId,response.userId
                                           );
                                             storageInstance.saveToDisk(
                                            Strings.loggedIn,Strings.True
                                           );
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                CityList.routeName,
                                                (Route<dynamic> route) => false);
                                          }
                                        else
                                          {
                                            print(
                                                "something went wrong please try again later  ");
                                          }
                                      });
                            }
                          } else {
                            print("no-conn");

                            Scaffold.of(context).showSnackBar(SnackBar(
                              content:
                                  Text("Please check your Internet Connection"),
                              duration: Duration(seconds: 3),
                            ));
                          }
                        },
                        child: Text(
                          'Login',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    ));
  }
}
