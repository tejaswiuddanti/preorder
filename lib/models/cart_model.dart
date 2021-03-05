import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:preorder_flutter/models/restaurant_items_model.dart';

import 'hotels_list_model.dart';

class CartModel {
  CartModel(this.addedItem, this.itemCount);
  ResItem addedItem;
  int itemCount;
  
    Map<String, dynamic> toJson() => {
        "addedItem": addedItem.toJson(),
        "itemCount": itemCount,
    };
}
String bookingModelToJson(BookingModel data) => json.encode(data.toJson());
class BookingModel {
  List<CartModel> cartItems;
  String transactionId ;
  HotelsList hotel;
  double totalAmount;
  int noOfPeople;
  DateTime bookedTime;
  int userId;
  BookingModel(
      {
      @required this.cartItems,
      @required this.transactionId,
      @required this.hotel,
      @required this.bookedTime,
      @required this.noOfPeople,
      @required this.totalAmount,
      @required this.userId});



        Map<String, dynamic> toJson() => {
        "cartItems": List<dynamic>.from(cartItems.map((x) => x.toJson())),
        "transactionId":transactionId,
        "hotel": hotel,
        "bookedTime": bookedTime.toString(),
        "noOfPeople":noOfPeople,
        "totalAmount":totalAmount,
        "userId":userId
    };
}
