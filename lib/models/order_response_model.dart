// To parse this JSON data, do
//
//     final orderResponse = orderResponseFromJson(jsonString);

import 'dart:convert';

OrderResponse orderResponseFromJson(String str) => OrderResponse.fromJson(json.decode(str));

String orderResponseToJson(OrderResponse data) => json.encode(data.toJson());

class OrderResponse {
    String message;
    String status;
    int orderId;

    OrderResponse({
        this.message,
        this.status,
        this.orderId,
    });

    factory OrderResponse.fromJson(Map<String, dynamic> json) => OrderResponse(
        message: json["message"],
        status: json["status"],
        orderId: json["orderId"],
    );

    Map<String, dynamic> toJson() => {
        "message": message,
        "status": status,
        "orderId": orderId,
    };
}
