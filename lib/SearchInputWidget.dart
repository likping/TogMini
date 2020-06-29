import 'package:flutter/material.dart';
import "./AudioFileStore.dart";
import "./Audio.dart";
import "./Constant.dart";
import "./DbHelper.dart";
import "./SearchHistory.dart";

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

  double height = 50;
  double width = 300;
  Widget build(BuildContext context) {
    return new Container(
        width: 360,
        child: new Stack(
          children: <Widget>[
            new SizedBox(
                width: width,
                height: height,
                child: new TextField(
                  controller: widget.input,
                  focusNode: widget.focusNode,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(0))),
                  ),
                )),
            Positioned(
              top: height,
              child: new Container(
                width: width,
                height: height*2,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.redAccent)
                ),
                child: Center(child:Text("Hello"),),
              ),
            ),
            Positioned(
             left:width,
              child: new SizedBox(
                width: 360 - width - 2,
                height: height,
                child: new FlatButton(
                  onPressed: _search,
                  color: Colors.orangeAccent,
                  padding: EdgeInsets.symmetric(horizontal: 0),
                  child: Icon(
                    Icons.search,
                    size: height,
                    color: Colors.white,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)),
                ))),
          ],
        ));
  }
}
