import 'package:flutter/material.dart';
import './background_widget.dart';
import './front_widget.dart';
class HomePage extends StatefulWidget{
  _HomePageState createState()=> _HomePageState();
}
class _HomePageState extends State<HomePage> with TickerProviderStateMixin{
  double left =0;
  double top=0;
  double MAX_lEFT=0;
  double direction;//方向
  void initState(){

    super.initState();
  }

  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: Builder(
        builder: (context){
          MAX_lEFT=MediaQuery.of(context).size.width-100;
          return _buildBody();
        },
      ),
    );

  }
  Widget _buildBody(){
    return GestureDetector(
      onHorizontalDragUpdate: (update){
        left=left+update.delta.dx;
        direction=update.delta.direction;
        if(left<0){
          left=0;
        }
        if(left>MAX_lEFT){
          left=MAX_lEFT;
        }
        setState(() {

        });
      },
      onHorizontalDragEnd: (end){
          animateWidget();
      },
      child: Container(
        color: Color(0xff191f39),
         child: Stack(
           children: <Widget>[
             Container(
               child: BgWidget(open),
             ),
             Positioned(
               left: left,
               top: left*0.2,
               bottom: left*0.2,
               child: FrontWidget(open),
             )
           ],
         ),
      ),
    );
  }
  void open(){
    if(left==MAX_lEFT){
      direction=1;
    }else{
      direction=0;
    }
    animateWidget();
  }
  Animation _animation;
  void animateWidget() {
    bool increment = direction <= 0;
    AnimationController _controller = AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300)
    )
      ..addListener(() {
        left = _animation.value;
        top = left * 0.3;
        setState(() {

        });
      });

    var temp_left = left;
    _animation = Tween(
      begin: temp_left,
      end: !increment ? 0.0 : MAX_lEFT,
    ).animate(CurvedAnimation(
        curve: Curves.fastLinearToSlowEaseIn, parent: _controller));
    _controller.forward();
  }
}