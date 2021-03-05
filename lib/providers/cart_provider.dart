import 'package:flutter/foundation.dart';
import 'package:preorder_flutter/models/cart_model.dart';
import 'package:preorder_flutter/models/hotels_list_model.dart';
import 'package:preorder_flutter/models/restaurant_items_model.dart';

class CartProvider with ChangeNotifier {
  List<CartModel> cartItems = List();
  HotelsList hotel;
  double totalAmount = 0.0;
  int noOfPeople = 1;
  DateTime bookedTime = DateTime.now();
  bool isBookedTimeValid = false;

  Set<String> addedItemsIds = Set();

  setHotel(HotelsList _hotel) {
    hotel = _hotel;
  }

  addItem(ResItem resItem) { 
    cartItems.add(CartModel(resItem, 1));
    totalAmount += double.parse(resItem.price);
    addedItemsIds.add(resItem.recipeId);
    print('added Item: ' + resItem.recipeId.toString());
    notifyListeners();
  }

  removeItem(ResItem resItem) {
    cartItems.removeWhere((item) => item.addedItem == resItem);
    addedItemsIds.remove(resItem.recipeId);
    totalAmount -= double.parse(resItem.price);
    print('hotel  ' + hotel.hotelId);
    print('removed Item: ' + resItem.recipeId.toString());
    notifyListeners();
  }

  increaseItemCount(int index) {
    cartItems[index].itemCount++;
    totalAmount += double.parse(cartItems[index].addedItem.price);
    print(cartItems[index].itemCount);
    notifyListeners();
  }

  decreaseItemCount(int index) {
    cartItems[index].itemCount--;
    totalAmount -= double.parse(cartItems[index].addedItem.price);
    if (cartItems[index].itemCount == 0) {
      addedItemsIds.remove(cartItems[index].addedItem.recipeId);
      cartItems.removeAt(index);
    }
    notifyListeners();
  }

  changeBookedTime(DateTime _bookedTime) {
    bookedTime = _bookedTime;
    print(_bookedTime);
    notifyListeners();
  }

  toogleTimeValidation(bool _isBookingTimeValid) {
    isBookedTimeValid = _isBookingTimeValid;
    notifyListeners();
  }

  changeNoOfPeople(int _people) {
    noOfPeople = _people;
    notifyListeners();
  }

  clearCart() {
    cartItems.clear();
    addedItemsIds.clear();
    totalAmount = 0.0;
    noOfPeople = 1;
    bookedTime = DateTime.now();
    isBookedTimeValid = false;
    notifyListeners();
  }
}
