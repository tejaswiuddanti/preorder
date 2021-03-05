import 'dart:convert';

Otp otpFromJson(String str) => Otp.fromJson(json.decode(str));


class Otp {
String status;
String message;

Otp({
this.status,
this.message,
});

factory Otp.fromJson(Map<String, dynamic> json) => Otp(
status: json["status"],
message: json["message"],
);
}








Login1 login1FromJson(String str) => Login1.fromJson(json.decode(str));



class Login1 {
String otp;
String userId;

Login1({
this.otp,
this.userId,
});

factory Login1.fromJson(Map<String, dynamic> json) => Login1(
otp: json["otp"],
userId: json["userId"],
);


}
