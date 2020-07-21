import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:versitile_thing/screens/api.dart';
import 'package:versitile_thing/screens/compass.dart';
import 'package:versitile_thing/screens/measurement.dart';
import 'package:versitile_thing/screens/time.dart';

class Navigation extends StatefulWidget {
  @override
  _NavigationState createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> {

  int pageIndex = 0;

  List<Widget> screens = [Compass(), Time(), Measurement(), StuffWithAPI()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens[pageIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color.fromRGBO(35, 39, 42, 1),
        type: BottomNavigationBarType.fixed,
        onTap: (int index) {
          setState(() {
            pageIndex = index;
          });
        },
        currentIndex: pageIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.explore,
              color: pageIndex==0 ? Colors.white : Color.fromRGBO(153, 170, 181, 1),
            ),
            title: Text(
              'Compass',
              style: TextStyle(
                color: pageIndex==0 ? Colors.white : Color.fromRGBO(153, 170, 181, 1),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.access_time,
              color: pageIndex==1 ? Colors.white : Color.fromRGBO(153, 170, 181, 1),
            ),
            title: Text(
              'Time',
              style: TextStyle(
                color: pageIndex==1 ? Colors.white : Color.fromRGBO(153, 170, 181, 1),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.straighten,
              color: pageIndex==2 ? Colors.white : Color.fromRGBO(153, 170, 181, 1),
            ),
            title: Text(
              'Measurement',
              style: TextStyle(
                color: pageIndex==2 ? Colors.white : Color.fromRGBO(153, 170, 181, 1),
              ),
            ),
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.cloud,
              color: pageIndex==3 ? Colors.white : Color.fromRGBO(153, 170, 181, 1),
            ),
            title: Text(
              'API',
              style: TextStyle(
                color: pageIndex==3 ? Colors.white : Color.fromRGBO(153, 170, 181, 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
