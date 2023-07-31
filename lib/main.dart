import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scool_manager/mainPage/ListViewSection.dart';

import 'package:scool_manager/mainPage/InputContainer.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
  runApp(App());
}

class App extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color.fromARGB(255, 210, 210, 210),
        body: Body(),
      )
    );
  }
}



class Body extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Column(
        //crossAxisAlignment: CrossAxisAlignment.start,

        children: [

          InputContainer(),
          Divider(color: Color.fromARGB(255, 90, 89, 90),/*height: 10,*/ thickness: 1,),
          SizedBox(height: 10),
          ListViewSection(),

        ],
      ),
    );

  }
}


