import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'ListViewSection.dart';

class InputContainer extends StatefulWidget{
  @override
  State<StatefulWidget> createState() => InputContainerState();
}

class InputContainerState extends State<InputContainer> {

  final subjectTxtController = TextEditingController();
  final dateTxtController = TextEditingController();
  static late Function functionOnEdit;
  
  int dateTextlength = 0;

  @override
  void initState() {
    functionOnEdit = onEdit;
  }

  @override
  Widget build(BuildContext context) {

    return Container(
        height: 60,
        //width: MediaQuery.of(context).size.width,
        //color: Color.fromARGB(255, 210, 210, 210),
        child: Row(
          children: <Widget>[
            Expanded(
              flex: 4,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: subjectTxtController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    border: OutlineInputBorder(),
                    hintText: 'subject',
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 3,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: TextField(
                  controller: dateTxtController,
                  decoration: const InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                    border: OutlineInputBorder(),
                    hintText: 'dd/mm/yy',
                    counterText: '',
                  ),
                  maxLength: 8,
                  keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp("[0-9/]")),
                    ],
                  onChanged:(value){
                    dateInputListener(value);
                  },
                  onTap: (){
                    dateTxtController.selection = TextSelection.fromPosition(TextPosition(offset: dateTxtController.text.length));
                  },
                  enableInteractiveSelection: false,
                ),
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(10),
                child: ElevatedButton(
                  child: Text('add'),
                  style: ElevatedButton.styleFrom(
                    primary: Color.fromARGB(217, 0, 76, 206),
                    onPrimary: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: (){
                    setState(() {
                      _addDate();
                    });
                  },
                ),

              ),
            ),

          ],
        )
    );
  }


  void _addDate(){
    String date = dateTxtController.text;
    String subject = subjectTxtController.text;

    if(subject.isEmpty || subject.length < 2 ){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Check your input"),
      ));
      return;
    }

    if(!isDateValid(date)){
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Check your date"),
      ));
      return;
    }


    dateTxtController.text = '';
    subjectTxtController.text = '';

    String convertDate = DateFormat('yy-MM-dd').format( DateFormat('dd/MM/yy').parse(date) );

    String dataStream = convertDate + subject;
    ListViewSectionState.funcAddElement(dataStream);

    //close keyboard
    FocusManager.instance.primaryFocus?.unfocus();
  }


  bool isDateValid(String inputDate){

    String convertDate;

    try{
      convertDate = DateFormat('dd/MM/yy').format( DateFormat('dd/MM/yy').parse(inputDate) );
    }on Exception catch (_) {
      //print('parse error');
      return false;
    }
    //print('$inputDate vs $convertDate');

    if(inputDate != convertDate)
      return false;

    String dateNowString = DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime dateTimeNow = DateTime.parse(dateNowString);

    String convertCheckDateString = DateFormat('yyyy-MM-dd').format( DateFormat('dd/MM/yy').parse(inputDate) );

    //print('to check: ${DateTime.parse(convertCheckDateString)} vs $dateTimeNow');
    if(DateTime.parse(convertCheckDateString).isBefore(dateTimeNow)){
      return false;
    }

    return true;
  }

  onEdit(String subject, String date){
    subjectTxtController.text = subject;
    dateTxtController.text = DateFormat('dd/MM/yy').format( DateFormat('dd.MM.yy').parse(date) );
  }

  void dateInputListener(String value) {
    if (value.length > dateTextlength) {
      if (value.length == 2 || value.length == 5)
        dateTxtController.text = value + '/';
    } else {
      if (value.length == 2 || value.length == 5)
        dateTxtController.text = value.substring(0, value.length - 1);
    }
    dateTextlength = dateTxtController.text.length;
    dateTxtController.selection = TextSelection.fromPosition(TextPosition(offset: dateTxtController.text.length));
  }

}
