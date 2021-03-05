import 'dart:async';

import 'package:flutter/material.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';
import 'package:preorder_flutter/ui_screens/bottom_navigation_page_ui.dart';
import 'package:preorder_flutter/ui_screens/city_list_ui.dart';
import 'package:preorder_flutter/ui_screens/login_ui.dart';
import 'package:preorder_flutter/utils/strings.dart';

class Splash extends StatefulWidget {
 
  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
   
    super.initState();
    fetchData();
   

  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(body: Text('hello'));
  }









  Future fetchData() async {
    var _duration =  Duration(seconds: 1);
    return  Timer(_duration, navigate);
  }


  void navigate() {
    var storageInstance = locator<LocalStorageService>();
    var loginStatus=storageInstance.getFromDisk(Strings.loggedIn)??Strings.False;
    print(loginStatus);
    // if (loginStatus==Strings.True){
      var cityStatus=storageInstance.getFromDisk(Strings.isCitySelected)??Strings.False;

      (cityStatus==Strings.True)?Navigator.of(context).pushReplacementNamed(BottomNavigationPage.routeName):
      Navigator.of(context).pushReplacementNamed(CityList.routeName);

    // }
    // else
    //   {Navigator.of(context).pushReplacementNamed(Login.routeName);}
  }
}
