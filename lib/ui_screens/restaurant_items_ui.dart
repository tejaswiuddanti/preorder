import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:preorder_flutter/api/restaurant_items_api.dart';
import 'package:preorder_flutter/models/hotels_list_model.dart';
import 'package:preorder_flutter/providers/cart_provider.dart';
import 'package:preorder_flutter/utils/strings.dart';
import 'package:provider/provider.dart';

import 'cart_ui.dart';

class RestaurantItemsScreen extends StatelessWidget {
  static const routeName = '/restaurantItems';
  @override
  Widget build(BuildContext context) {
    HotelsList hotel = ModalRoute.of(context).settings.arguments;
    return SafeArea(
      child: Scaffold(
        body: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                expandedHeight: 200,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text('${hotel.restaurantName}'),
                  background: FadeInImage.assetNetwork(
                    fit: BoxFit.cover,
                    image: hotel.imagePath,
                    placeholder: 'assets/images/image_loading_placeholder.png',
                  ),
                )),
            SliverFillRemaining(
              child: ItemsFetching(
                hotel: hotel, // : FloatingActionButton(tooltip: 'cart',
          //     onPressed: () {
          //       Navigator.pushNamed(context, CartScreen.routeName);
          //     },
          //     child: Icon(Icons.add_shopping_cart));
              ),
            )
          ],
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            Consumer<CartProvider>(builder: (context, data, child) {
          print('cart items length: ' + data.cartItems.length.toString());
          return (data.cartItems.isEmpty)
              ? SizedBox(
                  height: 0,
                  width: 0,
                )
              : CartButton(
                  onPressed: () {
                    Navigator.pushNamed(context, CartScreen.routeName);
                  },
                  tooltip: 'Cart',
                );
        }),
      ),
    );
  }
}

class ItemsFetching extends StatefulWidget {
  final HotelsList hotel;
  ItemsFetching({Key key, @required this.hotel}) : super(key: key);
  @override
  _ItemsFetchingState createState() => _ItemsFetchingState();
}

class _ItemsFetchingState extends State<ItemsFetching> {
  Future _fetchMenu;
  @override
  void initState() {
    super.initState();
    _fetchMenu = fetchMenu(widget.hotel);
  }

  @override
  Widget build(BuildContext context) {
    CartProvider cartProvider =
        Provider.of<CartProvider>(context, listen: false);
    return FutureBuilder(
      future: _fetchMenu,
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
              //print(snapshot.data);
              if (snapshot.hasError) {
                Center(child: Text(snapshot.error));
              } else if (snapshot.data == Strings.somethingWentWrongError) {
                Center(child: Text(Strings.somethingWentWrongError));
              }
              print(snapshot.data.resTypes.length);
              List<Widget> tabs = List();
              print(snapshot.data);
              for (var tab in snapshot.data.resTypes) {
                print(tab);
                tabs.add(Tab(
                  text: tab,
                ));
              }
              List<Widget> tabView = List();

              for (var tabview in snapshot.data.resItems) {
                tabView.add(SingleChildScrollView(
                                  child: Column(
                    children: <Widget>[
                      for (var _tabview in tabview)
                        ListTile(
                          leading: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: FadeInImage.assetNetwork(
                                image: _tabview.imagePath,
                                placeholder:
                                    'assets/images/image_loading_placeholder.png',
                              ),
                            ),
                          ),
                          title: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Expanded(child: Text(_tabview.recipeName)),
                              Consumer<CartProvider>(
                                builder: (context, data, child) {
                                  if (data.addedItemsIds
                                      .contains(_tabview.recipeId)) {
                                    int cartIndex = data.cartItems.indexWhere(
                                        (item) =>
                                            item.addedItem.recipeId ==
                                            _tabview.recipeId);
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: <Widget>[
                                        Transform.scale(
                                          child: RaisedButton(
                                              onPressed: () {
                                                cartProvider
                                                    .increaseItemCount(cartIndex);
                                              },
                                              child: Icon(Icons.add)),
                                          scale: 0.5,
                                        ),
                                        Text(data.cartItems[cartIndex].itemCount
                                            .toString()),
                                        Transform.scale(
                                          child: FlatButton(
                                              onPressed: () {
                                                cartProvider
                                                    .decreaseItemCount(cartIndex);
                                              },
                                              child: Icon(Icons.remove)),
                                          scale: 0.5,
                                        )
                                      ],
                                    );
                                  }
                                  return FlatButton(
                                    onPressed: () {
                                      if (cartProvider.hotel == null) {
                                        cartProvider.setHotel(widget.hotel);
                                        cartProvider.addItem(_tabview);
                                      } else if (cartProvider.hotel ==
                                          widget.hotel) {
                                        cartProvider.addItem(_tabview);
                                      } else if (cartProvider.hotel !=
                                              widget.hotel &&
                                          cartProvider.cartItems.length == 0) {
                                        cartProvider.setHotel(widget.hotel);
                                        cartProvider.clearCart();
                                        cartProvider.addItem(_tabview);
                                      } else {
                                        showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return CupertinoAlertDialog(
                                                title: Text("Clear Cart"),
                                                content: Text(
                                                    "Are you sure to clear the previous cart?"),
                                                actions: [
                                                  CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      child: Text("NO"),
                                                      onPressed: () {
                                                        Navigator.pop(
                                                            context, 'Cancel');
                                                      }),
                                                  CupertinoDialogAction(
                                                      isDefaultAction: true,
                                                      child: Text("Okay"),
                                                      onPressed: () {
                                                        cartProvider.setHotel(
                                                            widget.hotel);
                                                        cartProvider.clearCart();
                                                        cartProvider
                                                            .addItem(_tabview);
                                                        Navigator.pop(
                                                            context, 'done');
                                                      })
                                                ],
                                              );
                                            });
                                      }
                                    },
                                    child: Text('ADD'),
                                  );
                                },
                              )
                            ],
                          ),
                          subtitle: Text(_tabview.price),
                        ),
                    ],
                  ),
                ));
              }
              return ItemsListBuilder(
                tabs: tabs,
                tabView: tabView,
              );
            }
          default:
        }
      },
    );
  }
}

class ItemsListBuilder extends StatefulWidget {
  List<Widget> tabs;
  List<Widget> tabView;

  ItemsListBuilder({Key key, @required this.tabs, @required this.tabView})
      : super(key: key);
  @override
  _ItemsListBuilderState createState() => _ItemsListBuilderState();
}

class _ItemsListBuilderState extends State<ItemsListBuilder>
    with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    super.initState();
    _tabController = TabController(vsync: this, length: widget.tabs.length);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        TabBar(
          isScrollable: true,
          labelColor: Colors.pink,
          controller: _tabController,
          tabs: widget.tabs,
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: widget.tabView,
          ),
        )
      ],
    );
  }
}

class CartButton extends StatelessWidget {
  CartButton({@required this.onPressed, @required this.tooltip});
  final GestureTapCallback onPressed;
  final String tooltip;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: RawMaterialButton(
        onPressed: onPressed,
        fillColor: Colors.deepOrange,
        splashColor: Colors.orange,
        shape: StadiumBorder(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.restaurant_menu,
                color: Colors.white,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(
                'Cart',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
