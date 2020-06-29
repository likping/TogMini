import 'package:flutter/material.dart';
import "./ShowSpaceWidget.dart";
import "./SearchInputWidget.dart";
import './Constant.dart';

class HomePage extends StatefulWidget{
  State createState(){
      return HomePageState();
  }
}
class HomePageState extends State<HomePage>{
  TextStyle titleStyle=new TextStyle(
    color:Colors.orangeAccent
  );

  TextEditingController input=new TextEditingController();
  FocusNode focusNode = FocusNode();
  Widget build(BuildContext context){
    return Scaffold(
      appBar: new AppBar(
            title: new Text("Tog Mini",style:titleStyle ,),
            backgroundColor:Colors.white
      ),
      body: new Container(
              width: 360,
              height: 700,

              child:  new Column(
                children: <Widget>[
                  //todo 搜索框
                  SearchInputWidget(input: input,focusNode:focusNode),
                  //todo 底部播放器
                  ShowSpaceWidget(input: input,focusNode: focusNode,)
                ],
      )
    ),
      resizeToAvoidBottomPadding: false,
    );
  }
}