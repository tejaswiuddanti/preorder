import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:preorder_flutter/models/hotels_list_model.dart';
import 'package:preorder_flutter/models/restaurant_items_model.dart';
import 'package:preorder_flutter/utils/strings.dart';
import 'package:http/http.dart' as http;



Future fetchMenu(HotelsList hotel) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    String url = Strings.baseurl + 'itemtype_items_list.php';

    try {
      var response = await http.post(url, body: {
        'hotelId':hotel.hotelId
      });
     print(response.body);
      if(response.statusCode==200 )
      {
      RestaurantItems restaurantItems=   await compute(restaurantItemsFromJson,response.body);
      if(restaurantItems.status.toLowerCase()=='true')
      { print (restaurantItems.resItems);
        return restaurantItems;
      }else
      {
        return Strings.somethingWentWrongError;
      }
      }
      else
      {
         return Strings.somethingWentWrongError;
      }
    } catch (exception) {
print(exception);    }
  } else {
    //throw SocketException(Strings.noNetworkMessage);
  }
}


