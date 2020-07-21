import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:versitile_thing/animations/FadeAnimationStatic.dart';
import 'package:versitile_thing/animations/FadeAnimationUp.dart';
import 'package:permission_handler/permission_handler.dart';

class Compass extends StatefulWidget {
  @override
  _CompassState createState() => _CompassState();
}

class _CompassState extends State<Compass> {

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.initState();
  }

  getAlignX(int angle, double radians, bool word) {
    if(word&&angle==270) {
      return 43*-math.sin((radians+(-angle*(math.pi/180))))/40;
    }
    else if(word) {
      return 31*-math.sin((radians+(-angle*(math.pi/180))))/30;
    }
    else if(angle>=100) {
      return 21*-math.sin((radians+(-angle*(math.pi/180))))/20;
    }
    else if(angle==0) {
      return 20*-math.sin((radians+(-angle*(math.pi/180))))/21;
    }
    else {
      return -math.sin((radians+(-angle*(math.pi/180))));
    }
  }

  getAlignY(int angle, double radians, bool word) {
    if(word) {
      return 43*-math.cos((radians+(-angle*(math.pi/180))))/40;
    }
    else {
      return -math.cos((radians+(-angle*(math.pi/180))));
    }
  }

  _fetchPermission() async {
    if (await Permission.locationWhenInUse.request().isGranted&&await Permission.locationWhenInUse.serviceStatus.isEnabled) {

    }
    else {
      Permission.locationWhenInUse.request();
    }
  }

  @override
  void dispose() {
    _CompassState().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<double>(
        stream: FlutterCompass.events,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Error reading heading: ${snapshot.error}');
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Scaffold(
              backgroundColor: Color.fromRGBO(44, 47, 51, 1),
              body: Center(
                child: Container(),
              ),
            );
          }

          double radians = ((snapshot.data ?? 0.0) * (math.pi / 180.0));

          // if direction is null, then device does not support this sensor
          // show error message
          if (radians == null)
            return Center(
              child: Text("Device does not have sensors !"),
            );

          return Scaffold(
            backgroundColor: Color.fromRGBO(44, 47, 51, 1),
            body: Column(
              children: <Widget>[
                Container(
                  height: (MediaQuery.of(context).size.height-MediaQuery.of(context).size.width-50)/2.415,
                ),
                Container(
                  height: MediaQuery.of(context).size.width-50,
                  width: MediaQuery.of(context).size.width-50,
                  alignment: Alignment.center,
                  child: Stack(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Container(
                            height: 15,
                          ),
                          Row(
                            children: <Widget>[
                              Spacer(
                                flex: 1,
                              ),
                              FadeAnimationUp(
                                2.2,
                                Container(
                                  transform: Matrix4Transform().rotateByCenter(math.pi, Size(50,50)).matrix4,
                                  child: Icon(
                                    Icons.details,
                                    size: 50,
                                    color: Colors.redAccent,
                                  ),
                                ),
                              ),
                              Spacer(
                                flex: 1,
                              ),
                            ],
                          ),
                        ],
                      ),
                      FadeAnimationStatic(
                        1,
                        Container(
                          child: Transform.rotate(
                            angle: -radians,
                            child: Image.asset('assets/compass.png'),
                          ),
                        ),
                      ),
                      FadeAnimationStatic(1.0, CompassIndex(0, radians, true)),
                      FadeAnimationStatic(1.1, CompassIndex(30, radians, false),),
                      FadeAnimationStatic(1.2, CompassIndex(60, radians, false),),
                      FadeAnimationStatic(1.3, CompassIndex(90, radians, true),),
                      FadeAnimationStatic(1.4, CompassIndex(120, radians, false),),
                      FadeAnimationStatic(1.5, CompassIndex(150, radians, false),),
                      FadeAnimationStatic(1.6, CompassIndex(180, radians, true),),
                      FadeAnimationStatic(1.7, CompassIndex(210, radians, false),),
                      FadeAnimationStatic(1.8, CompassIndex(240, radians, false),),
                      FadeAnimationStatic(1.9, CompassIndex(270, radians, true),),
                      FadeAnimationStatic(2.0, CompassIndex(300, radians, false),),
                      FadeAnimationStatic(2.1, CompassIndex(330, radians, false),),
                      FadeAnimationStatic(
                        2.2,
                        Center(
                          child: Text(
                            ' ${(radians*(180/math.pi)).toInt()}°',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 50,
                                fontWeight: FontWeight.w200
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 1.415*(MediaQuery.of(context).size.height-MediaQuery.of(context).size.width-50)/2.415,
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget CompassIndex(int angle, double radians, bool word) {
    if(word) {
      String direction;
      if(angle==0) {
        direction = 'N';
      }
      if(angle==90) {
        direction = 'E';
      }
      if(angle==180) {
        direction = 'S';
      }
      if(angle==270) {
        direction = 'W';
      }
      return Container(
        alignment: Alignment(getAlignX(angle, radians, true), getAlignY(angle, radians, true)),
        child: Text(
          '$direction',
          style: TextStyle(
            fontSize: 25,
            color: direction=='N' ? Colors.redAccent : Colors.white,
          ),
        ),
      );
    }
    else {
      return Container(
        alignment: Alignment(getAlignX(angle, radians, false), getAlignY(angle, radians, false)),
        child: Text(
          '$angle',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      );
    }
  }
}
