import 'package:appspector/appspector.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_voice_test/screens/AnalyseScreen.dart';
import 'package:flutter_voice_test/screens/ExistingRecordingScreen.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'RecordingScreen.dart';

class RecordAgainScreen extends StatefulWidget {
  RecordAgainScreen(
      {super.key,
      required this.totalText,
      required this.todayDate,
      required this.startTime,
      required this.endTime,
      required this.timer});

  String totalText;
  String todayDate;
  int timer;
  String startTime;
  String endTime;

  @override
  State<RecordAgainScreen> createState() => _RecordAgainScreenState();
}

class _RecordAgainScreenState extends State<RecordAgainScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Logger.d('akhil', 'screen opened');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff004E50), Color(0xff003637)])),
        child: SafeArea(
          child: Stack(
            children: [
              Center(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 50, 0, 0),
                  child: Column(
                    children: [
                      Text(
                        'Start Recording',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'pop',
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => RecordingScreen()));
                        },
                        child: AvatarGlow(
                            animate: true,
                            glowColor: Colors.grey,
                            endRadius: 75.0,
                            duration: const Duration(milliseconds: 2000),
                            repeatPauseDuration:
                                const Duration(milliseconds: 100),
                            repeat: true,
                            child: SvgPicture.asset('assets/play.svg')),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height / 2.2,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Color(0xff015557),
                            Color(0xf006163),
                          ]),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(30),
                          topLeft: Radius.circular(30))),
                  child: Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 8, 0, 0),
                        child: Container(
                          height: 6,
                          width: 120,
                          decoration: BoxDecoration(
                              color: Color(0xffFBFBFB),
                              borderRadius: BorderRadius.circular(20)),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 32, 0, 0),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Recent recordings',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'pop',
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 16, 30, 0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Unnamed',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'pop',
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  StopWatchTimer.getDisplayTime(widget.timer)
                                      .toString(),
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontFamily: 'pop',
                                    fontSize: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  widget.todayDate,
                                  style: TextStyle(
                                    fontFamily: 'pop',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                                Text(
                                  '${widget.startTime} - ${widget.endTime}',
                                  style: TextStyle(
                                    fontFamily: 'pop',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AnalyseScreen(
                                          totalText: widget.totalText,
                                          dateTime:
                                              '${widget.todayDate}, ${widget.startTime}-${widget.endTime}',
                                          saved: false,
                                        )));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 58,
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xff2CD4AC)),
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.5),
                                //     spreadRadius: 2,
                                //     blurRadius: 7,
                                //     offset: Offset(0, 3),
                                //   ),
                                // ],
                                // gradient: LinearGradient(
                                //     begin: Alignment.topLeft,
                                //     end: Alignment.bottomRight,
                                //     colors: [
                                //       Color(0xffFFAA98),
                                //       Color(0xffFF7456)
                                //     ]),
                                color: Color(0xff004E50),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'View Report',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'pop',
                                        fontSize: 18,
                                        color: Colors.white),
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  SvgPicture.asset('assets/report.svg'),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(30, 17, 30, 0),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ExistingRecordingScreen()));
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            height: 58,
                            decoration: BoxDecoration(
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.grey.withOpacity(0.5),
                                //     spreadRadius: 2,
                                //     blurRadius: 7,
                                //     offset: Offset(0, 3),
                                //   ),
                                // ],
                                color: Color(0xffFFCA51),
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: EdgeInsets.fromLTRB(25, 0, 20, 0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    'Recordings',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontFamily: 'pop',
                                        fontSize: 18,
                                        color: Color(0xff006163)),
                                  ),
                                  SvgPicture.asset(
                                    'assets/ic_round-expand-more.svg',
                                    color: Color(0xff006163),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
