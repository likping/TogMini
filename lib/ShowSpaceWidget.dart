import 'package:flutter/material.dart';
import './PlayingListWidget.dart';
import "./MusciControWidget.dart";
import "./RearchSongListWidget.dart";
import "./PlayerMusicWidget.dart";
import './Audio.dart';
import './AudioFileStore.dart';
import "./Player.dart";
import "package:audioplayers/audioplayers.dart";
import "./Constant.dart";
import "dart:convert";
import "./DbHelper.dart";
import "./SearchHistory.dart";
import "package:permission_handler/permission_handler.dart";
import 'package:flutter/cupertino.dart';
import "./BottomDragWidget.dart";
class ShowSpaceWidget extends StatefulWidget {
  AudioFileStore fileStore;
  TextEditingController input;
  FocusNode focusNode;
  State createState() {
    return ShowSpaceState();
  }

  ShowSpaceWidget({this.fileStore, this.input, this.focusNode}) {
    if (this.fileStore == null) {
      this.fileStore = AudioFileStore();
    }
  }
}

class ShowSpaceState extends State<ShowSpaceWidget>
    with TickerProviderStateMixin {
  bool isOff = true;
  var muListvisible;
  double ContainHeight;
  var detailMusicVisible;
  double PlayerHeight;
  Animation animation;
  AnimationController controller;
  Future<bool> _requestPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    List<bool> results = permissions.values.toList().map((status) {
      return status == PermissionStatus.granted;
    }).toList();
    return !results.contains(false);
  }

  List<SearchHistory> _history = [];
  void initState() {
    this.controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);

    final CurvedAnimation curve =
        CurvedAnimation(parent: controller, curve: Curves.easeIn);

    // 变化的值
    animation = Tween(begin: 0.0, end: 1.0).animate(curve);
    controller.forward();
    setState(() {
      muListvisible = false;
      detailMusicVisible = false;
      ContainHeight = 462;
      PlayerHeight = 120;
      Player.instance.stop();
      refeshPlayingList();
    });
  }

  void dispose() {
    print("退出");
  }

  void refeshPlayingList() async {
    await _requestPermissions();
    var prefs = await Constant.instance.prefs;
    var _audios = await DbHelper.instance.queryAllPlayList();
    setState(() {
      var value = jsonEncode(_audios.map((f) => f.toJson()).toList());
      prefs.setString(Constant.instance.audiosKey, value);
      prefs.setInt(Constant.instance.audioiIndex, 0);
      prefs.setBool(Constant.instance.rearchKey, false);
    });
//    widget.fileStore.hot("netease").then((files) {
//      setState(() {
//        var value = jsonEncode(files.map((f) => f.toJson()).toList());
//        prefs.setString(Constant.instance.audiosKey, value);
//        prefs.setInt(Constant.instance.audioiIndex, 0);
//        prefs.setBool(Constant.instance.rearchKey, false);
//      });
//    });
    widget.focusNode.addListener(() async {
      if (widget.focusNode.hasFocus) {
        List<SearchHistory> _history =
            await DbHelper.instance.queryAllHistory();
        print("history");
        setState(() {
          this._history = _history;
          this.isOff = false;
        });
      } else {
        setState(() {
          this.isOff = true;
        });
      }
    });
  }

  bool _reverseaVisible(bool visible) {
    setState(() {
      muListvisible = visible;
      print(muListvisible);
    });
    return muListvisible;
  }

  bool _detailVisible(bool visible) {
    setState(() {
      detailMusicVisible = visible;

      print(detailMusicVisible);
    });
    return detailMusicVisible;
  }
  bool _reverseaVisDrag(){
    return muListvisible;
  }
  bool _detailVisDrag(){
    return detailMusicVisible;
  }
  get playerTop {
    return this.ContainHeight - this.PlayerHeight;
  }

  void _delete(int index) async {
    await DbHelper.instance.deleteHistoryById(this._history[index].id);
    List<SearchHistory> _history = await DbHelper.instance.queryAllHistory();

    setState(() {
      this._history = _history;
    });
  }

  void _research(int index) async {
    var prefs = await Constant.instance.prefs;
    setState(() {
      widget.input.text = this._history[index].keyword;
      prefs.setBool(Constant.instance.rearchKey, true);
    });
  }

  Widget build(BuildContext context) {
    return new Container(
      width: 360,
      height: ContainHeight,
      child: new Stack(
        children: <Widget>[
          //todo 展示搜索返回的数据列表
          new Positioned(
              child: new Container(
                  width: 360,
                  height: ContainHeight,
                  child: RearchSongList(
                    input: widget.input,
                    focusNode: widget.focusNode,
                  ))),
          //todo 播放列表
          new Positioned(
            bottom: PlayerHeight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                var tween =
                    Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0));
                return SlideTransition(
                  child: child,
                  position: tween.animate(animation),
                );
              },
              child: !this.muListvisible
                  ? Container(key: ValueKey<bool>(this.muListvisible))
                  : PlayingList(
                      ParentContainerHeight: ContainHeight,
                    ),
            ),
          ),
          //todo 播放器更细节
          new Positioned(
            bottom: PlayerHeight,
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 250),
              transitionBuilder: (Widget child, Animation<double> animation) {
                var tween =
                    Tween<Offset>(begin: Offset(0, 1), end: Offset(0, 0));
                return SlideTransition(
                  child: child,
                  position: tween.animate(animation),
                );
              },
              child: !this.detailMusicVisible
                  ? Container(key: ValueKey<bool>(this.detailMusicVisible))
                  : PlayerMusicWidget(ParentContainerHeight: ContainHeight),
            ),
          ),

          //todo 搜索的历史列表
          new Positioned(
            child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                transitionBuilder: (Widget child, Animation<double> animation) {
                  var tween =
                      Tween<Offset>(begin: Offset(0, -1), end: Offset(0, 0));
                  return SlideTransition(
                    child: child,
                    position: tween.animate(animation),
                  );
                },
                child: Offstage(
                    offstage: this.isOff,
                    key: ValueKey<bool>(this.isOff),
                    child: Container(
                      width: 300,
                      height: (this._history.length*50.0)< (ContainHeight/2)?(this._history.length*50.0):(ContainHeight/2),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Color.fromRGBO(125, 125, 125, 0.3),
                                blurRadius: 5)
                          ]),
                      child: ListView.builder(
                          itemCount: this._history.length,
                          itemBuilder: (BuildContext context, int index) {
                            return new Container(
                              width: 300,
                              height:50.0,
                              child: new Row(
                                children: <Widget>[
                                  new Container(
                                      width: 150,
                                      height: 50,
                                      child: new Center(
                                          child: new FlatButton(
                                              padding: EdgeInsets.symmetric(
                                                  horizontal: 0),
                                              onPressed: () => _research(
                                                  this._history.length -
                                                      1 -
                                                      index),
                                              child: new Text(
                                                "${this._history[this._history.length - 1 - index].keyword}",
                                                overflow: TextOverflow.ellipsis,
                                              )))),
                                  new FlatButton(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 0),
                                      onPressed: () => _delete(
                                          this._history.length - 1 - index),
                                      child: Icon(Icons.delete))
                                ],
                              ),
                            );
                          }),
                    ))),
          ),

          //todo 播放器
//          new Positioned(
//              top: this.playerTop,
//
//          ),
          new Positioned(

              child: BottomDragWidget(
                  reverseVisible: () => _reverseaVisDrag(),
                  detailVisible: () => _detailVisDrag(),
                  child: MusicControWidget(
                    reverseVisible: (visible) => _reverseaVisible(visible),
                    detailVisible: (visible) => _detailVisible(visible),
                  )
              )
          )
        ],
      ),
    );
  }
}
