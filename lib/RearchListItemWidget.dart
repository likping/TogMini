import 'package:flutter/material.dart';
import "./Audio.dart";
import "./Constant.dart";
import "dart:convert";
import "AudioFileStore.dart";
import "./Player.dart";
import './Constant.dart';
import "dart:math";
enum Process{
  loading,
  finish,
  failed,
  waiting,
}
class RearchListItem extends StatefulWidget {
  AudioFileStore fileStore=new AudioFileStore();
  State createState() {
    return RearchListItemState();
  }
  var map;//audioList+totalcount
  var name;
  var input;
  var pageview;
  RearchListItem({this.map, this.name,this.input,this.pageview});
}

class RearchListItemState extends State<RearchListItem> {
  double ContainHeight = 200;
  Process STATUS=Process.finish;
  int count=0;
  @override
  void initState() {
      super.initState();
      setState(() {
        STATUS=Process.finish;
      });
  }
  void _onPageChange(int index) async{
    setState(() {
      STATUS=Process.loading;
    });
    var _map = await widget.fileStore
        .search(widget.input.text, provider: widget.name, page: (index+1));
    setState(() {
      _map["pageIndex"]=index;
      widget.map=_map;
      STATUS=Process.finish;
    });
  }

  double ItemTextWidth = 250;
  ////整个App，控制播放相关的函数
  void _play(int index) async {
     int audioIndex= await _add(index);
     Audio audio=await getAudio(audioIndex);
     await setAudioIndex(audioIndex);
     await playSong(audio);
  }
  Future<int> _add(int index)async{
    print("add $index");
    var prefs = await Constant.instance.prefs;
    var _audios = await getAudios();
    int audioIndex;
    if(!_audios.contains(widget.map["audios"][index])){
      _audios.add(widget.map["audios"][index]);
      audioIndex=_audios.length-1;
    }else{
      audioIndex=_audios.indexOf(widget.map["audios"][index]);
    }
    var value = jsonEncode(_audios);
    prefs.setString(Constant.instance.audiosKey, value);
    return audioIndex;
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
  Widget building(){
    return  new Container(
        width: 360,
        height: this.ContainHeight,
        margin: EdgeInsets.only(top: 5),
        padding: const EdgeInsets.all(0),
        decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(5)),
//        child:ListView.builder(
//          itemCount: widget.list.length,
//          itemBuilder: (BuildContext context,int index){
//           return new Text("${widget.list[index]}");
//      }
        child: new Column(children: <Widget>[
          new Container(
            width: 360,
            height: 20,
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.black)),
            child: Stack(
              children: <Widget>[
                new Center(
                    child: new Text(
                        "${widget.map["pageIndex"] + 1}/${widget.map["totalCount"]}")),
                Positioned(
                  left: 0,
                  child: new Container(child: Image.asset('assets/images/${widget.name}_16.ico'))
                )
              ],
            ),
          ),
          new Container(
            width: 360,
            height: this.ContainHeight - 22,
            decoration: BoxDecoration(border: Border.all(color: Colors.black)),
            padding: EdgeInsets.all(0),
            margin: EdgeInsets.all(0),
            child: PageView.custom(

              childrenDelegate: SliverChildBuilderDelegate(
                      (context, index) {
                    return _STATUS();
                  },

                  childCount: widget.map["totalCount"]
              ),
              controller: widget.pageview,
              onPageChanged: (index) => _onPageChange(index),
            ),
          )
        ]));
  }
  Widget FinishStatus(){
    return Center(
      child: ListView.builder(
          itemCount: widget.map["audios"]?.length,
          itemBuilder: (BuildContext context, int Itemindex) {
            return new Container(
                width: 334,
                child: Row(
                  children: <Widget>[
                    new Container(
                        width: 250,
                        height: 30,
                        child: new Text(
                            "${widget.map["audios"][Itemindex].name}",
                            overflow: TextOverflow.ellipsis
                        )
                    ),
                    new Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.only(left: 20),
                      child: new FlatButton(
                          padding:
                          EdgeInsets.symmetric(horizontal: 0),
                          onPressed: widget.map["audios"][Itemindex].hasCopyright?()=>{_play(Itemindex)}:null,
                          child: Icon(
                            Icons.play_circle_filled,
                            size: 20,
                          )),
                    ),
                    new Container(
                      width: 30,
                      height: 30,
                      margin: EdgeInsets.only(left: 10),
                      child: new FlatButton(
                          padding:
                          EdgeInsets.symmetric(horizontal: 0),
                          onPressed:widget.map["audios"][Itemindex].hasCopyright?()=>{_add(Itemindex)}:null,
                          child: Icon(
                            Icons.add_circle,
                            size: 20,
                          )),
                    ),
                  ],
                ));
          }),
    );
  }
  Widget WaitingStatus(){
    return new Container(
      child:new Center(
        child: Icon(Icons.refresh),
      ),
    );
  }
  Widget FailedStatus(){
    return new Container(
      child:new Center(
        child: Icon(Icons.warning),
      ),
    );
  }
  Widget LoadingStatus(){
    return new Container(
      child:new Center(
        child: new Column(children: <Widget>[
                SizedBox(height: 50),
                CircularProgressIndicator(strokeWidth: 4.0),
                Text("正在加载")
        ],)  ,
      ),
    );
  }
  Widget _STATUS(){
    switch(STATUS){
      case Process.loading:
        return LoadingStatus();
      case Process.waiting:
        return WaitingStatus();
      case Process.failed:
        return FailedStatus();
      case Process.finish:
        return FinishStatus();
    };
  }
  /////
  Widget build(BuildContext context) {
     return building();

  }
}
