import 'package:flutter/material.dart';
class SongListWidget extends StatefulWidget{
  State createState(){
    return SongListState();
  }

}
class SongListState extends State<SongListWidget>{
  Widget build(BuildContext context){
     return Image.network("https://www.baidu.com/img/flexible/logo/pc/result.png");
  }
}