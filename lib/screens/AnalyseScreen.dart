import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:flutter_voice_test/screens/HomeScreen.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;

class AnalyseScreen extends StatefulWidget {
  AnalyseScreen(
      {required this.totalText, required this.dateTime, required this.saved});

  String totalText;
  String dateTime;
  bool saved;

  @override
  State<AnalyseScreen> createState() => _AnalyseScreenState();
}

class _AnalyseScreenState extends State<AnalyseScreen> {
  TextEditingController name = TextEditingController();

  String url =
      'https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=AIzaSyAUv0D6S4Ms5pguGTJp4dLEuQg-kZ9AbX0';

  bool isLoading = true;

  bool noData = false;

  bool showTextField = false;

  String? toxicity;
  String? severToxicity;
  String? insult;
  String? profanity;
  String? identityAttack;
  String? threat;

  String? updatedData;

  final _data = Hive.box('data');

  Future<void> _createItem(Map<String, dynamic> newItem) async {
    await _data.add(newItem);
    // _refreshItems(); // update the UI
  }

  sendRequest() async {
    print(widget.totalText.toString());
    print('eekada uuna');
    // if (widget.totalText.isNotEmpty) {
    print('lopala uunara puka');
    var headers = {'Content-Type': 'text/plain'};
    // var request = http.Request(
    //     'POST',
    //     Uri.parse(
    //         'https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=AIzaSyAUv0D6S4Ms5pguGTJp4dLEuQg-kZ9AbX0'));
    var body = await '''{comment: {text: "hello hello hello"},
       languages: ["en"],
       requestedAttributes: {TOXICITY:{},SEVERE_TOXICITY:{},IDENTITY_ATTACK:{},INSULT:{},PROFANITY:{},THREAT:{}} }''';
    // request.headers.addAll(headers);
    //
    // http.StreamedResponse response = await request.send();

    final response = await http.post(
        Uri.parse(
            'https://commentanalyzer.googleapis.com/v1alpha1/comments:analyze?key=AIzaSyAUv0D6S4Ms5pguGTJp4dLEuQg-kZ9AbX0'),
        headers: headers,
        body: body);

    if (response.statusCode == 200) {
      print(response.body);
      setState(() {
        isLoading = false;
      });
      var data = await jsonDecode(response.body);
      setState(() {
        toxicity = data['attributeScores']['TOXICITY']['spanScores'][0]['score']
                ['value']
            .toString();
        severToxicity = data['attributeScores']['SEVERE_TOXICITY']['spanScores']
                [0]['score']['value']
            .toString();
        insult = data['attributeScores']['INSULT']['spanScores'][0]['score']
                ['value']
            .toString();
        profanity = data['attributeScores']['PROFANITY']['spanScores'][0]
                ['score']['value']
            .toString();
        identityAttack = data['attributeScores']['IDENTITY_ATTACK']
                ['spanScores'][0]['score']['value']
            .toString();
        threat = data['attributeScores']['THREAT']['spanScores'][0]['score']
                ['value']
            .toString();
      });
      print('akhil');
    } else {
      print(response.reasonPhrase);
    }
    // } else {
    //   setState(() {
    //     noData = true;
    //   });
    // }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    setState(() {
      updatedData = widget.totalText.substring(0, 5);
    });
    sendRequest();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Color(0xff004E50), Color(0xff003637)])),
        child: noData == true
            ? SafeArea(
                child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'No Data!',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontFamily: 'pop',
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ))
            : SafeArea(
                child: isLoading == true
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: SvgPicture.asset('assets/back.svg')),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  'Analyzed Speech',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontFamily: 'pop',
                                    fontSize: 16,
                                    color: Colors.white,
                                  ),
                                )
                              ],
                            ),
                          ),
                          showTextField == true
                              ? Padding(
                                  padding: EdgeInsets.fromLTRB(30, 0, 30, 0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        height: 43,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                1.5,
                                        decoration: BoxDecoration(
                                            color: Color(0xff26797A),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Padding(
                                          padding:
                                              EdgeInsets.fromLTRB(20, 0, 0, 0),
                                          child: TextField(
                                            controller: name,
                                            style: TextStyle(
                                              color: Colors.white,
                                              // height: 3,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              fontFamily: 'pop',
                                            ),
                                            decoration: InputDecoration(
                                              border: InputBorder.none,
                                              hintText: widget.totalText
                                                  .substring(0, 5),
                                              prefixStyle: TextStyle(
                                                color: Colors.white,
                                                height: 3,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'pop',
                                              ),
                                              hintStyle: TextStyle(
                                                color: Colors.white,
                                                height: 3,
                                                fontSize: 16,
                                                fontWeight: FontWeight.w500,
                                                fontFamily: 'pop',
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            updatedData = name.text;
                                            showTextField = false;
                                          });
                                        },
                                        icon: Icon(
                                          Icons.done,
                                          color: Color(0xffFFCA51),
                                        ),
                                      )
                                    ],
                                  ),
                                )
                              : Padding(
                                  padding: EdgeInsets.fromLTRB(30, 15, 0, 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${updatedData}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w600,
                                          fontFamily: 'pop',
                                          fontSize: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                      widget.saved == true
                                          ? SizedBox()
                                          : IconButton(
                                              onPressed: () {
                                                setState(() {
                                                  showTextField = true;
                                                });
                                              },
                                              icon: SvgPicture.asset(
                                                  'assets/edit.svg'))
                                    ],
                                  ),
                                ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 0, 0, 0),
                            child: Text(
                              '${widget.dateTime}',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                fontFamily: 'pop',
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(30, 15, 30, 0),
                            child: Container(
                              height: 260,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                  color: Color(0xff26797A),
                                  borderRadius: BorderRadius.circular(15)),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 20, 0, 20),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      children: [
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Toxicity',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${toxicity?.substring(0, 4)}%',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          )
                                        ])),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Sever Toxicity',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${severToxicity?.substring(0, 4)}%',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          )
                                        ])),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Insult',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${insult?.substring(0, 4)}%',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          )
                                        ])),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Profanity',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${profanity?.substring(0, 4)}%',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          )
                                        ])),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Identity Attack',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${identityAttack?.substring(0, 4)}%',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          )
                                        ])),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        RichText(
                                            text: TextSpan(children: [
                                          TextSpan(
                                            text: 'Threat',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 18,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          ),
                                          TextSpan(
                                            text:
                                                '  ${threat?.substring(0, 4)}%',
                                            style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              fontFamily: 'pop',
                                              color: Colors.white,
                                            ),
                                          )
                                        ])),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          // Padding(
                          //   padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                          //   child: Row(
                          //     mainAxisAlignment: MainAxisAlignment.center,
                          //     children: [
                          //       Text(
                          //         'Word count',
                          //         style: TextStyle(
                          //           fontWeight: FontWeight.w600,
                          //           fontSize: 16,
                          //           fontFamily: 'pop',
                          //           color: Colors.white,
                          //         ),
                          //       ),
                          //       SizedBox(
                          //         width: 10,
                          //       ),
                          //       Container(
                          //         height: 25,
                          //         width: 67,
                          //         decoration: BoxDecoration(
                          //           borderRadius: BorderRadius.circular(20),
                          //           gradient: LinearGradient(colors: [
                          //             Color(0xffFFAA98),
                          //             Color(0xffFF7456)
                          //           ]),
                          //         ),
                          //         child: Center(
                          //           child: Text(
                          //             '34',
                          //             style: TextStyle(
                          //               fontFamily: 'pop',
                          //               fontSize: 14,
                          //               fontWeight: FontWeight.w600,
                          //               color: Colors.white,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ],
                          //   ),
                          // ),
                          widget.saved == true
                              ? Container()
                              : Padding(
                                  padding: EdgeInsets.fromLTRB(0, 150, 0, 0),
                                  child: Align(
                                    alignment: Alignment.bottomCenter,
                                    child: GestureDetector(
                                      onTap: () async {
                                        _createItem({
                                          "name": updatedData,
                                          "description": widget.totalText,
                                          "dateTime": widget.dateTime,
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            content:
                                                const Text('Recording Saved!'),
                                          ),
                                        );
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    HomeScreen()));
                                      },
                                      child: Container(
                                        height: 35,
                                        width: 150,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          gradient: LinearGradient(colors: [
                                            Color(0xffFFAA98),
                                            Color(0xffFF7456)
                                          ]),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'Save Data',
                                            style: TextStyle(
                                              fontFamily: 'pop',
                                              fontSize: 14,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                        ],
                      ),
              ),
      ),
    ));
  }
}
