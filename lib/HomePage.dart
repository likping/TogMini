import 'package:flutter/material.dart';
import "package:tog/Widgets/ShowSpaceWidget.dart";
import "package:tog/Widgets/SearchInputWidget.dart";
import 'package:tog/Config/Constant.dart';
import 'package:tog/AudioComponent/Adapt.dart';

class HomePage extends StatefulWidget {
  State createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  TextStyle titleStyle = new TextStyle(color: Colors.orangeAccent);

  TextEditingController input = new TextEditingController();
  FocusNode focusNode = FocusNode();
  Widget build(BuildContext context) {
    return Scaffold(
      body:_buildBody(context),
      resizeToAvoidBottomPadding: false,
    );
  }
  Widget _buildBody(BuildContext context){
    return Container(
        width: MediaQuery.of(context).size.width,
        height:MediaQuery.of(context).size.height,
//          decoration: BoxDecoration(border: Border.all(color: Colors.brown)),
        child: new Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top:MediaQuery.of(context).padding.top ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                child: Text(
                  "TogMini",
                  style: TextStyle(
                    color: Colors.orange,
                    fontSize: 25
                  ),
                ),
              )
            ),
            //todo 搜索框
            new Container(
              width: MediaQuery.of(context).size.width,
              height: 50,
//                decoration: BoxDecoration(border: Border.all(color: Colors.brown)),
              child: SearchInputWidget(input: input, focusNode: focusNode),
            ),
            new Container(
                child: ShowSpaceWidget(
                  input: input,
                  focusNode: focusNode,
                ),

                width:MediaQuery.of(context).size.width,
                height: Adapt.screenH()-Adapt.padTopH()-100
            )
            //todo 底部播放器
          ],
        ));
  }
}
