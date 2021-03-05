// import 'package:connectivity/connectivity.dart';
// import 'package:flutter/foundation.dart';
// import 'package:preorder_flutter/models/model.dart';
// import 'package:preorder_flutter/utils/strings.dart';
// import 'package:http/http.dart' as http;



// Future fetchMenu() async {
//   var connectivityResult = await (Connectivity().checkConnectivity());
//   if (connectivityResult == ConnectivityResult.mobile ||
//       connectivityResult == ConnectivityResult.wifi) {
//     String url = Strings.baseurl + 'sample_typesoflist.php';

//     try {
//       var response = await http.post(url, body: {
//         //'location':
//       });
//      print(response.body);
//       if(response.statusCode==200 )
//       {
//       HotelMenu hotelsData=   await compute(hotelMenuFromJson,response.body);
//       if(hotelsData.status.toLowerCase()=='true')
//       { print (hotelsData);
//         return hotelsData;
//       }else
//       {
//         return Strings.somethingWentWrongError;
//       }
//       }
//       else
//       {
//          return Strings.somethingWentWrongError;
//       }
//     } catch (exception) {
//       throw exception;
//     }
//   } else {
//     //throw SocketException(Strings.noNetworkMessage);
//   }
// }

// class SocketException {
// }

