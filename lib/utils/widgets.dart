import 'package:flutter/material.dart';
import 'package:preorder_flutter/ui_screens/bottom_navigation_page_ui.dart';
import 'package:preorder_flutter/ui_screens/cart_ui.dart';
import 'package:preorder_flutter/ui_screens/city_list_ui.dart';
import 'package:preorder_flutter/ui_screens/history_ui.dart';
import 'package:preorder_flutter/ui_screens/home.dart';
import 'package:preorder_flutter/ui_screens/login_ui.dart';
import 'package:preorder_flutter/ui_screens/order_details_history_ui.dart';
import 'package:preorder_flutter/ui_screens/profile_ui.dart';
import 'package:preorder_flutter/ui_screens/restaurant_items_ui.dart';
import 'package:preorder_flutter/ui_screens/splash_ui.dart';

class Widgets {
  static Widget HOME = Home();
  static Widget BOTTOMNAVIGATIONPAGE = BottomNavigationPage();
  static Widget RESTAURANTITEMS = RestaurantItemsScreen();
  static Widget CARTSCREEN = CartScreen();
  static Widget CITYLIST = CityList();
  static Widget SPLASH = Splash();
  static Widget PROFILE = Profile();
  static Widget HISTORY=HistoryScreen();
  static Widget ORDERDETAILS=OrderDetailsHistory();
  static Widget LOGIN=Login();
}
