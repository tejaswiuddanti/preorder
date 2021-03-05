// To parse this JSON data, do
//
//     final orderDetailsHistoryModel = orderDetailsHistoryModelFromJson(jsonString);

import 'dart:convert';

OrderDetailsHistoryModel orderDetailsHistoryModelFromJson(String str) => OrderDetailsHistoryModel.fromJson(json.decode(str));

String orderDetailsHistoryModelToJson(OrderDetailsHistoryModel data) => json.encode(data.toJson());

class OrderDetailsHistoryModel {
    List<Ordered> ordered;
    List<Category> categories;
    String status;
    String message;

    OrderDetailsHistoryModel({
        this.ordered,
        this.categories,
        this.status,
        this.message,
    });

    factory OrderDetailsHistoryModel.fromJson(Map<String, dynamic> json) => OrderDetailsHistoryModel(
        ordered: List<Ordered>.from(json["ordered"].map((x) => Ordered.fromJson(x))),
        categories: List<Category>.from(json["categories"].map((x) => Category.fromJson(x))),
        status: json["status"],
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "ordered": List<dynamic>.from(ordered.map((x) => x.toJson())),
        "categories": List<dynamic>.from(categories.map((x) => x.toJson())),
        "status": status,
        "message": message,
    };
}

class Category {
    String categoryId;
    String categoryName;

    Category({
        this.categoryId,
        this.categoryName,
    });

    factory Category.fromJson(Map<String, dynamic> json) => Category(
        categoryId: json["categoryId"],
        categoryName: json["categoryName"],
    );

    Map<String, dynamic> toJson() => {
        "categoryId": categoryId,
        "categoryName": categoryName,
    };
}

class Ordered {
    String orderId;
    String categoryId;
    String recipeName;
    String type;
    String price;
    String itemCount;
    String itemAmount;
    String categoryName;

    Ordered({
        this.orderId,
        this.categoryId,
        this.recipeName,
        this.type,
        this.price,
        this.itemCount,
        this.itemAmount,
        this.categoryName,
    });

    factory Ordered.fromJson(Map<String, dynamic> json) => Ordered(
        orderId: json["orderId"],
        categoryId: json["categoryId"],
        recipeName: json["recipeName"],
        type: json["type"],
        price: json["price"],
        itemCount: json["itemCount"],
        itemAmount: json["itemAmount"],
        categoryName: json["categoryName"],
    );

    Map<String, dynamic> toJson() => {
        "orderId": orderId,
        "categoryId": categoryId,
        "recipeName": recipeName,
        "type": type,
        "price": price,
        "itemCount": itemCount,
        "itemAmount": itemAmount,
        "categoryName": categoryName,
    };
}
