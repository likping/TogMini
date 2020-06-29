import "package:shared_preferences/shared_preferences.dart";
import "./Audio.dart";
class Constant{
  Future<SharedPreferences> prefs=SharedPreferences.getInstance();
  final String audiosKey="audios";
  String audioiIndex="index";
  int index=0;
  List<Audio>audioList;
  String rearchKey="rearch";
  factory Constant()=>_getInstance();
  static  Constant get instance=>_getInstance();
  static  Constant _instance;
  //命名构造
  Constant._interal(){
  }
  static Constant _getInstance(){
    if(_instance==null){
      _instance=new Constant._interal();
    }
    return _instance;
  }
  static final dbName="tog";
  static final searchHistoryTable="tog_history";
  static final playinglistTable="tog_playlist";
  static final version=1;
}