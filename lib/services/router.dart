import 'package:flutter/material.dart';
import 'package:preorder_flutter/ui_screens/bottom_navigation_page_ui.dart';
import 'package:preorder_flutter/ui_screens/cart_ui.dart';
import 'package:preorder_flutter/ui_screens/city_list_ui.dart';
import 'package:preorder_flutter/ui_screens/home.dart';
import 'package:preorder_flutter/ui_screens/restaurant_items_ui.dart';
import 'package:preorder_flutter/utils/widgets.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case BottomNavigationPage.routeName:
        return MaterialPageRoute(builder: (_) => Widgets.BOTTOMNAVIGATIONPAGE);
      case RestaurantItemsScreen.routeName:
      var data=settings.arguments;
        return MaterialPageRoute(builder: (_) => Widgets.RESTAURANTITEMS);
      case CartScreen.routeName:
        return MaterialPageRoute(builder: (_) => Widgets.CARTSCREEN,);
      case Home.routeName:
        return MaterialPageRoute(builder: (_) => Widgets.HOME);
      case CityList.routeName:
        return MaterialPageRoute(builder: (_) => Widgets.CITYLIST);
    }
  }
}
