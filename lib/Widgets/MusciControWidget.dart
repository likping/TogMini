import 'package:flutter/material.dart';
import "package:tog/Widgets/SongListWidget.dart";
import 'package:tog/Config//Constant.dart';
import "dart:convert";
import "package:tog/AudioComponent/AudioFileStore.dart";
import "package:tog/AudioComponent/Audio.dart";
import "package:tog/Activity//Player.dart";
import "package:audioplayers/audioplayers.dart";
import 'package:tog/Config//defaultAudio.dart';
import 'package:tog/Activity//DbHelper.dart';
class MusicControWidget extends StatefulWidget {
  AudioFileStore fileStore = new AudioFileStore();
  State createState() {
    return MusicControState();
  }

  final reverseVisible;
  final detailVisible;
  double containerHeight;
  MusicControWidget({this.reverseVisible, this.detailVisible,this.containerHeight});
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
      try{
        Player.instance.play(audio);
      }catch(error){

      };

    });
    setState(() {
      this.CurrentAudio=audio;

    });
  }

  Future<Audio> getAudio() async {
    var audios = await getAudios();
    return audios[this.audioIndex];
  }

  setAudioIndex() async {
    var prefs = await Constant.instance.prefs;
    await prefs.setInt(Constant.instance.audioiIndex, this.audioIndex);
  }

  getAuioIndex() async {
    var prefs = await Constant.instance.prefs;
    this.audioIndex = await prefs.getInt(Constant.instance.audioiIndex);
  }

  Future<List<Audio>> getAudios() async {
    var prefs = await Constant.instance.prefs;
    var json = jsonDecode(await prefs.get(Constant.instance.audiosKey));
    var value = (json as List<dynamic>);
    var audios = value.map((f) => Audio.fromJson(f)).toList();
    return audios;
  }
  void _addPlayContoll(){
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
  void refesh() async {
    this.CurrentAudio = await getAudio();
    playSong(this.CurrentAudio);
    _addPlayContoll();
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
    double IconSize =widget.containerHeight/2;
    return new Container(
      width: MediaQuery.of(context).size.width,
      height: widget.containerHeight,
      decoration: BoxDecoration(
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
                      height: widget.containerHeight,
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
