// 音乐播放器--类
// 音乐播放对应的 控件两者结合使用
import "package:audioplayers/audioplayers.dart";
class Player {
  AudioPlayer audioPlayer=new AudioPlayer();
  //@{param} link 如 xxx.mp3
  // link= http://m128.xiami.net/39/2112636039/5020685834/2100603556_1590137644699_3939.mp3?auth_key=1592881200-0-0-a701e76dd651a40b113bafc596091e5d
  factory Player()=>_getInstance();
  static  Player get instance=>_getInstance();
  static  Player _instance;
  //命名构造
  Player._interal(){

  }
  static Player _getInstance(){
      if(_instance==null){
        _instance=new Player._interal();
      }
      return _instance;
  }


  play(link) async{
    try {
      int result = await audioPlayer.play(link);
      if (result == 1) {
        print("play success");
      } else {
        print("play failed");
      }
    }catch(error){
       print("failed");
    }
  }
  pause() async{
    int result = await audioPlayer.pause();
    if (result == 1) {
      // success
      print('pause success');
    } else {
      print('pause failed');
    }
  }
  stop() async{
    int result=await audioPlayer.stop();
    if (result == 1) {
      // success
      print('stop success');
    } else {
      print('stop failed');
    }
  }
  resume() async{
    int result=await audioPlayer.resume();
    if (result == 1) {
      // success
      print('resume success');
    } else {
      print('resume failed');
    }
  }
  turn()async{
    int result=await audioPlayer.seek(new Duration(milliseconds: 1200));
    if (result == 1) {
      // success
      print('turn success');
    } else {
      print('turn failed');
    }
  }
  onCompletion(func){
    audioPlayer.onPlayerCompletion.listen((event) {
       func();
    });
  }
  //创建进度条
//  player.onAudioPositionChanged.listen((Duration  p) => {
//  print('Current position: $p');
//  setState(() => position = p);
//  });
    //状态事件
/*
 player.onPlayerStateChanged.listen((AudioPlayerState s) => {
    print('Current player state: $s');
    setState(() => playerState = s);
  });
 */
    //完成事件
/*
player.onPlayerCompletion.listen((event) {
    onComplete();
    setState(() {
      position = duration;
    });
  });
 */

}