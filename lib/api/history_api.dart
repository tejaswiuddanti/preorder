import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:preorder_flutter/models/orders_history_model.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';
import 'package:preorder_flutter/utils/strings.dart';
import 'package:http/http.dart' as http;

Future fetchHistrory() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    String url = Strings.baseurl + 'users_orders_history.php';

    var storageInstance = locator<LocalStorageService>();
    var userId = storageInstance.getFromDisk(Strings.userId);

    try {
      var response = await http.post(url, body: {'userId': userId}).timeout(
          Duration(seconds: 20), onTimeout: () {
        throw SocketException(Strings.poorNetworkMessage);
      });
      print(response.body);
      if (response.statusCode == 200) {
        var ordersHistory = ordersHistoryModelFromJson(response.body);
        if (ordersHistory.status.toLowerCase() == 'true') {
          return ordersHistory.orders;
        } else {
          print(121212);
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
    
  }
}
