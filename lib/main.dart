import 'package:flutter/material.dart';
import 'package:preorder_flutter/providers/bottom_navigation_provider.dart';
import 'package:preorder_flutter/providers/cart_provider.dart';
import 'package:preorder_flutter/providers/city_list_provider.dart';
import 'package:preorder_flutter/providers/hotels_list_provider.dart';
import 'package:preorder_flutter/providers/loading_provider.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/ui_screens/bottom_navigation_page_ui.dart';
import 'package:preorder_flutter/ui_screens/cart_ui.dart';
import 'package:preorder_flutter/ui_screens/city_list_ui.dart';
import 'package:preorder_flutter/ui_screens/home.dart';
import 'package:preorder_flutter/ui_screens/login_ui.dart';
import 'package:preorder_flutter/ui_screens/order_details_history_ui.dart';
import 'package:preorder_flutter/ui_screens/restaurant_items_ui.dart';
import 'package:preorder_flutter/utils/widgets.dart';
import 'package:provider/provider.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized(); 

  setUpLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          builder: (_) => HotelsListProvider(),
        ),
        ChangeNotifierProvider(
          builder: (_) => CityListProvider(),
        ),
        ChangeNotifierProvider(
          builder: (_) => LoadingProvider(),
        ),
        ChangeNotifierProvider(
          builder: (_) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          builder: (_) => CartProvider(),
        ),
      ],
      child: MaterialApp(
          // onGenerateRoute: Router.generateRoute,
          routes: {
            BottomNavigationPage.routeName: (context) =>
                Widgets.BOTTOMNAVIGATIONPAGE,
            OrderDetailsHistory.routeName: (context) => Widgets.ORDERDETAILS,
            RestaurantItemsScreen.routeName: (context) =>
                Widgets.RESTAURANTITEMS,
            CartScreen.routeName: (context) => Widgets.CARTSCREEN,
            CityList.routeName: (context) => Widgets.CITYLIST,
            Home.routeName: (context) => Widgets.HOME,
            Login.routeName:(context)=>Widgets.LOGIN
          },
          title: 'Flutter Demo',
          theme: ThemeData(
            // This is the theme of your application.
            //
            // Try running your application with "flutter run". You'll see the
            // application has a blue toolbar. Then, without quitting the app, try
            // changing the primarySwatch below to Colors.green and then invoke
            // "hot reload" (press "r" in the console where you ran "flutter run",
            // or simply save your changes to "hot reload" in a Flutter IDE).
            // Notice that the counter didn't reset back to zero; the application
            // is not restarted.
            primarySwatch: Colors.blueGrey,
          ),
          home: 
        //  Widgets.LOGIN
          Widgets.SPLASH
          //Widgets.CITYLIST
          //Widgets.HOME,
          ),
    );
  }
}
