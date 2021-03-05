import 'package:flutter/foundation.dart';
import 'package:preorder_flutter/models/city_list_model.dart';
class CityListProvider with ChangeNotifier{
List<AreasList> areaList= List();
List<AreasList> get getareaList=>areaList;

getData(List <AreasList> _areaList){
 areaList= _areaList;
notifyListeners();
}
}