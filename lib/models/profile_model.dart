// To parse this JSON data, do
//
//     final profile = profileFromJson(jsonString);

import 'dart:convert';

Profile profileFromJson(String str) => Profile.fromJson(json.decode(str));

String profileToJson(Profile data) => json.encode(data.toJson());

class Profile {
    List<ProfileDatum> profileData;
    String message;
    String status;

    Profile({
        this.profileData,
        this.message,
        this.status,
    });

    factory Profile.fromJson(Map<String, dynamic> json) => Profile(
        profileData: List<ProfileDatum>.from(json["profile_data"].map((x) => ProfileDatum.fromJson(x))),
        message: json["message"],
        status: json["status"],
    );

    Map<String, dynamic> toJson() => {
        "profile_data": List<dynamic>.from(profileData.map((x) => x.toJson())),
        "message": message,
        "status": status,
    };
}

class ProfileDatum {
    String userId;
    String name;
    String email;
    String mobileNumber;
    String password;
    String otp;
    String imageLocation;
    DateTime createdDate;
    DateTime modifiedDate;

    ProfileDatum({
        this.userId,
        this.name,
        this.email,
        this.mobileNumber,
        this.password,
        this.otp,
        this.imageLocation,
        this.createdDate,
        this.modifiedDate,
    });

    factory ProfileDatum.fromJson(Map<String, dynamic> json) => ProfileDatum(
        userId: json["userId"],
        name: json["name"],
        email: json["email"],
        mobileNumber: json["mobileNumber"],
        password: json["password"],
        otp: json["otp"],
        imageLocation: json["imageLocation"],
        createdDate: DateTime.parse(json["createdDate"]),
        modifiedDate: DateTime.parse(json["modifiedDate"]),
    );

    Map<String, dynamic> toJson() => {
        "userId": userId,
        "name": name,
        "email": email,
        "mobileNumber": mobileNumber,
        "password": password,
        "otp": otp,
        "imageLocation": imageLocation,
        "createdDate": createdDate.toIso8601String(),
        "modifiedDate": modifiedDate.toIso8601String(),
    };
}
