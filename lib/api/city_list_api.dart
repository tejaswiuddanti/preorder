import 'package:http/http.dart' as http;
import 'package:preorder_flutter/models/city_list_model.dart';

Future fetchCity() async {
  try {
    var url = "http://115.98.3.215:90/preorder_flutter/fetch_areas.php";

    var response = await http.post(url, body: {
      
    });
        print(response.body);
    return fetchCityFromJson(response.body);
  } catch (error) {
    print(error);
  }
}
