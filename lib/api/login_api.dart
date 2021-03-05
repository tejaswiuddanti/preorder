import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:preorder_flutter/models/login_model.dart';
import 'package:preorder_flutter/utils/strings.dart';
import 'package:toast/toast.dart';

final String verificationpoint = Strings.baseurl + "/sample_otp_check.php";
final String login = Strings.baseurl + "/login.php";
String status = '';

setStatus(String message) {
  status = message;
}

Future otpgnerator(context, String mobileEditingContrller) async {
  try {
    final response = await http.post(verificationpoint, body: {
      "mobile": mobileEditingContrller.toString(),
    });
    print(response.body);

    String message = json.decode(response.body)['message'];
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    return Otp.fromJson(json.decode(response.body));
  } catch (e) {
    print(e);
  }
}

Future checkotp(context, String mobileEditingController) async {
  try {
    final response = await http.post(login, body: {
      "mobile": mobileEditingController.toString(),
    });
    print(response.body);

    String message = json.decode(response.body)['message'];
    Toast.show(message, context,
        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

    return Login1.fromJson(json.decode(response.body));
  } catch (e) {
    print(e);
  }
}
