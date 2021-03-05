import 'package:http/http.dart' as http;
import 'package:preorder_flutter/models/profile_model.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';
import 'package:preorder_flutter/utils/strings.dart';

Future fetchProfile() async {
  try {
    var url = "http://115.98.3.215:90/preorder_flutter/profile.php";
 var storageInstance = locator<LocalStorageService>();
  var userId=storageInstance.getFromDisk(Strings.userId);

  
    var response = await http.post(url, body: {
      'userId':userId,

    });
    print(response.body);
    return profileFromJson(response.body);
  } catch (error) {
    print(error);
  }
}
