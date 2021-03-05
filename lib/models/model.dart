// // To parse this JSON data, do
// //
// //     final hotelMenu = hotelMenuFromJson(jsonString);

// import 'dart:convert';

// HotelMenu hotelMenuFromJson(String str) => HotelMenu.fromJson(json.decode(str));

// String hotelMenuToJson(HotelMenu data) => json.encode(data.toJson());

// class HotelMenu {
//     List<String> resTypes;
//     List<List<String>> resItems;
//     String message;
//     String status;

//     HotelMenu({
//         this.resTypes,
//         this.resItems,
//         this.message,
//         this.status,
//     });

//     factory HotelMenu.fromJson(Map<String, dynamic> json) => HotelMenu(
//         resTypes: List<String>.from(json["res_types"].map((x) => x)),
//         resItems: List<List<String>>.from(json["res_items"].map((x) => List<String>.from(x.map((x) => x)))),
//         message: json["message"],
//         status: json["status"],
//     );

//     Map<String, dynamic> toJson() => {
//         "res_types": List<dynamic>.from(resTypes.map((x) => x)),
//         "res_items": List<dynamic>.from(resItems.map((x) => List<dynamic>.from(x.map((x) => x)))),
//         "message": message,
//         "status": status,
//     };
// }
