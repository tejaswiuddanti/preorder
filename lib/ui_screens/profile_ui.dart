import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:preorder_flutter/api/profile_api.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';
import 'package:preorder_flutter/utils/strings.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> with SingleTickerProviderStateMixin {
  bool _status = true;
  FocusNode _focusNode;
  String newName;
  File file;
  String image;

  Future future;
  @override
  void initState() {
    future = fetchProfile();
    super.initState();
  }

  TextEditingController name;
  TextEditingController email;
  TextEditingController mobileNumber;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          decoration: BoxDecoration(),
          child: FutureBuilder(
            future: future,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return Center(child: CircularProgressIndicator());
                case ConnectionState.none:
                  return Center(
                      child: Column(children: <Widget>[
                    Text("please Check Internet Connection"),
                    FlatButton(
                      child: Text("Retry"),
                      onPressed: () {
                        setState(() {
                          future = fetchProfile();
                        });
                      },
                    )
                  ]));
                case ConnectionState.done:
                  if (snapshot.hasData) {
                    {
                      name =  TextEditingController(
                          text: snapshot.data.profileData[0].name);
                      email = TextEditingController(
                          text: snapshot.data.profileData[0].email);
                      mobileNumber = TextEditingController(
                          text: snapshot.data.profileData[0].mobileNumber);
                          image=snapshot.data.profileData[0].imageLocation;
                    }

                    return Container(
                      color: Colors.white,
                      child: ListView(
                        children: <Widget>[
                          Column(
                            children: <Widget>[
                              Container(
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 25.0),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
                                              children: <Widget>[
                                                // Container(
                                                //   color: Colors.blueGrey,
                                                //   child: Center(
                                                //     child: Stack(
                                                //       children: <Widget>[
                                                //         // CircleAvatar(
                                                //         //   // backgroundImage:
                                                //         //   //     NetworkImage(image),
                                                //         //   minRadius: 30,
                                                //         //   maxRadius: 60,
                                                //         // ),
                                                //         // Padding(
                                                //         //   padding:
                                                //         //       EdgeInsets.only(
                                                //         //           top: 80.0,
                                                //         //           left: 80),

                                                //         //   child:
                                                //         //       FloatingActionButton(
                                                //         //       mini:true,
                                                //         //         backgroundColor: Colors.blueGrey,
                                                //         //           child: Icon(Icons
                                                //         //               .camera_enhance),
                                                //         //           onPressed:
                                                //         //               () {
                                                //         //            showChoiceDialog(context);
                                                //         //           }),
                                                //         // ),
                                                //       ],
                                                //     ),
                                                //   ),
                                                // ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Text(
                                                              'Parsonal Information',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      18.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            _status
                                                                ? _getEditIcon()
                                                                : Container(),
                                                          ],
                                                        )
                                                      ],
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Text(
                                                              "Name",
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 2.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: TextField(
                                                            controller: name,
                                                            decoration:
                                                                const InputDecoration(),
                                                            enabled: !_status,
                                                            autofocus: !_status,
                                                            onChanged:
                                                                (String name) {
                                                              newName = name;
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                // Padding(
                                                //     padding: EdgeInsets.only(
                                                //         left: 25.0,
                                                //         right: 25.0,
                                                //         top: 25.0),
                                                //     child: Row(
                                                //       mainAxisSize:
                                                //           MainAxisSize.max,
                                                //       children: <Widget>[
                                                //         Column(
                                                //           mainAxisAlignment:
                                                //               MainAxisAlignment
                                                //                   .start,
                                                //           mainAxisSize:
                                                //               MainAxisSize.min,
                                                //           children: <Widget>[
                                                // //             Text(
                                                // //               'Email ID',
                                                // //               style: TextStyle(
                                                // //                   fontSize:
                                                // //                       16.0,
                                                // //                   fontWeight:
                                                // //                       FontWeight
                                                // //                           .bold),
                                                // //             ),
                                                // //           ],
                                                // //         ),
                                                // //       ],
                                                // //     )),
                                                // // Padding(
                                                // //     padding: EdgeInsets.only(
                                                // //         left: 25.0,
                                                // //         right: 25.0,
                                                // //         top: 2.0),
                                                // //     child: Row(
                                                // //       mainAxisSize:
                                                // //           MainAxisSize.max,
                                                // //       children: <Widget>[
                                                // //         Flexible(
                                                // //           child: TextField(
                                                // //             controller: email,
                                                // //             decoration:
                                                // //                 const InputDecoration(
                                                // //                     // hintText:
                                                // //                     //     "Enter Email ID"
                                                // //                     ),
                                                // //             enabled: false,
                                                // //           ),
                                                //         // ),
                                                //       ],
                                                //     )
                                                //     ),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 25.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          children: <Widget>[
                                                            Text(
                                                              'Mobile',
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      16.0,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    )),
                                                Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 25.0,
                                                        right: 25.0,
                                                        top: 2.0),
                                                    child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.max,
                                                      children: <Widget>[
                                                        Flexible(
                                                          child: TextField(
                                                            controller:
                                                                mobileNumber,
                                                            enabled: false,
                                                          ),
                                                        ),
                                                      ],
                                                    )),
                                                !_status
                                                    ? _getActionButtons()
                                                    : Container(),
                                              ],
                                            ),
                                          )
                                        ]),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    );
                  }
                  return null;
                default:
                  return Text("error");
              }
            },
          )),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    _focusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 45.0),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Save"),
                textColor: Colors.white,
                color: Colors.green,
                onPressed: () {
                  print(newName);
                  var storageInstance = locator<LocalStorageService>();
  var userId=storageInstance.getFromDisk(Strings.userId);

                  http.post(
                      "http://115.98.3.215:90/preorder_flutter/change_name.php",
                      body: {
                        
                        'userId':userId,
                        'name': newName,
                      }).then((result) {
                    setState(() {
                      future = fetchProfile();
                    });
                  });
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: RaisedButton(
                child: Text("Cancel"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(FocusNode());
                  });
                },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return GestureDetector(
      child: CircleAvatar(
        backgroundColor: Colors.blueGrey,
        radius: 14.0,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
      onTap: () {
        setState(() {
        
          _status = false;
        });
      },
    );
  }

  static openGallery(BuildContext context) async {
    File file;
    file = await ImagePicker.pickImage(
        source: ImageSource.camera, imageQuality: 55);

    String base64Image = base64Encode(file.readAsBytesSync());
    http.post("http://115.98.3.215:90/preorder_flutter/change_profile.php", body: {
      "_image": base64Image,
    }).then((result) {
    
    }).catchError((error) {});
    Navigator.pop(context);
  
  }
  static openCamera(BuildContext context) async {
    File file;
    file = await ImagePicker.pickImage(
        source: ImageSource.gallery, imageQuality: 55);

    String base64Image = base64Encode(file.readAsBytesSync());
    http.post("http://115.98.3.215:90/preorder_flutter/change_profile.php", body: {
      "_image": base64Image,
    }).then((result) {
    
      print(result.body);
    }).catchError((error) {});
     Navigator.pop(context);

  }

  Future<void> showChoiceDialog(BuildContext context){
    return showDialog(context: context,builder: (BuildContext context){
      return AlertDialog(
        title: Text("Select Option"),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              GestureDetector(
                child: Text("Gallery"),
                onTap: ()async{
                  openCamera(context);
                  
                },
              ),
              Padding(padding: EdgeInsets.all(8.0),),
                GestureDetector(
                child: Text("Camera"),
                onTap: (){
                 openGallery(context);
                },
              )
            ],
          ),
        ),
      );
    });
  }
}
