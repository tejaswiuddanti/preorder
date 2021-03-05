import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:preorder_flutter/models/cart_model.dart';
import 'package:preorder_flutter/models/order_response_model.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';

import 'package:preorder_flutter/utils/strings.dart';
import 'package:http/http.dart' as http;



Future bookOrder(BookingModel bookOrder) async
{
 
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    String url = Strings.baseurl + 'place_order.php';
   
  var bookingJson=bookingModelToJson(bookOrder);
  print(bookingJson);

    try {
      var response = await http
          .post(url, body: {'order':bookingJson}).timeout(
              Duration(seconds: 20), onTimeout: () {
        throw SocketException(Strings.poorNetworkMessage);
      });
      print(response.body);
      if (response.statusCode == 200) {
      return orderResponseFromJson(response.body);
      }
    } catch (exception) {
      print(exception);
    }
  } else {
    throw SocketException(Strings.noNetworkMessage);
  }
}


Future prepareRefund() async
{
 
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    String url = Strings.baseurl + 'refund.php';
   
  var storageInstance = locator<LocalStorageService>();
     var paymentId=   storageInstance.getFromDisk(Strings.paymentId);
     var userId=storageInstance.getFromDisk(Strings.userId);

    try {
      var response = await http
          .post(url, body: {'transactionId':paymentId,
          'userId':userId}).timeout(
              Duration(seconds: 20), onTimeout: () {
        throw SocketException(Strings.poorNetworkMessage);
      });
      print(response.body);
      if (response.statusCode == 200) {
         var storageInstance = locator<LocalStorageService>();
        storageInstance.saveToDisk(
            Strings.PaymentDetailsStoredSucesfully, 'true');
      return Strings.RefundInitiated;
      }
      else {
     return Strings.somethingWentWrongError;
    }
    } catch (exception) {
     return Strings.somethingWentWrongError;
    }
  } else {
    return Strings.noNetworkMessage;
  }
}