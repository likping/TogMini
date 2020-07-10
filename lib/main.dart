import 'package:flutter/material.dart';
import "./HomePage.dart";
//import "package:tog/SwitchWidgets//home_page.dart";
import "./LoginPage.dart";
void main() => runApp(MyApp());
class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
        home: HomePage(),
    );
  }
}
