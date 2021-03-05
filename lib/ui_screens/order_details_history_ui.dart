import 'package:flutter/material.dart';
import 'package:preorder_flutter/api/order_details_history_api.dart';
import 'package:preorder_flutter/models/order_details_history_model.dart';
import 'package:preorder_flutter/models/orders_history_model.dart';
import 'package:preorder_flutter/utils/strings.dart';

class OrderDetailsHistory extends StatelessWidget {
  static const routeName = '/orderDetailsHistory';
  @override
  Widget build(BuildContext context) {
    Order order = ModalRoute.of(context).settings.arguments;
    return OrderDetails(
      order: order,
    );
  }
}

class OrderDetails extends StatefulWidget {
  final Order order;
  const OrderDetails({Key key, @required this.order}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  Future getOrderDetails;

  @override
  void initState() {
    super.initState();
    getOrderDetails = fetchOrderDetails(widget.order.orderId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: FutureBuilder(
          future: getOrderDetails,
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
                  } else if (snapshot.data == Strings.somethingWentWrongError) {
                    return Center(child: Text(Strings.somethingWentWrongError));
                  } else if (snapshot.data == Strings.poorNetworkMessage) {
                    return Center(child: Text(Strings.poorNetworkMessage));
                  } else if (snapshot.data == Strings.noNetworkMessage) {
                    return Center(child: Text(Strings.noNetworkMessage));
                  }
                  print(snapshot.data);

                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: 
                    Column(
                     
                      children: <Widget>[
                            Wrap(
                              children: <Widget>[
                                Container(
                                  height: 150,
                                  width: 150,
                                  decoration: BoxDecoration(
                                    color: Colors.blueGrey,
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                        fit: BoxFit.fill,
                                        image: NetworkImage(
                                          widget.order.imagePath,
                                        )),
                                  ),
                                ),
                                Column(
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(widget.order.restaurantName),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        // child: Text('TransactionId:' +
                                        //     widget.order.razorpayId),
                                        child: RichText(
                                          text: TextSpan(
                                            text: 'TransactionId: ',
                                            style:
                                                DefaultTextStyle.of(context).style,
                                            children: <TextSpan>[
                                              TextSpan(
                                                  text: widget.order.razorpayId,
                                                  style: TextStyle(
                                                      fontWeight: FontWeight.bold)),
                                              // TextSpan(text: ' world!'),
                                            ],
                                          ),
                                        ))
                                  ],
                                )
                              ],
                            ),
                        OrderedListBuilder(
                          orders: snapshot.data,
                       ),
                      ],
                    ),
                  );
                }
              default:
            }
          }),
    );
  }
}

class OrderedListBuilder extends StatelessWidget {
  final OrderDetailsHistoryModel orders;
  const OrderedListBuilder({Key key, @required this.orders}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
              child: ListView.builder(
      
        shrinkWrap: true,
        itemCount: orders.categories.length,
        itemBuilder: (BuildContext context, int index) {
          List<Ordered> catOrders = orders.ordered
              .where((item) =>
                  item.categoryName == orders.categories[index].categoryName)
              .toList();
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  orders.categories[index].categoryName,
                  style: TextStyle(color: Colors.red),
                ),
              ),
              Column(
                children: <Widget>[
                  for (var catOrder in catOrders)
                    Padding(
                      padding: const EdgeInsets.all(18.0),
                      child: Text(catOrder.recipeName),
                    ),
                ],
              )
            ],
          );
        },
      ),
    );
  }
}
