import 'package:flutter/material.dart';
import "package:tog/AudioComponent/Audio.dart";
import "package:tog/Widgets/SongListViewItemWidget.dart";
import 'package:tog/Config//Constant.dart';
import "dart:convert";
import "package:tog/AudioComponent/AudioFileStore.dart";
import 'package:tog/Activity//Player.dart';
import 'package:tog/Activity//DbHelper.dart';
import "package:tog/AudioComponent/Adapt.dart";
import "dart:ui";
class PlayingList extends StatefulWidget  {
  double ParentContainerHeight;
  State createState() {
    return PlayingListState();
  }

  PlayingList({this.ParentContainerHeight});
}

class PlayingListState extends State<PlayingList> with TickerProviderStateMixin {
  List<Audio> audios=[];
  @override

  void dispose()async{
    super.dispose();
    var _audios = await getAudios();
    //print(jsonEncode(_audios.map((f) => f.toJson()).toList()));
    await DbHelper.instance.deleteAllPlayList();
    for (var audio in _audios){
       await DbHelper.instance.insertPlayList(audio);
    }
   // print(Adapt.screenH()*(1-0.0945)-74);
  }
 void initState(){
    // TODO: implement initState
    Future.delayed(Duration(milliseconds: 100), (){
      refresh();
       print('延时0.1s执行');
    });

  }
  void refresh()async{
    var _audios = await getAudios();
    setState(() {
      this.audios=_audios;
    });
  }
  void _clearAll()async {
    var prefs = await Constant.instance.prefs;
    var _audios = await getAudios();
    _audios.clear();
    var value = jsonEncode(_audios);
    await DbHelper.instance.deleteAllPlayList();


        await prefs.setString(Constant.instance.audiosKey, value);
        this.audios=_audios;

        setState(() {});

  }
  void _delete(int audioIndex) async {
    print("delelet ${audioIndex}");
    var prefs = await Constant.instance.prefs;
    var _audios = await getAudios();
    _audios.removeAt(audioIndex);
    var value = jsonEncode(_audios.map((f) => f.toJson()).toList());

        await prefs.setString(Constant.instance.audiosKey, value);
        this.audios=_audios;
        setState(() {});
  }
  Future<List<Audio>> getAudios() async {
    var prefs = await Constant.instance.prefs;
    var json = jsonDecode(await prefs.get(Constant.instance.audiosKey));
    var value = (json as List<dynamic>);
    var audios = value.map((f) => Audio.fromJson(f)).toList();
    return audios;
  }
  Widget build(BuildContext context) {
    return new Container(
        width: MediaQuery.of(context).size.width,
        height: widget.ParentContainerHeight - 150,
        decoration: BoxDecoration(color: Colors.white, boxShadow: [
          BoxShadow(
              color: Color.fromRGBO(125, 125, 125, 0.3),
              blurRadius: 15,
              offset: Offset(0, -5))
        ]),
        child: new Column(
          children: <Widget>[
            //todo 列表总体的控制
            new Container(
              width: 360,
              height: 50,
              child: new Row(
                children: <Widget>[
                  new Container(
                    child: new Text("播放列表"),
                  ),
                  new Container(
                    height: 45,
                    decoration: BoxDecoration(
                        color: Colors.white,
//                            boxShadow: [BoxShadow(
//                                color: Color.fromRGBO(125,125,120,1),
//                                blurRadius:5,
//                                offset: Offset(0,5)
//                            )],
                        border: Border.all(
                            color: Color.fromRGBO(125, 125, 125, 0.5)),
                        borderRadius: BorderRadius.circular(5)),
                    margin: EdgeInsets.only(left: 200),
                    padding: EdgeInsets.all(0),
                    child: FlatButton(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        onPressed: _clearAll,
                        child: new Row(
                          children: <Widget>[
                            new Icon(Icons.delete),
                            new Text("清空列表")
                          ],
                        )),
                  )
                ],
              ),
            ),
            //todo 列表各项的ListViews
            new Container(
              width: 360,
              height: widget.ParentContainerHeight - 150 - 50,
              child: ListView.builder(
                  itemCount: this.audios?.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListViewItemWidget(
                        audio: this.audios[index],
                        id:index,
                         delete: ()=>{_delete(index)},
                    );
                  }),
            )
          ],
        ));
  }
}
