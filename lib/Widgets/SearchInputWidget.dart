import 'package:flutter/material.dart';
import "package:tog/AudioComponent/AudioFileStore.dart";
import "package:tog/AudioComponent/Audio.dart";
import 'package:tog/Config//Constant.dart';
import 'package:tog/Activity//DbHelper.dart';
import 'package:tog/Config//SearchHistory.dart';
import "package:tog/AudioComponent/Adapt.dart";
class SearchInputWidget extends StatefulWidget {
  State createState() {
    return SearchInputState();
  }

  TextEditingController input;
  FocusNode focusNode;
  SearchInputWidget({this.input,this.focusNode});
}

class SearchInputState extends State<SearchInputWidget> {
  DbHelper searchHistoryProvider = DbHelper();

  void _search() async {
    var prefs = await Constant.instance.prefs;
    prefs.setBool(Constant.instance.rearchKey, true);

    widget.input.text = widget.input.text;
    this.searchHistoryProvider
          .insertHistory(new SearchHistory(widget.input.text))
          .then((value) {
        setState(() {

        });
      });
  }
  double height = Adapt.px(50);
  double width =  Adapt.px(300);
  Widget build(BuildContext context) {
    return new Container(
        width: 360,
        child: new Stack(
          children: <Widget>[
            new SizedBox(
                width: width,
                height: height,

                child: Padding(
                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                    child: new TextField(
                  controller: widget.input,
                  focusNode: widget.focusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(50))),
                  ),
                ))),
            Positioned(
             left:width,
              child: new SizedBox(
                width: Adapt.px(360) - width,
                height: height-10,
                child:  Padding(
                   padding: EdgeInsets.symmetric(horizontal: 5,vertical: 5),
                    child:RaisedButton(
                  elevation: 5,
                  onPressed: _search,
                  color: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Icon(
                    Icons.search,
                    size: height-10,
                    color: Colors.white,

                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100)),
                )))),
          ],
        ));
  }
}
