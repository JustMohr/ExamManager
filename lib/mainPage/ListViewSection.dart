import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:scool_manager/topics/Topic.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

import 'InputContainer.dart';

class ListViewSection extends StatefulWidget {
  @override
  ListViewSectionState createState() => ListViewSectionState();
}

class ListViewSectionState extends State<ListViewSection> {
  static late Function funcAddElement;
  static late Function functionRemoveEntry;
  List<String> list = [];

  @override
  void initState() {
    funcAddElement = addElement;
    functionRemoveEntry = listRemoveElement;
    loadSharedPreferences();
  }

  @override
  Widget build(BuildContext context) {

    return Expanded(
      child: Container(
        //color: Color.fromARGB(255, 191, 191, 191),
        child: Scrollbar(
          child: ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, index) {

              String unsplittString = list.elementAt(index);
              double cardHeight = MediaQuery.of(context).size.height * 0.08;
              Text subjectTxt = Text(unsplittString.substring(8, unsplittString.length), style: TextStyle(fontSize: cardHeight*0.3),);

              String unconvertDate = unsplittString.substring(0, 8);

              String date = DateFormat('dd.MM.yy').format( DateFormat('yy-MM-dd').parse(unconvertDate) );
              Text dateTxt = Text(date);
              //print('print: ${list.elementAt(index).toString()}');

              return Card(
                color: Color.fromARGB(255, 130, 130, 130),
                child: InkWell(
                  child: LsTile(dateTxt, subjectTxt),
                  onTap: (){
                    //card press
                    showDialog(
                        context: context,
                        builder: (context){
                          return Topic(list.elementAt(index));
                        }
                    );
                  },
                ),

              );
            },
          ),
        )
      )
    );
  }

  void addElement(String element){

    list.add(element);
    list.sort((a, b){ //sorting in ascending order
      return a.compareTo(b);
    });
    setSharedPreferences();

    setState(() {});
  }



  void loadSharedPreferences() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //setState(() {
      list = prefs.getStringList('dates')!;
      syncMapAndList();
    //});
  }
  void setSharedPreferences() async{
    //list=[]; //clear list
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('dates', list);
  }


  void listRemoveElement(String entry, bool refresh){
    list.remove(entry);
    setSharedPreferences();

    if(refresh)
      setState(() {});

  }

  void syncMapAndList() async{

    Map map;
    List ls = List.from(list);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? decodedMap = prefs.getString('Topic_Map_Key');

    if (ls == null && decodedMap == null)
      return;
    else if(decodedMap == null)
      map = new Map();
    else
      map = json.decode(decodedMap);


    String dateNowString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime dateTimeNow = DateTime.parse(dateNowString);

    ls.forEach((element) {
      String unconvertDate = element.substring(0, 8);

      if(DateTime.parse('20$unconvertDate').isBefore(dateTimeNow)){
        //print('out of Time: ${DateTime.parse('20$unconvertDate')}');

        map.remove(element);
        listRemoveElement(element, false);

      }
    });

    setState(() {
      TopicState.safeMap(map);
    });


  }


}



class LsTile extends StatelessWidget {

  Text dateTxt;
  Text subjectTxt;
  LsTile(this.dateTxt, this.subjectTxt);

  late double proCardHeight;
  late double proCardWidth;


  @override
  Widget build(BuildContext context) {

    proCardHeight = MediaQuery.of(context).size.height * 0.08;
    proCardWidth = MediaQuery.of(context).size.width * 0.20;

    return ConstrainedBox(

      //height: proCardHeight,
      constraints: BoxConstraints(
        minHeight: proCardHeight,
      ),

      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            spaceWidth(10),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0, 5, 0, 5),
                child: subjectTxt,
              ),
            ),
            spaceWidth(13),
            Expanded(
              flex: 1,
              child: Container(
                child: dateTxt,
              ),
            ),
            SizedBox(
              width: proCardWidth,
              height: proCardHeight *0.6,
              child: ElevatedButton(
                child: Text('edit'),
                style: ElevatedButton.styleFrom(
                  onPrimary: Colors.black,
                  primary: Color.fromARGB(166, 0, 76, 206),
               ),
               onPressed: () {
                 showDialog(
                   barrierDismissible: false,
                     context: context,
                     builder: (_)=>
                     AlertDialog(

                       shape: RoundedRectangleBorder(
                         borderRadius: BorderRadius.circular(20),
                       ),

                       title: Text('Are you sure?'),
                       content: Text('Your topics for "${subjectTxt.data}" will remove!'),
                       actions: [
                         TextButton(
                           child: Text('cancel'),
                           onPressed: (){Navigator.of(context).pop();},
                         ),

                         TextButton(
                           child: Text('remove'),
                           onPressed: (){
                             InputContainerState.functionOnEdit(subjectTxt.data, dateTxt.data);
                             String lEntry = DateFormat('yy-MM-dd').format( DateFormat('dd.MM.yy').parse(dateTxt.data.toString()) ) + subjectTxt.data.toString();
                             ListViewSectionState.functionRemoveEntry(lEntry, true);
                             TopicState.removeMapObject(lEntry);

                             Navigator.of(context).pop();
                           },
                         )
                       ],
                     )
                 );
               },
             ),
           ),
            spaceWidth(10),
          ],
        ),
      ),
    );
  }

  SizedBox spaceWidth(double space){
    return SizedBox(width: space,);
  }
}


