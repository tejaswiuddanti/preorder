import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:preorder_flutter/models/city_list_model.dart';
import 'package:preorder_flutter/models/hotels_list_model.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';
import 'package:preorder_flutter/utils/strings.dart';

Future fetchHotelsList() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile ||
      connectivityResult == ConnectivityResult.wifi) {
    String url = Strings.baseurl + 'fetch_hotels_list.php';
    var storageInstance = locator<LocalStorageService>();
    AreasList city =
        areaFromJson(storageInstance.getFromDisk(Strings.userCity));

    try {
      var response = await http
          .post(url, body: {'location': city.city}).timeout(
              Duration(seconds: 20), onTimeout: () {
        throw SocketException(Strings.poorNetworkMessage);
      });
      print(response.body);
      if (response.statusCode == 200) {
        HotelListModel hotelsData =
            await compute(hotelListModelFromJson, response.body);
        if (hotelsData.status.toLowerCase() == 'true') {
          print(hotelsData);
          return hotelsData;
        } else {
          return Strings.somethingWentWrongError;
        }
      } else {
        return Strings.somethingWentWrongError;
      }
    } catch (exception) {
      return exception;
    }
  } else {
    return Strings.noNetworkMessage;
  }
}
