import 'package:flutter/cupertino.dart';

class BottomNavigationProvider with ChangeNotifier
{
 int  index=0;
int get getIndex=>index;

 setIndex(int _index)
 {
   index=_index;
   print(index);
   notifyListeners();
 } 
}