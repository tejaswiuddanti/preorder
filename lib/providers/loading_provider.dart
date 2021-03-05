import 'package:flutter/material.dart';

class LoadingProvider with ChangeNotifier
{
  bool isloading=false;

  void toogleLoading()
  {
    isloading=!isloading;
    notifyListeners();
  }
}