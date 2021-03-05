// To parse this JSON data, do
//
//     final fetchCity = fetchCityFromJson(jsonString);

import 'dart:convert';

FetchCity fetchCityFromJson(String str) => FetchCity.fromJson(json.decode(str));

String fetchCityToJson(FetchCity data) => json.encode(data.toJson());

String areaToJson(AreasList data)=>json.encode(data.toJson());

AreasList areaFromJson(String str)=>AreasList.fromJson(json.decode(str));

class FetchCity {
    List<AreasList> areasList;
    String message;
    String status;

    FetchCity({
        this.areasList,
        this.message,
        this.status,
    });

    factory FetchCity.fromJson(Map<String, dynamic> json) => FetchCity(
        areasList: List<AreasList>.from(json["areas_list"].map((x) => AreasList.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "areas_list": List<dynamic>.from(areasList.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class AreasList {
    String locationId;
    String areaName;
    String city;
    String cityImagePath;

    AreasList({
        this.locationId,
        this.areaName,
        this.city,
        this.cityImagePath,
    });

    factory AreasList.fromJson(Map<String, dynamic> json) => AreasList(
        locationId: json["locationId"],
        areaName: json["areaName"],
        city: json["city"],
        cityImagePath: json["cityImagePath"],
    );

    Map<String, dynamic> toJson() => {
        "locationId": locationId,
        "areaName": areaName,
        "city": city,
        "cityImagePath": cityImagePath,
    };
}