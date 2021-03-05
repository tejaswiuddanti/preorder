import 'package:flutter/material.dart';
import 'package:preorder_flutter/api/hotels_list_api.dart';
import 'package:preorder_flutter/models/city_list_model.dart';
import 'package:preorder_flutter/models/hotels_list_model.dart';
import 'package:preorder_flutter/providers/hotels_list_provider.dart';
import 'package:preorder_flutter/services/get_it_service.dart';
import 'package:preorder_flutter/services/local_storage_service.dart';
import 'package:preorder_flutter/ui_screens/login_ui.dart';
import 'package:preorder_flutter/ui_screens/restaurant_items_ui.dart';
import 'package:preorder_flutter/utils/strings.dart';
import 'package:provider/provider.dart';

import 'city_list_ui.dart';

class Home extends StatelessWidget {
  static const routeName = '/home';
  final  storageInstance = locator<LocalStorageService>();

  @override
  Widget build(BuildContext context) {
    AreasList area =
        areaFromJson(storageInstance.getFromDisk(Strings.userCity));
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: InkWell(
              onTap: () => Navigator.pushNamed(context, CityList.routeName),
              child: Row(
                children: <Widget>[
                  Icon(Icons.gps_fixed),
                  Text(area.city),
                ],
              ),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  showSearch(
                    context: context,
                    delegate: HotelsListSearchDelegate(),
                  );
                },
              ),
              IconButton(icon: Icon(Icons.power_settings_new),color: Colors.white, onPressed: () {
                  storageInstance.saveToDisk(
                                            Strings.loggedIn,Strings.False
                                           );
                                             storageInstance.saveToDisk(
                                            Strings.isCitySelected,Strings.False
                                           );
                                            Navigator.pushNamedAndRemoveUntil(
                                                context,
                                                Login.routeName,
                                                (Route<dynamic> route) => false);
              },)
            ],
          ),
          body: CustomScrollView(slivers: <Widget>[
            SliverFillRemaining(child: HotelListBuilder())
          ])),
    );
  }
}

class HotelListBuilder extends StatefulWidget {
  @override
  _HotelListBuilderState createState() => _HotelListBuilderState();
}

class _HotelListBuilderState extends State<HotelListBuilder> {
  Future _fetchHotelsList;

  @override
  void initState() {
    super.initState();
    _fetchHotelsList = fetchHotelsList();
  }

  HotelsListProvider hotelsListProvider;
  @override
  Widget build(BuildContext context) {
    hotelsListProvider =
        Provider.of<HotelsListProvider>(context, listen: false);
    return FutureBuilder(
      future: _fetchHotelsList,
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
              return  Center(child: Text(snapshot.error));
              } else if (snapshot.data == Strings.somethingWentWrongError) {
              return  Center(child: Text(Strings.somethingWentWrongError));
              }
               else if(snapshot.data==Strings.poorNetworkMessage){
                 return  Center(child: Text(Strings.poorNetworkMessage));
              }
              else if(snapshot.data==Strings.noNetworkMessage){
                 return  Center(child: Text(Strings.noNetworkMessage));
              }
              print(snapshot.data);
              hotelsListProvider.setHotels(snapshot.data.hotelsList);

              return HotelsListBuilder(
                hotelsList: snapshot.data.hotelsList,
              );
            }
          default:
        }
      },
    );
  }
}

class HotelsListBuilder extends StatelessWidget {
  final List<HotelsList> hotelsList;
  HotelsListBuilder({Key key, @required this.hotelsList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: hotelsList.length,
      itemBuilder: (BuildContext context, int index) {
        return ListTile(
          onTap: () {
            Navigator.pushNamed(context, RestaurantItemsScreen.routeName,
                arguments: hotelsList[index]);
          },
          leading: ClipRRect(
            borderRadius: BorderRadius.circular(15),
            child: Container(
              height: 800,
              child: FadeInImage.assetNetwork(
                image: hotelsList[index].imagePath,
                placeholder: 'assets/images/image_loading_placeholder.png',
              ),
            ),
          ),
          title: Text(hotelsList[index].restaurantName),
          subtitle: Text(
              hotelsList[index].startTime + ' to ' + hotelsList[index].endTime),
        );
      },
    );
  }
}

class HotelsListSearchDelegate extends SearchDelegate {
  @override
  List<Widget> buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
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
    print('hello');
    //need to know this
    var hotelsListProvider =
        Provider.of<HotelsListProvider>(context, listen: false);
    print(hotelsListProvider.gethotelsList[0].restaurantName);
    var filteredData = hotelsListProvider.gethotelsList
        .where((hotel) => hotel.restaurantName.contains(query))
        .toList();
    return HotelsListBuilder(hotelsList: filteredData);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    var hotelsListProvider =
        Provider.of<HotelsListProvider>(context, listen: false);
    print(hotelsListProvider.gethotelsList[0].restaurantName);
    var filteredData = hotelsListProvider.gethotelsList
        .where((hotel) => hotel.restaurantName.toLowerCase().contains(query))
        .toList();
    return HotelsListBuilder(hotelsList: filteredData);
  }
}
