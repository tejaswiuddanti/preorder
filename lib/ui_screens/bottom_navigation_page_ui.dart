import 'package:flutter/material.dart';
import 'package:preorder_flutter/providers/bottom_navigation_provider.dart';
import 'package:preorder_flutter/utils/widgets.dart';
import 'package:provider/provider.dart';

class BottomNavigationPage extends StatelessWidget {
   static const routeName = '/bottomNavigationPage';
  final  tabs=[Widgets.HOME,Widgets.CARTSCREEN,Widgets.PROFILE,Widgets.HISTORY];
  @override
  Widget build(BuildContext context) {
    final bottomNavigationProvider=Provider.of<BottomNavigationProvider>(context);
    print(bottomNavigationProvider.getIndex);
    return Scaffold(
      body: 
           tabs[bottomNavigationProvider.getIndex],
       

    
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index)=>bottomNavigationProvider.setIndex(index),
        currentIndex: bottomNavigationProvider.getIndex,
        items: <BottomNavigationBarItem>[ BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Colors.blueGrey,
            ),
            title: Text(
              'Home',
              style: TextStyle(color: Colors.blueGrey),
            ),
            backgroundColor: Colors.teal[100],
          ), BottomNavigationBarItem(
            icon: Icon(
              Icons.room_service,
              color: Colors.blueGrey,
            ),
            title: Text(
              'Cart',
              style: TextStyle(color: Colors.blueGrey),
            ),
            backgroundColor: Colors.teal[100],
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person_outline,
              color: Colors.blueGrey,
            ),
            title: Text(
              'Profile',
              style: TextStyle(color: Colors.blueGrey),
            ),
            backgroundColor: Colors.teal[100],
          ),
            BottomNavigationBarItem(
            icon: Icon(
              Icons.book,
              color: Colors.blueGrey,
            ),
            title: Text(
              'History',
              style: TextStyle(color: Colors.blueGrey),
            ),
            backgroundColor: Colors.teal[100],
          ),],

      ),
      
    );
  }
}