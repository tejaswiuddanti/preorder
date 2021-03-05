// To parse this JSON data, do
//
//     final restaurantItems = restaurantItemsFromJson(jsonString);

import 'dart:convert';

RestaurantItems restaurantItemsFromJson(String str) => RestaurantItems.fromJson(json.decode(str));

String restaurantItemsToJson(RestaurantItems data) => json.encode(data.toJson());

class RestaurantItems {
    List<String> resTypes;
    List<List<ResItem>> resItems;
    String message;
    String status;

    RestaurantItems({
        this.resTypes,
        this.resItems,
        this.message,
        this.status,
    });

    factory RestaurantItems.fromJson(Map<String, dynamic> json) => RestaurantItems(
        resTypes: List<String>.from(json["res_types"].map((x) => x)),
        resItems: List<List<ResItem>>.from(json["res_items"].map((x) => List<ResItem>.from(x.map((x) => ResItem.fromJson(x))))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "res_types": List<dynamic>.from(resTypes.map((x) => x)),
        "res_items": List<dynamic>.from(resItems.map((x) => List<dynamic>.from(x.map((x) => x.toJson())))),
        "message": message,
        "status": status,
    };
}

class ResItem {
    String recipeId;
    String categoryId;
    String recipeName;
    Type type;
    String imagePath;
    String description;
    String price;
    String status;
    DateTime modifiedDate;

    ResItem({
        this.recipeId,
        this.categoryId,
        this.recipeName,
        this.type,
        this.imagePath,
        this.description,
        this.price,
        this.status,
        this.modifiedDate,
    });

    factory ResItem.fromJson(Map<String, dynamic> json) => ResItem(
        recipeId: json["recipeId"],
        categoryId: json["categoryId"],
        recipeName: json["recipeName"],
        type: typeValues.map[json["type"]],
        imagePath: json["imagePath"],
        description: json["description"],
        price: json["price"],
        status: json["status"],
        modifiedDate: DateTime.parse(json["modifiedDate"]),
    );

    Map<String, dynamic> toJson() => {
        "recipeId": recipeId,
        "categoryId": categoryId,
        "recipeName": recipeName,
        "type": typeValues.reverse[type],
        "imagePath": imagePath,
        "description": description,
        "price": price,
        "status": status,
        "modifiedDate": modifiedDate.toIso8601String(),
    };
}





enum Type { NON_VEG, VEG }

final typeValues = EnumValues({
    "non-veg": Type.NON_VEG,
    "veg": Type.VEG
});

class EnumValues<T> {
    Map<String, T> map;
    Map<T, String> reverseMap;

    EnumValues(this.map);

    Map<T, String> get reverse {
        if (reverseMap == null) {
            reverseMap = map.map((k, v) => new MapEntry(v, k));
        }
        return reverseMap;
    }
}
