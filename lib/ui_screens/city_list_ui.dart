import 'package:flutter/material.dart';
import 'package:preorder_flutter/api/city_list_api.dart';
import 'package:preorder_flutter/models/city_list_model.dart';
import 'package:preorder_flutter/providers/cart_provider.dart';
import 'package:preorder_flutter/providers/city_list_provider.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';
import 'package:preorder_flutter/utils/strings.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom_navigation_page_ui.dart';

class CityList extends StatefulWidget {
  static const routeName = '/cityList';
  @override
  CityListState createState() => CityListState();
}

class CityListState extends State<CityList> {
  Future future;
  @override
  void initState() {
    future = fetchCity();
    super.initState();
  }

  CityListProvider cityListProvider;
  @override
  Widget build(BuildContext context) {
    cityListProvider = Provider.of<CityListProvider>(context, listen: false);
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(
            alignment: Alignment.centerLeft,
            icon: Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: CustomSearchDelegate(),
              );
            },
          ),
        ]),
        body: Container(
            decoration: BoxDecoration(),
            child: FutureBuilder(
              future: future,
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                    return Center(child: CircularProgressIndicator());
                  case ConnectionState.none:
                    return Center(
                        child: Column(children: <Widget>[
                      Text("please Check Internet Connection"),
                      FlatButton(
                        child: Text("Retry"),
                        onPressed: () {
                          setState(() {
                            future = fetchCity();
                          });
                        },
                      )
                    ]));
                  case ConnectionState.done:
                    if (snapshot.hasData) {
                      cityListProvider.getData(snapshot.data.areasList);
                      return GridView.builder(
                        itemCount: snapshot.data.areasList.length,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3),
                        itemBuilder: (context, index) {
                          var result = snapshot.data.areasList[index];
                          return Container(
                            child: GridTile(
                              child: Column(
                                children: <Widget>[
                                  SizedBox(
                                    height: 20,
                                  ),
                                  Container(
                                    child: InkWell(
                                      child: Container(
                                        width: 100.0,
                                        height: 80.0,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              fit: BoxFit.cover,
                                              image: NetworkImage(
                                                  result.cityImagePath)),
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                      onTap: () async {
                                        var storageInstance =
                                            locator<LocalStorageService>();

                                        storageInstance.saveToDisk(
                                            Strings.userCity,
                                            areaToJson(result));
                                             storageInstance.saveToDisk(
                                            Strings.isCitySelected,
                                            Strings.True);

                                        print(storageInstance
                                            .getFromDisk(Strings.userCity));
                                        Provider.of<CartProvider>(context,
                                                listen: false)
                                            .clearCart();
                                        Navigator.pushNamedAndRemoveUntil(
                                            context,
                                            BottomNavigationPage.routeName,
                                            (Route<dynamic> route) => false);
                                      },
                                    ),
                                  ),
                                  Text(result.city),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                    return null;
                  default:
                    return Text("error");
                }
              },
            )));
  }
}

class CustomSearchDelegate extends SearchDelegate {
  List filtereddata;
  CityListProvider cityListProvider;
  @override
  List<Widget> buildActions(BuildContext context) {
    cityListProvider = Provider.of<CityListProvider>(context, listen: false);
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
        autofocus: true,
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    var cityListProvider =
        Provider.of<CityListProvider>(context, listen: false);
    print(cityListProvider.areaList[0].city);
    var filteredData = cityListProvider.areaList
        .where((hotel) => hotel.city.toLowerCase().contains(query))
        .toList();
    return CityListBuilder(areasList: filteredData);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var cityListProvider =
        Provider.of<CityListProvider>(context, listen: false);
    print(cityListProvider.areaList[0].city);
    var filteredData = cityListProvider.areaList
        .where((hotel) => hotel.city.toLowerCase().contains(query))
        .toList();
    return CityListBuilder(areasList: filteredData);
  }
}

class CityListBuilder extends StatelessWidget {
  final List<AreasList> areasList;
  CityListBuilder({Key key, @required this.areasList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: areasList.length,
      itemBuilder: (BuildContext context, int index) {
        return Transform.scale(
          child: ListTile(
            leading: Container(
              child: InkWell(
                child: FadeInImage.assetNetwork(
                  image: areasList[index].cityImagePath,
                  placeholder: 'assets/images/image_loading_placeholder.png',
                ),
                onTap: () async {
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.setString(Strings.userCity, areasList[index].city);
                  print(prefs.getString(Strings.userCity));
                },
              ),
            ),
            title: Text(areasList[index].city),
          ),
          scale: 1,
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: Colors.grey),
    );
  }
}
