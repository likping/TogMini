import 'package:flutter/material.dart';
import "./SongListWidget.dart";
import "./Constant.dart";
import "dart:convert";
import "./AudioFileStore.dart";
import "./Audio.dart";
import "./Player.dart";
import "package:audioplayers/audioplayers.dart";

class MusicControWidget extends StatefulWidget {
  AudioFileStore fileStore = new AudioFileStore();
  State createState() {
    return MusicControState();
  }

  final reverseVisible;
  final detailVisible;
  MusicControWidget({this.reverseVisible, this.detailVisible});
}

class MusicControState extends State<MusicControWidget> {
  List<Audio> audios;
  int audioIndex = 0;
  Audio CurrentAudio;
  var muvisible;
  var detailvisible;
  bool pause = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    muvisible = false;
    detailvisible = false;
    refesh();
  }

  void playSong(Audio audio) {
    widget.fileStore.songSource(audio.songSourceLink).then((audio) {
      Player.instance.play(audio);
    });
  }

  Future<Audio> getAudio() async {
    var audios = await getAudios();
    return audios[this.audioIndex];
  }

  setAudioIndex() async {
    var prefs = await Constant.instance.prefs;
    prefs.setInt(Constant.instance.audioiIndex, this.audioIndex);
  }

  getAuioIndex() async {
    var prefs = await Constant.instance.prefs;
    this.audioIndex = prefs.getInt(Constant.instance.audioiIndex);
  }

  Future<List<Audio>> getAudios() async {
    var prefs = await Constant.instance.prefs;
    var json = jsonDecode(prefs.get(Constant.instance.audiosKey));
    var value = (json as List<dynamic>);
    var audios = value.map((f) => Audio.fromJson(f)).toList();
    return audios;
  }

  void refesh() async {
    this.CurrentAudio = await getAudio();
    playSong(this.CurrentAudio);
    Player.instance.audioPlayer.onPlayerStateChanged
        .listen((AudioPlayerState s) async {
      await getAuioIndex();
      if (s == AudioPlayerState.PLAYING) {
        Audio CurrentAudio = await getAudio();
        setState(() {
          this.CurrentAudio = CurrentAudio;
          print(this.CurrentAudio.name);
        });
      }
      print("Current player state: $s");
    });
    Player.instance.onCompletion(() async {
      print("Next Song");
      this.audios = await getAudios();
      setState(() {
        this.audioIndex += 1;
        if (this.audioIndex >= this.audios.length) {
          this.audioIndex = 0;
        }
      });
      await setAudioIndex();
      await getAuioIndex();
      this.CurrentAudio = await getAudio();
      playSong(this.CurrentAudio);
    });
  }

  void _pause() async {
    setState(() {
      this.pause = !this.pause;
      if (!this.pause) {
        Player.instance.resume();
      } else {
        Player.instance.pause();
      }
    });
  }

  void _detail() {
    setState(() {
      this.detailvisible = !this.detailvisible;
      widget.detailVisible(this.detailvisible);

    });
  }

  void _list() async {
    var prefs = await Constant.instance.prefs;

    setState(() {
      this.muvisible = !this.muvisible;
      widget.reverseVisible(this.muvisible);

      //  print(prefs.get(Constant.instance.audiosKey));
    });
  }

  Widget build(BuildContext context) {
    double IconSize = 50;
    return new Container(
      width: 360,
      height: 120,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          color: Color.fromRGBO(2, 2, 2, 1)),
      child: Row(
        children: <Widget>[
          //todo 音乐描述
          new SizedBox(
            width: 230,
            child: FlatButton(
                onPressed: _detail,
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: new Row(
                  children: <Widget>[
                    new Container(
                      width: 230,
                      height: 120,
                      child: Center(
                          child: new Text(
                        "${this.CurrentAudio?.name}",
                        style: new TextStyle(
                            color: !this.detailvisible?Colors.white:Colors.orange
                        ),
                        overflow: TextOverflow.ellipsis,
                      )),
                    )
                  ],
                )),
          ),
          //todo 播放控制
          new Container(
              width: IconSize,
              height: IconSize,
              child: new FlatButton(
                onPressed: _pause,
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: !this.pause
                    ? Icon(
                        Icons.pause,
                        size: IconSize / 2,
                        color: Colors.white,
                      )
                    : Icon(
                        Icons.play_arrow,
                        size: IconSize / 2,
                        color: Colors.orange,
                      ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color:  !this.pause?Colors.white:Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(IconSize)),
              )),
          //todo 列表控制
          new Container(
              width: IconSize,
              height: IconSize,
              margin: EdgeInsets.only(left: 20),
              child: new FlatButton(
                onPressed: _list,
                padding: EdgeInsets.symmetric(horizontal: 0),
                child: Icon(
                  Icons.storage,
                  size: IconSize / 2,
                  color: !this.muvisible?Colors.white:Colors.orange,
                ),
                shape: RoundedRectangleBorder(
                    side: BorderSide(
                      color: !this.muvisible?Colors.white:Colors.orange,
                    ),
                    borderRadius: BorderRadius.circular(5)),
              ))
        ],
      ),
    );
  }
}
