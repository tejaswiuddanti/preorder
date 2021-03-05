import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:preorder_flutter/api/cart_api.dart';
import 'package:preorder_flutter/models/cart_model.dart';
import 'package:preorder_flutter/providers/bottom_navigation_provider.dart';
import 'package:preorder_flutter/providers/cart_provider.dart';
import 'package:preorder_flutter/providers/loading_provider.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';
import 'package:preorder_flutter/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import 'bottom_navigation_page_ui.dart';

class CartScreen extends StatefulWidget {
  static const routeName = '/cartscreen';
  @override
  _CartScreenState createState() => _CartScreenState();
}

Razorpay _razorpay;
const platform =  MethodChannel("razorpay_flutter");
BookingModel order;
CartProvider cartProvider;
LoadingProvider loadingProvider;

class _CartScreenState extends State<CartScreen> {
  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  @override
  Widget build(BuildContext context) {
    cartProvider = Provider.of<CartProvider>(context, listen: false);
    loadingProvider = Provider.of<LoadingProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        body: Consumer<CartProvider>(builder: (context, data, child) {
          print('cart items length in cart page: ' +
              data.cartItems.length.toString());

          return (data.cartItems.isEmpty)
              ? Center(child: Text('Sorry No Items added to your Cart'))
              : CustomScrollView(
                  slivers: <Widget>[
                    SliverAppBar(
                        pinned: true,
                        expandedHeight: 200,
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text('${data.hotel.restaurantName}'),
                          background: FadeInImage.assetNetwork(
                            fit: BoxFit.cover,
                            image: data.hotel.imagePath,
                            placeholder:
                                'assets/images/image_loading_placeholder.png',
                          ),
                        )),
                    SliverFillRemaining(
                      child: ListView(
                        children: <Widget>[
                          ListView.builder(
                            shrinkWrap: true,
                            physics: ClampingScrollPhysics(),
                            itemCount: data.cartItems.length,
                            itemBuilder: (BuildContext context, int index) {
                              return ListTile(
                                leading: Padding(
                                  padding: const EdgeInsets.all(3.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: FadeInImage.assetNetwork(
                                      image: data
                                          .cartItems[index].addedItem.imagePath,
                                      placeholder:
                                          'assets/images/image_loading_placeholder.png',
                                    ),
                                  ),
                                ),
                                title: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                        flex: 15,
                                        child: Text(data.cartItems[index]
                                            .addedItem.recipeName)),
                                    Flexible(
                                      flex: 4,
                                      child: FlatButton(
                                        child: Icon(Icons.add,
                                            color: Colors.green),
                                        onPressed: () {
                                          data.increaseItemCount(index);
                                        },
                                      ),
                                    ),
                                    Flexible(
                                        flex: 3,
                                        child: Text(data
                                            .cartItems[index].itemCount
                                            .toString())),
                                    Flexible(
                                      flex: 4,
                                      child: FlatButton(
                                        child: Icon(
                                          Icons.remove,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          data.decreaseItemCount(index);
                                        },
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Row(
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.all(18.0),
                                child: Text(
                                  'Book at : ',
                                  style: TextStyle(fontSize: 20),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(18.0),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Container(
                                        height: 80,
                                        decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Colors.blueGrey)),
                                        child: CupertinoDatePicker(
                                          mode: CupertinoDatePickerMode.time,
                                          initialDateTime: data.bookedTime
                                                  .isAfter(DateTime.now())
                                              ? data.bookedTime
                                              : DateTime.now(),
                                          onDateTimeChanged: (DateTime value) {
                                            DateFormat dateFormat =
                                                DateFormat.Hm();
                                            var now = DateTime.now();
                                            DateTime close = dateFormat
                                                .parse(data.hotel.endTime);

                                            DateTime open = dateFormat
                                                .parse(data.hotel.startTime);
                                            open = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                open.hour,
                                                open.minute);
                                            close = DateTime(
                                                now.year,
                                                now.month,
                                                now.day,
                                                close.hour,
                                                close.minute);
                                            print('closing time' +
                                                close.toIso8601String());
                                            if (value.isAfter(now
                                                    .add(Duration(hours: 1))) &&
                                                value.isBefore(close) &&
                                                value.isAfter(open)) {
                                              data.changeBookedTime(value);
                                              data.toogleTimeValidation(true);
                                            } else{
                                              data.toogleTimeValidation(false);}
                                          },
                                        )),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Text('Number of people'),
                          Slider(
                            min: 1,
                            max: 10,
                            label: data.noOfPeople.toString(),
                            onChanged: (double value) {
                              data.changeNoOfPeople(value.toInt());
                            },
                            value: double.parse(data.noOfPeople.toString()),
                            divisions: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Chip(
                                    label: Text('Total Items: ' +
                                        data.cartItems.length.toString() +
                                        '       People: ' +
                                        data.noOfPeople.toString())),
                              ],
                            ),
                          ),
                          Chip(
                            label: Text('Total Cost: ${data.totalAmount}'),
                            backgroundColor: Colors.orangeAccent,
                          ),
                          Consumer<LoadingProvider>(
                              builder: (context, loadingData, child) {
                            return loadingData.isloading
                                ? Center(child: CircularProgressIndicator())
                                : Center(
                                    child: data.isBookedTimeValid
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: <Widget>[
                                                ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  clipBehavior: Clip.antiAlias,
                                                  child: RaisedButton(
                                                    color:
                                                        Colors.deepOrangeAccent,
                                                    child: Text(
                                                      'Place order',
                                                      style: TextStyle(
                                                          color: Colors.white),
                                                    ),
                                                    onPressed: () async {
                                                      DateFormat dateFormat =
                                                          DateFormat.Hm();
                                                      var now = DateTime.now();
                                                      DateTime close =
                                                          dateFormat.parse(data
                                                              .hotel.endTime);
                                                      close = DateTime(
                                                          now.year,
                                                          now.month,
                                                          now.day,
                                                          close.hour,
                                                          close.minute);
                                                      print(close);
                                                      if (data.bookedTime
                                                          .isBefore(now)) {
                                                        data.toogleTimeValidation(
                                                            false);
                                                      } else {
                                                        var storageInstance =
                                                            locator<
                                                                LocalStorageService>();
                                                        var userId =
                                                            storageInstance
                                                                .getFromDisk(
                                                                    Strings
                                                                        .userId);

                                                        order = BookingModel(
                                                            bookedTime:
                                                                data.bookedTime,
                                                            transactionId:
                                                                "xxxxxx",
                                                            cartItems:
                                                                data.cartItems,
                                                            hotel: data.hotel,
                                                            noOfPeople:
                                                                data.noOfPeople,
                                                            totalAmount: data
                                                                .totalAmount,
                                                            userId: int.parse(
                                                                userId));
                                                        afterpay();
                                                        //  openCheckout(order);

                                                      }
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                        : Text(
                                            'Please select Valid Time greater than 1 hr from now'),
                                  );
                          })
                        ],
                      ),
                    )
                  ],
                );
        }),
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  Future afterpay() async {
    loadingProvider.toogleLoading();
    bookOrder(order).then((response) {
      loadingProvider.toogleLoading();
      print(response.status);
      if (response.status.toLowerCase() == 'true') {
        var storageInstance = locator<LocalStorageService>();
        storageInstance.saveToDisk(
            Strings.PaymentDetailsStoredSucesfully, 'true');
        cartProvider.clearCart();
        Provider.of<BottomNavigationProvider>(context, listen: false)
            .setIndex(3);
        Navigator.pushNamedAndRemoveUntil(context,
            BottomNavigationPage.routeName, (Route<dynamic> route) => false);
      } else {
        prepareRefund().then((response) {
          loadingProvider.toogleLoading();
          if (response == Strings.somethingWentWrongError) {
            Fluttertoast.showToast(
                msg: Strings.somethingWentWrongError + '   Please come later',
                timeInSecForIos: 4);
          } else if (response == Strings.poorNetworkMessage) {
            Fluttertoast.showToast(
                msg: Strings.poorNetworkMessage + '   Please come later',
                timeInSecForIos: 4);
          } else if (response == Strings.RefundInitiated) {
            Fluttertoast.showToast(
                msg: Strings.RefundInitiated + '   Please come later',
                timeInSecForIos: 4);
          }
        });
      }
    });
  }

  void openCheckout(BookingModel order) async {
    var options = {
      'key': 'rzp_test_niGQbHfgV0P9yG', //testing key
      // 'key': 'rzp_live_t8n7Clyba4i9Ov',//live key
      'amount': order.totalAmount * 100,
      'name': 'Raju.',
      'description': 'Biryani',
      'prefill': {'contact': '9581106145', 'email': 'malothraju99@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    order.transactionId = response.paymentId;
    var storageInstance = locator<LocalStorageService>();
    storageInstance.saveToDisk(Strings.paymentId, response.paymentId);
    storageInstance.saveToDisk(Strings.PaymentDetailsStoredSucesfully, 'false');
    Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId, timeInSecForIos: 4);
    print(response.paymentId);
    this.afterpay();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message,
        timeInSecForIos: 4);
    print(response.code.toString() + (':payment'));
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName, timeInSecForIos: 4);
  }
}
