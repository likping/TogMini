import 'package:flutter/material.dart';
import "./Audio.dart";
import "./Constant.dart";
import "dart:convert";
import "AudioFileStore.dart";
import "./Player.dart";

class ListViewItemWidget extends StatefulWidget {
  State createState() {
    return ListViewItemState();
  }

  AudioFileStore fileStore = new AudioFileStore();
  Audio audio;
  int id;
  var delete;
  ListViewItemWidget({this.audio, this.id,this.delete});
}

class ListViewItemState extends State<ListViewItemWidget> {
  int audioIndex;
  @override
  void initState() {
    // TODO: implement initState

    this.audioIndex = widget.id;
  }

  void _delete() async {
    print("delelet ${this.audioIndex}");
    var prefs = await Constant.instance.prefs;
    var audios = await getAudios();
    audios.removeAt(this.audioIndex);
    var value = jsonEncode(audios.map((f) => f.toJson()).toList());
    prefs.setString(Constant.instance.audiosKey, value);
    if (mounted) {
      setState(() {});
    }
  }
  ////整个App，控制播放相关的函数
  void _play() async {
    var prefs = await Constant.instance.prefs;
    prefs.setInt(Constant.instance.audioiIndex, widget.id);
    await setAudioIndex(widget.id); //更新播放索引
    int _audioIndex = await getAuioIndex(); //获得更新的播放索引
    Audio audio = await getAudio(_audioIndex); //得到当前索引的音频对象

    if (mounted) {
      setState(() {
        this.audioIndex = _audioIndex;
      });
    }
    await playSong(audio); //播放
  }

  void playSong(Audio audio) async {
    widget.fileStore.songSource(audio.songSourceLink).then((audio) {
      Player.instance.play(audio);
    });
  }


  Future<Audio> getAudio(int audioIndex) async {
    var audios = await getAudios();
    return audios[audioIndex];
  }

  setAudioIndex(int audioIndex) async {
    var prefs = await Constant.instance.prefs;
    prefs.setInt(Constant.instance.audioiIndex, audioIndex);
    return audioIndex;
  }

  getAuioIndex() async {
    var prefs = await Constant.instance.prefs;
    int audioIndex = prefs.getInt(Constant.instance.audioiIndex);
    return audioIndex;
  }

  Future<List<Audio>> getAudios() async {
    var prefs = await Constant.instance.prefs;
    var json = jsonDecode(prefs.get(Constant.instance.audiosKey));
    var value = (json as List<dynamic>);
    var audios = value.map((f) => Audio.fromJson(f)).toList();
    return audios;
  }

  /////
  Widget build(BuildContext context) {
    return new Container(
        width: 360,
        height: 50,
        margin: EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            border: Border(bottom: BorderSide(color: Colors.black12))),
        child: new Row(children: <Widget>[
          new Container(
              width: 100,
              height: 50,
              child: new Center(child: new Text("${widget.audio.name}"))),
          new Container(
              width: 50,
              height: 50,
              margin: EdgeInsets.only(left: 150),
              child: new Center(
                child: new FlatButton(
                  onPressed: _play,
                  child: Icon(Icons.play_circle_outline),
                  padding: EdgeInsets.symmetric(horizontal: 0),
                ),
              )),
          new Container(
            width: 50,
            height: 50,
            margin: EdgeInsets.only(left: 5),
            child: new FlatButton(
              onPressed: widget.delete,
              child: Icon(Icons.delete),
              padding: EdgeInsets.symmetric(horizontal: 0),
            ),
          )
        ]));
  }
}
