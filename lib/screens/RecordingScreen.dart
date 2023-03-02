import 'package:appspector/appspector.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:speech_to_text/speech_recognition_error.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'HomeScreen.dart';
import 'RecordAgainScreen.dart';

class RecordingScreen extends StatefulWidget {
  RecordingScreen({Key? key}) : super(key: key);

  @override
  _RecordingScreenState createState() => _RecordingScreenState();
}

class _RecordingScreenState extends State<RecordingScreen> {
  SpeechToText? speech;
  bool _listenLoop = false;
  String lastHeard = '';
  // StringBuffer totalHeard = StringBuffer();
  double confidence = 0.0;

  String todayDate = DateFormat("EEE, dd, yyyy").format(DateTime.now());

  String startTime = DateFormat('hh:mm').format(DateTime.now());

  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.

  int? timer;

  // List<String> allData = [];

  String first = '';
  String last = '';

  String totalHeard = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    startListening(forced: true);

    _stopWatchTimer.onStartTimer();
  }

  void _onStatus(String status) {
    if ('done' == status) {
      print('onStatus(): $status ');
      startListening();
    }
  }

  void startListening({bool forced = false}) async {
    if (forced) {
      setState(() {
        _listenLoop = !_listenLoop;
      });
    }
    if (!_listenLoop) return;
    print('startListening()');
    speech = SpeechToText();

    bool _available = await speech!.initialize(
      onStatus: _onStatus,
      //onError: (val) => print('onError: $val'),
      onError: (val) => onError(val),
      debugLogging: true,
    );
    if (_available) {
      print('startListening() -> _available = true');
      await listen();
    } else {
      print('startListening() -> _available = false');
    }
  }

  void stopListening() async {
    setState(() {
      _listenLoop = false;
    });
    speech!.stop();
    Logger.d("MyTAG", "stopped listening");
  }

  Future listen() async {
    print('speech!.listen()');
    speech!.listen(
      localeId: 'en_US',
      onResult: (val) {
        onResult(val);
        if (val.hasConfidenceRating && val.confidence > 0) {
          confidence = val.confidence;
        }
      },
    ); // Doesn't do anything
  }

  void onError(SpeechRecognitionError val) async {
    print('onError(): ${val.errorMsg}');
  }

  void onResult(SpeechRecognitionResult val) async {
    print('onResult()');
    print('val.alternates ${val.alternates}');

    if (val.finalResult) {
      Logger.d('akhil', val.recognizedWords);
      Logger.d('akhil', 'naku am telvadu ra');
      setState(() {
        first = val.recognizedWords;

        totalHeard = '$first $last';

        last = first;

        print(totalHeard);
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
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
        child: Center(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: SingleChildScrollView(
                  reverse: true,
                  child: Container(
                    padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 150.0),
                    child: Text(
                      totalHeard.toString(),
                      style: TextStyle(
                        fontSize: 20,
                        fontFamily: 'pop',
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Stop Recording',
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
                    onTap: () async {
                      Logger.d("Total Heard Data: ", totalHeard.toString());
                      if (totalHeard.isNotEmpty) {
                        stopListening();
                        _stopWatchTimer.rawTime.listen((value) {
                          print(
                              'rawTime $value ${StopWatchTimer.getDisplayTime(value)}');

                          setState(() {
                            timer = value;
                          });
                        });
                        _stopWatchTimer.onStopTimer();

                        String endTime =
                            DateFormat('hh:mm').format(DateTime.now());

                        Logger.d("MyTAG", "${totalHeard.toString()}");

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => RecordAgainScreen(
                                      totalText: totalHeard.toString(),
                                      todayDate: todayDate,
                                      startTime: startTime,
                                      endTime: endTime,
                                      timer: timer!,
                                    )));
                      } else {
                        stopListening();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: const Text('Nothing Heard!'),
                          ),
                        );
                        Future.delayed(Duration(seconds: 2), () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => HomeScreen()));
                        });
                      }
                    },
                    child: AvatarGlow(
                        animate: true,
                        glowColor: Colors.grey,
                        endRadius: 75.0,
                        duration: const Duration(milliseconds: 2000),
                        repeatPauseDuration: const Duration(milliseconds: 100),
                        repeat: true,
                        child: SvgPicture.asset('assets/stop.svg')),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
                    child: Container(
                      height: 57,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Color(0xffFFCA51),
                          borderRadius: BorderRadius.circular(20)),
                      child: Center(
                        child: Text(
                          'Confidence: ${(confidence * 100).toStringAsFixed(1)}%',
                          style: TextStyle(
                            color: Color(0xff006163),
                            fontWeight: FontWeight.w600,
                            fontFamily: 'pop',
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
