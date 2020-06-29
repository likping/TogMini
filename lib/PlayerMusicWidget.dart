import 'package:flutter/material.dart';
import "./ProcessBarWidget.dart";
import "./Player.dart";
import "./Constant.dart";
import "./AudioFileStore.dart";
import "./Audio.dart";
import "dart:convert";
import "./Player.dart";
import "package:audioplayers/audioplayers.dart";
class PlayerMusicWidget extends StatefulWidget {


  State createState() {
    return PlayerMusicWidgetState();
  }
  AudioFileStore fileStore=new AudioFileStore();
  final ParentContainerHeight;
  PlayerMusicWidget({this.ParentContainerHeight});
}

class PlayerMusicWidgetState extends State<PlayerMusicWidget> {
  int audioIndex;
  int MaxInSeconds;
  int Position;
  String _currentTime;
  String _endTime;
  String songName;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    refresh();//初始化 audioIndex;
    Player.instance.audioPlayer.onAudioPositionChanged.listen((Duration  p){
//      print('Current position: ${p.toString().substring(2,7)}');
      if(mounted){
        setState((){
          this.Position=p.inSeconds;
          this._processValue=(this.Position/this.MaxInSeconds);
          this._currentTime=p.toString().substring(2,7);

        });
      }

    });
    Player.instance.audioPlayer.onDurationChanged.listen((Duration d) {
//      print('Max duration: ${d.toString().substring(2,7)}');
      if(mounted) {
        setState(() {
          this.MaxInSeconds = d.inSeconds;
          this._endTime = d.toString().substring(2, 7);
        });
      }

    });
  }
  void refresh() async{
    await getAuioIndex();
    Audio audio=await getAudio();
    setState(() {
      this.songName=audio.name;
    });
    Player.instance.audioPlayer.onPlayerStateChanged.listen((AudioPlayerState d)async{
      if(d==AudioPlayerState.PLAYING){
        print("PlayerMusicWidget");
        Audio audio=await getAudio();
        setState(() {
          this.songName=audio.name;
        });
      }
    });
  }
  void playSong(Audio audio){
    widget.fileStore
        .songSource(audio.songSourceLink)
        .then((audio) {
      Player.instance.play(audio);
    });
  }
  void _turnPrevious() async{
    var audios=await getAudios();
    setState(() {
     this.audioIndex-=1;
      if( this.audioIndex<0){
        this.audioIndex=audios.length-1;
      }
    });
    await setAudioIndex();
    var audio= await getAudio();
    print(audio.name+"Previous");
    playSong(audio);
  }
  void _turnNext() async{
    var audios=await getAudios();
    setState(() {
      this.audioIndex+=1;
      if( this.audioIndex>=audios.length){
        this.audioIndex=0;
      }
    });
    await setAudioIndex();
    var audio= await getAudio();
    print(audio.name+"NEXT");
    playSong(audio);
  }
  Future<Audio>getAudio() async{
    var audios=await getAudios();
    return audios[this.audioIndex];
  }
  setAudioIndex()async{
    var prefs = await Constant.instance.prefs;
    prefs.setInt(Constant.instance.audioiIndex, this.audioIndex);
  }
  getAuioIndex()async{
    var prefs = await Constant.instance.prefs;
    this.audioIndex=prefs.getInt(Constant.instance.audioiIndex);
  }
  Future<List<Audio>> getAudios()async{
    var prefs = await Constant.instance.prefs;
    var json = jsonDecode(prefs.get(Constant.instance.audiosKey));
    var value = (json as List<dynamic>);
    var audios = value.map((f) => Audio.fromJson(f)).toList();
    return audios;
  }
  double _processWidth=350.0;
  double _processValue;

  Widget build(BuildContext context) {
    return new Container(
        width: 360,
        height: widget.ParentContainerHeight - 300,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(125, 125, 125, 0.3),
              blurRadius: 15,
              offset: Offset(0, -5))
        ]),
        child: new Column(
          children: <Widget>[
            //todo 头部名称显示
            new Container(
              width: 360,
              height: (widget.ParentContainerHeight - 300) / 8,
//              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: new Center(
                child: new Text("${this.songName}"),
              ),
            ),
            // todo 中间进度条
            new Container(
              width: 360,
              height: ((widget.ParentContainerHeight - 300) / 8)*5,
//              decoration: BoxDecoration(border: Border.all(color: Colors.black)),
              child: new ProcessBarWidget(
                processValue: _processValue,
                processWidth: _processWidth,
                GrandParentContainerHeight: widget.ParentContainerHeight,
                currentTime: this._currentTime,
                endTime: this._endTime,
                ContainerHeight: ((widget.ParentContainerHeight - 300) / 2),
              )
            ),
           // todo 底部控制
            new Container(
                width: 360,
                height: ((widget.ParentContainerHeight - 300) /8)*1.8 ,
//                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                child: new Row(
                  children: <Widget>[
                    new Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(left: 5),
                        child: new RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            onPressed: _turnPrevious,
                            child: Icon(Icons.chevron_left))),

                    new Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(left: 5),
                        child: new RaisedButton(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            onPressed: _turnNext,
                            child: Icon(Icons.keyboard_arrow_right))),
                    new Container(
                        width: 50,
                        height: 50,
                        margin: EdgeInsets.only(left: 190),
                        child: new FlatButton(
                            padding: EdgeInsets.symmetric(horizontal: 0),
                            onPressed: null,
                            child: Icon(Icons.loop))),
                  ],
                )),
          ],
        ));
  }
}
