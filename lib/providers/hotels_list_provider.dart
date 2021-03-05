import 'package:flutter/cupertino.dart';
import 'package:preorder_flutter/models/hotels_list_model.dart';

class HotelsListProvider with ChangeNotifier
{
  List<HotelsList> hotelsList=List();
 List<HotelsList> get gethotelsList =>hotelsList;

  setHotels(List<HotelsList> _hotelsList)
  {
    hotelsList=_hotelsList;
  //  notifyListeners();
  }

  filter(String name){

  }


}