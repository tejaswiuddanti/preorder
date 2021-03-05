import 'dart:io';

import 'package:preorder_flutter/models/city_list_model.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';
import 'package:preorder_flutter/utils/strings.dart';

Future getDetails() async {
  sleep(Duration(seconds: 1));
  var storageInstance = locator<LocalStorageService>();
  AreasList city = areaFromJson(storageInstance.getFromDisk(Strings.userCity));

 return  city.city!=null?true:false;
}
