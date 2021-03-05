import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as prefix0;
import 'package:preorder_flutter/api/history_api.dart';
import 'package:preorder_flutter/models/orders_history_model.dart';
import 'package:preorder_flutter/providers/bottom_navigation_provider.dart';
import 'package:preorder_flutter/ui_screens/order_details_history_ui.dart';
import 'package:preorder_flutter/utils/strings.dart';
import 'package:provider/provider.dart';

class HistoryScreen extends StatefulWidget {
  @override
  _HistoryScreenState createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  Future _fetchHistory;
  @override
  void initState() {
    super.initState();
    _fetchHistory = fetchHistrory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.refresh),
              onPressed: () {
                setState(() {
                  _fetchHistory = fetchHistrory();
                });
              },
            )
          ],
        ),
        body: FutureBuilder(
            future: _fetchHistory,
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case (ConnectionState.none):
                case (ConnectionState.active):
                case (ConnectionState.waiting):
                  return Center(
                      child: CircularProgressIndicator(
                    backgroundColor: Colors.transparent,
                  ));
                case (ConnectionState.done):
                  {
                    if (snapshot.hasError) {
                      return Center(child: Text(snapshot.error));
                    } else if (snapshot.data ==
                        Strings.somethingWentWrongError) {
                      return Center(
                          child: Text(Strings.somethingWentWrongError));
                    } else if (snapshot.data == Strings.poorNetworkMessage) {
                      return Center(child: Text(Strings.poorNetworkMessage));
                    } else if (snapshot.data == Strings.noNetworkMessage) {
                      return Center(child: Text(Strings.noNetworkMessage));
                    }
                    print(snapshot.data);

                    return OrdersListBuilder(
                      orders: snapshot.data,
                    );
                  }
                default:
              }
            }));
  }
}

class OrdersListBuilder extends StatelessWidget {
  final List<Order> orders;

  const OrdersListBuilder({Key key, @required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return (orders.isEmpty)
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text('Start Ordering '),
                FlatButton(
                  color: Colors.blueGrey,
                  child: Text(
                    'Book now',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () => {
                    Provider.of<BottomNavigationProvider>(context,
                            listen: false)
                        .setIndex(0)
                  },
                )
              ],
            ),
          )
        : ListView.separated(
            itemCount: orders.length,
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  Navigator.pushNamed(context, OrderDetailsHistory.routeName,
                      arguments: orders[index]);
                },
                child: Container(
                    child: Stack(
                  children: <Widget>[
                    BackdropFilter(
                      child: Container(
                        width: size.width,
                        height: 300,
                        child: FadeInImage.assetNetwork(
                          fit: BoxFit.cover,
                          image: orders[index].imagePath,
                          placeholder:
                              'assets/images/image_loading_placeholder.png',
                        ),
                      ),
                      filter: ImageFilter.blur(sigmaX: 0, sigmaY: 0),
                    ),
                    Positioned(
                        bottom: 20,
                        child: Container(
                          height: 100,
                          width: size.width,
                          child: Card(
                              child: ListTile(
                            trailing: Text(
                              orders[index].status,
                              style: prefix0.TextStyle(color: Colors.green),
                            ),
                            //   leading: CircleAvatar(
                            //   child: Text(orders[index].personsCount),
                            // ),
                            title: Text(orders[index].restaurantName),
                            subtitle: Wrap(
                              children: <Widget>[
                                Text(orders[index].city),
                               
                                RichText(
                                  text: TextSpan(
                                    text: '       Amount Paid: ',
                                    style: DefaultTextStyle.of(context).style,
                                    children: <TextSpan>[
                                      TextSpan(
                                          text: '₹ '+orders[index].totalAmount,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red)),
                                    ],
                                  ),
                                ),

                                Text('      ' +
                                    orders[index].orderedDate.toString()),
                              ],
                            ),
                          )),
                          color: Colors.transparent,
                        ))
                  ],
                )),
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return Divider(height: 15, color: Colors.blueGrey);
            },
          );
  }
}
