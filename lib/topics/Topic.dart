import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Topic extends StatefulWidget {
  final String mapKey;
  Topic(this.mapKey);

  @override
  TopicState createState() => TopicState();
}

class TopicState extends State<Topic> {

  final txtController = TextEditingController();
  static Map map = new Map();
  int counter = 0;

  @override
  void initState() {
    loadMap();
  }

  @override
  Widget build(BuildContext context) {

    final double keyboardSize = MediaQuery.of(context).viewInsets.bottom;

    if (keyboardSize == 0)
      return keyboardHide();
    else
      return keyboardShown();
  }

  Center keyboardHide() {

    return Center(
      child: Material(
        type: MaterialType.transparency,
        child: Container(
            width: MediaQuery.of(context).size.width * 0.8,
            height: MediaQuery.of(context).size.height * 0.8,
            decoration: const BoxDecoration(
                color: Color.fromARGB(255, 175, 175, 175),
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Padding(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: [
                    InkWell(
                      child: const Text(
                        'topics',
                        style: TextStyle(
                          //decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          //fontSize: 17,
                        ),
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        //close keyboard
                        FocusManager.instance.primaryFocus?.unfocus();
                      },
                    ),
                    Divider(color: Color.fromARGB(255, 90, 89, 90), height: 7, thickness: 1,),
                    Expanded(
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child:SingleChildScrollView(
                          child:SizedBox(
                            height: MediaQuery.of(context).size.height * 0.7,//----------------------------?
                          child: TextField(
                          controller: txtController,
                          textInputAction: TextInputAction.newline,
                          maxLines: null,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                          ),
                          onChanged: (value) {
                            //print(value.substring(value.length - 1, value.length));
                            if (value.substring(
                                        value.length - 1, value.length) ==
                                    '\n' &&
                                counter < value.length) {
                              txtController.text = txtController.text + '- ';
                              txtController.selection =
                                  TextSelection.fromPosition(TextPosition(
                                      offset: txtController.text.length));
                            }
                            counter = txtController.text.length;
                            dataToMap(value);
                          },
                        ),
                          )
                        )
                      ),
                    ),
                  ],
                ))),
      ),
    );
  }

  Material keyboardShown() {

    return Material(
      type: MaterialType.transparency,
      child: Container(
          child: Align(
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*0.03),
                Container(
                  decoration: const BoxDecoration(
                      color: Color.fromARGB(255, 175, 175, 175),
                      borderRadius: BorderRadius.all(Radius.circular(20))),
                  height: MediaQuery.of(context).size.height * 0.45,
                  width: MediaQuery.of(context).size.width * 0.8,
                  child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: [
                          InkWell(
                            child: const Text(
                              'topics',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                //fontSize: 17,
                                //decoration: TextDecoration.underline,
                              ),
                            ),
                            onTap: () {
                              //Navigator.pop(context);
                              //close keyboard
                              FocusManager.instance.primaryFocus?.unfocus();
                            },
                          ),
                          Divider(color: Color.fromARGB(255, 90, 89, 90),height: 7, thickness: 1,),
                          Expanded(
                            child: Scrollbar(
                              isAlwaysShown: true,
                              child: SingleChildScrollView(
                                child: TextField(
                                controller: txtController,
                                autofocus: true,
                                textInputAction: TextInputAction.newline,
                                maxLines: null,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                ),
                                onChanged: (value) {
                                  if (value.substring(value.length - 1, value.length) =='\n' && counter < value.length) {
                                    txtController.text = txtController.text + '- ';
                                    txtController.selection = TextSelection.fromPosition(TextPosition(offset: txtController.text.length));
                                  }
                                  counter = txtController.text.length;
                                  dataToMap(value);
                                },
                              ),
                            ),
                          )
                        ),
                        ],
                      )),
                ),
              ],
            )
          )),
    );
  }


  void dataToMap(String value) {
    map[widget.mapKey] = value;

    safeMap(map);
  }

  void loadMap() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? decodedMap = prefs.getString('Topic_Map_Key');

    if (decodedMap == null)
      map = new Map();
    else
      map = json.decode(decodedMap);

    //fill card
    if (map.containsKey(widget.mapKey))
      txtController.text = map[widget.mapKey];
    else
      txtController.text = '- ';
  }

  static void safeMap(Map safeMap) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String encodeMap = json.encode(safeMap);

    prefs.setString('Topic_Map_Key', encodeMap);
  }

  static void removeMapObject(String mapKey) async {
    //print('remove map object: $mapKey');

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? decodedMap = prefs.getString('Topic_Map_Key');

    if (decodedMap == null)
      map = new Map();
    else
      map = json.decode(decodedMap);

    if (map.containsKey(mapKey)) {
      map.remove(mapKey);
      safeMap(map);
    }
  }
}
