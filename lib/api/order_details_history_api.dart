import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:preorder_flutter/models/order_details_history_model.dart';
import 'package:preorder_flutter/utils/strings.dart';
import 'package:http/http.dart' as http;


Future fetchOrderDetails(String orderId)async 
{
    var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    String url = Strings.baseurl + 'order_details_history.php';
  

    try {
      var response = await http
          .post(url, body: {'orderId': orderId}).timeout(
              Duration(seconds: 20), onTimeout: () {
        throw SocketException(Strings.poorNetworkMessage);
      });
      print(response.body);
      if (response.statusCode == 200) {
       
      var orderDetails=orderDetailsHistoryModelFromJson(response.body);
      if(orderDetails.status.toLowerCase()=='true'){

        return orderDetails;
      }
      else {
          return Strings.somethingWentWrongError;
        }

         
        } else {
           print(13131331);
          return Strings.somethingWentWrongError;
        }
     
    } catch (exception) {
      return exception;
    }
  } else {
    return Strings.noNetworkMessage;
  }
}