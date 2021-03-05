// To parse this JSON data, do
//
//     final ordersHistoryModel = ordersHistoryModelFromJson(jsonString);

import 'dart:convert';

OrdersHistoryModel ordersHistoryModelFromJson(String str) => OrdersHistoryModel.fromJson(json.decode(str));

String ordersHistoryModelToJson(OrdersHistoryModel data) => json.encode(data.toJson());

class OrdersHistoryModel {
    List<Order> orders;
    String status;
    String message;

    OrdersHistoryModel({
        this.orders,
        this.status,
        this.message,
    });

    factory OrdersHistoryModel.fromJson(Map<String, dynamic> json) => OrdersHistoryModel(
        orders: List<Order>.from(json["orders"].map((x) => Order.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "orders": List<dynamic>.from(orders.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Order {
    String orderId;
    DateTime orderedDate;
    String personsCount;
    String status;
    String totalAmount;
    String razorpayId;
    String hotelId;
    String adminMessage;
    String locationId;
    String restaurantName;
    String imagePath;
    String city;
    String areaName;

    Order({
        this.orderId,
        this.orderedDate,
        this.personsCount,
        this.status,
        this.totalAmount,
        this.razorpayId,
        this.hotelId,
        this.adminMessage,
        this.locationId,
        this.restaurantName,
        this.imagePath,
        this.city,
        this.areaName,
    });

    factory Order.fromJson(Map<String, dynamic> json) => Order(
        orderId: json["orderId"],
        orderedDate: DateTime.parse(json["orderedDate"]),
        personsCount: json["personsCount"],
        status: json["status"],
        totalAmount: json["totalAmount"],
        razorpayId: json["razorpayId"],
        hotelId: json["hotelId"],
        adminMessage: json["adminMessage"],
        locationId: json["locationId"],
        restaurantName: json["restaurantName"],
        imagePath: json["imagePath"],
        city: json["city"],
        areaName: json["areaName"],
    );

    Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "orderedDate": orderedDate.toIso8601String(),
        "personsCount": personsCount,
        "status": status,
        "totalAmount": totalAmount,
        "razorpayId": razorpayId,
        "hotelId": hotelId,
        "adminMessage": adminMessage,
        "locationId": locationId,
        "restaurantName": restaurantName,
        "imagePath": imagePath,
        "city": city,
        "areaName": areaName,
    };
}
