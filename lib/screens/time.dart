import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_compass/flutter_compass.dart';
import 'package:matrix4_transform/matrix4_transform.dart';
import 'package:versitile_thing/animations/FadeAnimationDown.dart';
import 'package:versitile_thing/animations/FadeAnimationLeft.dart';
import 'package:versitile_thing/animations/FadeAnimationRight.dart';
import 'package:versitile_thing/animations/FadeAnimationStatic.dart';
import 'package:versitile_thing/animations/FadeAnimationUp.dart';

class Time extends StatefulWidget {
  @override
  _TimeState createState() => _TimeState();
}

class _TimeState extends State<Time> {

  int date = DateTime.now().day;
  double second = 0;
  double minute = 0;
  double hour = 0;
  int bph = 21600;
  Color indexColor = Colors.lightGreenAccent;

  @override
  void initState() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    Timer.periodic(Duration(milliseconds: (1000~/(bph/60/60))), (timer) {
      getSecond();
      getMinute();
      getHour();
    });
    super.initState();
  }

  getDate() {
    setState(() {
      date = DateTime.now().day;
    });
  }

  getHour() {
    setState(() {
      hour = (DateTime.now().hour*30.0+DateTime.now().minute*0.5+DateTime.now().second*(30.0/60.0/60.0))*(math.pi/180);
    });
  }

  getMinute() {
    setState(() {
      minute = (DateTime.now().minute*6.0+DateTime.now().second*0.1+DateTime.now().millisecond*0.0001)*(math.pi/180);
    });
  }

  getSecond() {
    setState(() {
      second = ((1000*DateTime.now().second+DateTime.now().millisecond)/(1000/(bph/60/60)))*(6/(bph/60/60))*(math.pi/180);
    });
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

  @override
  void dispose() {
    _TimeState().dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double indexWidth = 5;
    double indexHeight = 40;
    if(second!=null&&minute!=null&&hour!=null) {
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
                        FadeAnimationStatic(1.0, CompassIndex(0, radians, false)),
                        FadeAnimationStatic(1.1, CompassIndex(30, radians, false),),
                        FadeAnimationStatic(1.2, CompassIndex(60, radians, false),),
                        FadeAnimationStatic(1.3, CompassIndex(90, radians, false),),
                        FadeAnimationStatic(1.4, CompassIndex(120, radians, false),),
                        FadeAnimationStatic(1.5, CompassIndex(150, radians, false),),
                        FadeAnimationStatic(1.6, CompassIndex(180, radians, false),),
                        FadeAnimationStatic(1.7, CompassIndex(210, radians, false),),
                        FadeAnimationStatic(1.8, CompassIndex(240, radians, false),),
                        FadeAnimationStatic(1.9, CompassIndex(270, radians, false),),
                        FadeAnimationStatic(2.0, CompassIndex(300, radians, false),),
                        FadeAnimationStatic(2.1, CompassIndex(330, radians, false),),
                        FadeAnimationStatic(
                          1,
                          Center(
                            child: Container(
                              height: MediaQuery.of(context).size.width-70,
                              width: MediaQuery.of(context).size.width-70,
                              child: Image.asset('assets/index.png'),
                            ),
                          ),
                        ),
                        FadeAnimationLeft(
                          1,
                          Center(
                            child: Row(
                              children: <Widget>[
                                Spacer(
                                  flex: 112,
                                ),
                                Stack(
                                  children: <Widget>[
                                    Container(
                                      width: 35,
                                      height: 25,
                                      alignment: Alignment(1, 0),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(153, 170, 181, 1),
                                        borderRadius: BorderRadius.circular(3),
                                      ),
                                      child: Center(
                                        child: Container(
                                          width: 30,
                                          height: 20,
                                          alignment: Alignment(1, 0),
                                          decoration: BoxDecoration(
                                            color: Color.fromRGBO(44, 47, 51, 1),
                                            borderRadius: BorderRadius.circular(1),
                                          ),
                                          child: Center(
                                            child: Text(
                                              '$date',
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Spacer(
                                  flex: 15,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Container(
                          child: Center(
                            child: Column(
                              children: <Widget>[
                                Spacer(
                                  flex: 80,
                                ),
                                Row(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 250,
                                    ),
                                    FadeAnimationLeft(
                                      2.1,
                                      Container(
                                        transform: Matrix4Transform().rotateByCenter(-math.pi/6, Size(10, 40)).matrix4,
                                        width: indexHeight,
                                        height: indexWidth,
                                        color: indexColor,
                                      ),
                                    ),
                                    Spacer(
                                      flex: 32,
                                    ),
                                  ],
                                ),
                                Container(
                                  height: 88,
                                ),
                                Row(
                                  children: <Widget>[
                                    Spacer(
                                      flex: 250,
                                    ),
                                    FadeAnimationLeft(
                                      1.1,
                                      Container(
                                        transform: Matrix4Transform().rotateByCenter(math.pi/6, Size(10, 40)).matrix4,
                                        width: indexHeight,
                                        height: indexWidth,
                                        color: indexColor,
                                      ),
                                    ),
                                    Spacer(
                                      flex: 54,
                                    ),
                                  ],
                                ),
                                Spacer(
                                  flex: 83,
                                ),
                              ],
                            ),
                          )
                        ),
                        Container(
                            child: Center(
                              child: Column(
                                children: <Widget>[
                                  Spacer(
                                    flex: 39,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Spacer(
                                        flex: 36,
                                      ),
                                      FadeAnimationRight(
                                        1.7,
                                        Container(
                                          transform: Matrix4Transform().rotateByCenter(math.pi/6, Size(10, 40)).matrix4,
                                          width: indexHeight,
                                          height: indexWidth,
                                          color: indexColor,
                                        ),
                                      ),
                                      Spacer(
                                        flex: 250,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 60,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Spacer(
                                        flex: 23,
                                      ),
                                      FadeAnimationRight(
                                        1.6,
                                        Container(
                                          width: indexHeight,
                                          height: indexWidth,
                                          color: indexColor,
                                        ),
                                      ),
                                      Spacer(
                                        flex: 224,
                                      ),
                                    ],
                                  ),
                                  Container(
                                    height: 55,
                                  ),
                                  Row(
                                    children: <Widget>[
                                      Spacer(
                                        flex: 58,
                                      ),
                                      FadeAnimationRight(
                                        1.5,
                                        Container(
                                          transform: Matrix4Transform().rotateByCenter(-math.pi/6, Size(10, 40)).matrix4,
                                          width: indexHeight,
                                          height: indexWidth,
                                          color: indexColor,
                                        ),
                                      ),
                                      Spacer(
                                        flex: 250,
                                      ),
                                    ],
                                  ),
                                  Spacer(
                                    flex: 42,
                                  ),
                                ],
                              ),
                            )
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(
                                flex: 31,
                              ),
                              Column(
                                children: <Widget>[
                                  Spacer(
                                    flex: 22,
                                  ),
                                  FadeAnimationDown(
                                    1.8,
                                    Container(
                                      transform: Matrix4Transform().rotateByCenter(-math.pi/6, Size(10, 40)).matrix4,
                                      width: indexWidth,
                                      height: indexHeight,
                                      color: indexColor,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 125,
                                  ),
                                ],
                              ),
                              Container(
                                width: 48,
                              ),
                              Column(
                                children: <Widget>[
                                  Spacer(
                                    flex: 23,
                                  ),
                                  FadeAnimationDown(
                                    1.9,
                                    Container(
                                      width: indexWidth,
                                      height: indexHeight,
                                      color: indexColor,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 217,
                                  ),
                                ],
                              ),
                              Container(
                                width: 49,
                              ),
                              Column(
                                children: <Widget>[
                                  Spacer(
                                    flex: 23,
                                  ),
                                  FadeAnimationDown(
                                    2.0,
                                    Container(
                                      transform: Matrix4Transform().rotateByCenter(math.pi/6, Size(10, 40)).matrix4,
                                      width: indexWidth,
                                      height: indexHeight,
                                      color: indexColor,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 125,
                                  ),
                                ],
                              ),
                              Spacer(
                                flex: 30,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          child: Row(
                            children: <Widget>[
                              Spacer(
                                flex: 59,
                              ),
                              Column(
                                children: <Widget>[
                                  Spacer(
                                    flex: 125,
                                  ),
                                  FadeAnimationUp(
                                    1.4,
                                    Container(
                                      transform: Matrix4Transform().rotateByCenter(math.pi/6, Size(10, 40)).matrix4,
                                      width: indexWidth,
                                      height: indexHeight,
                                      color: indexColor,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 22,
                                  ),
                                ],
                              ),
                              Container(
                                width: 49,
                              ),
                              Column(
                                children: <Widget>[
                                  Spacer(
                                    flex: 217,
                                  ),
                                  FadeAnimationUp(
                                    1.3,
                                    Container(
                                      width: indexWidth,
                                      height: indexHeight,
                                      color: indexColor,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 23,
                                  ),
                                ],
                              ),
                              Container(
                                width: 49,
                              ),
                              Column(
                                children: <Widget>[
                                  Spacer(
                                    flex: 125,
                                  ),
                                  FadeAnimationUp(
                                    1.2,
                                    Container(
                                      transform: Matrix4Transform().rotateByCenter(-math.pi/6, Size(10, 40)).matrix4,
                                      width: indexWidth,
                                      height: indexHeight,
                                      color: indexColor,
                                    ),
                                  ),
                                  Spacer(
                                    flex: 23,
                                  ),
                                ],
                              ),
                              Spacer(
                                flex: 60,
                              ),
                            ],
                          ),
                        ),
                        FadeAnimationStatic(
                          1.8,
                          Center(
                            child: Container(
                              width: 15,
                              transform: Matrix4Transform().rotateByCenter(hour, Size(15, 153.491)).matrix4,
                              child: Image.asset('assets/hour.png'),
                            ),
                          ),
                        ),
                        FadeAnimationStatic(
                          1.8,
                          Center(
                            child: Container(
                              width: 15,
                              transform: Matrix4Transform().rotateByCenter(minute, Size(15, 226.7571)).matrix4,
                              child: Image.asset('assets/minute.png'),
                            ),
                          ),
                        ),
                        FadeAnimationStatic(
                          1.8,
                          Center(
                            child: Container(
                              height: 260,
                              transform: Matrix4Transform().rotateByCenter(second, Size(11.3083, 260)).matrix4,
                              child: Image.asset('assets/second.png'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      );
    }
    else {
      return Scaffold(
        backgroundColor: Color.fromRGBO(44, 47, 51, 1),
        body: Center(
          child: Container(
            height: 50,
            width: 50,
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }
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
