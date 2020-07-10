import 'package:flutter/material.dart';
import "package:tog/Widgets/RearchListItemWidget.dart";
import "package:tog/AudioComponent/Audio.dart";
import "package:tog/AudioComponent/AudioFileStore.dart";
import 'package:tog/Config//Constant.dart';

enum Process {
  loading,
  finish,
}

class RearchSongList extends StatefulWidget {
  AudioFileStore fileStore = new AudioFileStore();
  State createState() {
    return RearchSongListState();
  }

  TextEditingController input;
  FocusNode focusNode;
  RearchSongList({this.input, this.focusNode});
}

class RearchSongListState extends State<RearchSongList> {
  var process;
  var list = ['a', 'b', 'c'];
  bool clearState = false;
  var _pageController = PageController();
  var netease = null;
  var qq = null;
  var xiami = null;
  var kuwo = null;

  @override
  void initState() {
    super.initState();
    widget.input.addListener(() async {
      var prefs = await Constant.instance.prefs;
      if (prefs.getBool(Constant.instance.rearchKey)) {
        FocusScope.of(context).requestFocus(FocusNode());
        setState(() {
          _rearch();
          prefs.setBool(Constant.instance.rearchKey, false);
          widget.focusNode.unfocus();
        });
      }
    });
  }

  void _rearch() async {
    setState(() {
      process = Process.loading;
    });
    var _netease = await widget.fileStore
        .search(widget.input.text, provider: "netease", page: 1);
    var _qq = await widget.fileStore
        .search(widget.input.text, provider: "qq", page: 1);
    var _xiami = await widget.fileStore
        .search(widget.input.text, provider: "xiami", page: 1);
    var _kuwo = await widget.fileStore
        .search(widget.input.text, provider: "kuwo", page: 1);
    setState(() {
      _netease["pageIndex"] = 0;
      _qq["pageIndex"] = 0;
      _xiami["pageIndex"] = 0;
      _kuwo["pageIndex"] = 0;
      this.netease = _netease;
      this.qq = _qq;
      this.xiami = _xiami;
      this.kuwo = _kuwo;
      process = Process.finish;
    });
  }

  Widget Loading() {
    return new Container(
      child: new Center(
        child: new Column(
          children: <Widget>[
            SizedBox(height: 80),
            CircularProgressIndicator(strokeWidth: 4.0),
            Text("正在加载")
          ],
        ),
      ),
    );
  }

  Widget Finish() {
    return (this.xiami != null &&
            this.kuwo != null &&
            this.netease != null &&
            this.qq != null)
        ? CustomScrollView(
            shrinkWrap: true,
            // 内容
            slivers: [
              SliverPadding(
                padding: const EdgeInsets.all(5),
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      RearchListItem(
                          map: this.qq,
                          name: "qq",
                          input: widget.input,
                          pageview: this._pageController),
                      RearchListItem(
                          map: this.netease,
                          name: "netease",
                          input: widget.input,
                          pageview: this._pageController),
                      RearchListItem(
                          map: this.xiami,
                          name: "xiami",
                          input: widget.input,
                          pageview: this._pageController),
                      RearchListItem(
                          map: this.kuwo,
                          name: "kuwo",
                          input: widget.input,
                          pageview: this._pageController),
                    ],
                  ),
                ),
              ),
            ],
          )
        : new Container(
            child: Center(
              child: Text("Failed"),
            ),
          );
  }

  Widget build(BuildContext context) {
    switch (process) {
      case Process.finish:
        return Finish();
      case Process.loading:
        return Loading();
      default:
        return Container();
    }
  }
}
