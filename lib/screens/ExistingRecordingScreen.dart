import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:hive/hive.dart';

import 'AnalyseScreen.dart';

class ExistingRecordingScreen extends StatefulWidget {
  const ExistingRecordingScreen({Key? key}) : super(key: key);

  @override
  State<ExistingRecordingScreen> createState() =>
      _ExistingRecordingScreenState();
}

class _ExistingRecordingScreenState extends State<ExistingRecordingScreen> {
  // List<SavedData> _tasks = [];

  // final box = GetStorage(); // list of maps gets stored here

  // separate list for storing maps/ restoreTask function
  //populates _tasks from this list on initState

  // List storageList = [];

  bool empty = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshItems();
  }

  final _data = Hive.box('data');

  List<Map<String, dynamic>> _items = [];

  void _refreshItems() {
    final data = _data.keys.map((key) {
      final value = _data.get(key);
      return {
        "key": key,
        "name": value["name"],
        "description": value['description'],
        "dateTime": value['dateTime']
      };
    }).toList();

    setState(() {
      _items = data.reversed.toList();
      // we use "reversed" to sort items in order from the latest to the oldest
    });
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                child: Row(
                  children: [
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: SvgPicture.asset(
                          'assets/back_blue.svg',
                          color: Color(0xffDFBD53),
                        )),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      'Select speech to analyze',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'pop',
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              _items.isEmpty
                  ? Padding(
                      padding: EdgeInsets.fromLTRB(
                          0, MediaQuery.of(context).size.height / 3, 0, 0),
                      child: Text(
                        'No Recorded data saved!',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: 'pop',
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _items.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.fromLTRB(30, 30, 30, 0),
                          child: Container(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      _items[index]['name'].toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'pop',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 20,
                                      ),
                                    ),
                                    Text(
                                      _items[index]['dateTime'].toString(),
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'pop',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 12,
                                      ),
                                    )
                                  ],
                                ),
                                GestureDetector(
                                  onTap: () {
                                    // printTasks();
                                    //show in already analyzed data screen
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AnalyseScreen(
                                                  totalText: _items[index]
                                                      ['description'],
                                                  dateTime: _items[index]
                                                      ['dateTime'],
                                                  saved: true,
                                                )));
                                  },
                                  child: Container(
                                    height: 32,
                                    width: 107,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                            color: Color(0xffDFBD53),
                                            width: 3)),
                                    child: Center(
                                      child: Text(
                                        'Analyse',
                                        style: TextStyle(
                                          color: Color(0xffDFBD53),
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          fontFamily: 'pop',
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      }),
            ],
          ),
        ),
      ),
    ));
  }
}
