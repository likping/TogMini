import "package:flutter/gestures.dart";
import "package:flutter/material.dart";

class BottomDragWidget extends StatefulWidget {
  Widget child;
  final reverseVisible;
  final detailVisible;
  double childHeight;
  _BottomDragWidgetState createState() => _BottomDragWidgetState();
  BottomDragWidget({this.child,this.detailVisible,this.reverseVisible ,this.childHeight});
}

class _BottomDragWidgetState extends State<BottomDragWidget> with TickerProviderStateMixin {

  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Align(
          alignment: Alignment.bottomCenter,
          child: DragContainer(
            child: widget.child,
            reverseVisible:widget.reverseVisible,
            detailVisible: widget.detailVisible,
            childHeight: widget.childHeight,
          ),
        )
      ],
    );
  }
}

class DragContainer extends StatefulWidget {
  @override
  Widget child;
  _DragContainerState createState() => _DragContainerState();
  final reverseVisible;
  final detailVisible;
  double childHeight;
  DragContainer({this.child,this.detailVisible,this.reverseVisible,this.childHeight});
}

class _DragContainerState extends State<DragContainer> with TickerProviderStateMixin {
  double offsetDistance = 0.0;
  AnimationController animationController;
  Animation animation;
  double dragY=0.0;
  double limitY;
  initState() {
    limitY=widget.childHeight - 5;
    animationController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 250)
    );
    final CurvedAnimation curve = new CurvedAnimation(parent: animationController, curve: Curves.easeOut);
    animation = Tween().animate(curve)
      ..addListener(() {
          if (offsetDistance > limitY / 2) {
            offsetDistance = limitY;
          } else if (offsetDistance <= limitY / 2) {
            offsetDistance = 0;
            setState(() {});
          }
      });
  }
  GestureRecognizerFactoryWithHandlers<MyVerticalDragGestureRecognizer>
      getRecognizer() {
    return GestureRecognizerFactoryWithHandlers(
        () => MyVerticalDragGestureRecognizer(), this._initializer);
  }

  void _initializer(MyVerticalDragGestureRecognizer instance) {
    instance
      ..onStart = _onStart
      ..onUpdate = _onUpdate
      ..onEnd = _onEnd;
  }

  ///接受触摸事件
  void _onStart(DragStartDetails details) {
    setState(() {

    });
    print('触摸屏幕${details.globalPosition}');
    print('触摸屏幕${details.localPosition}');
    print('移动多少${details.globalPosition.dy-details.localPosition.dy}');
  }

  ///垂直移动
  void _onUpdate(DragUpdateDetails details) {
   // print('垂直移动${details.delta}');

      if(widget.reverseVisible()==false&&widget.detailVisible()==false) {
        offsetDistance = offsetDistance + details.delta.dy;
        if (offsetDistance > limitY) {
          offsetDistance = limitY;
        }
        if (offsetDistance < 0) {
          offsetDistance = 0;
        }
      }
      setState(() {});

  }

  ///手指离开屏幕
  void _onEnd(DragEndDetails details) {

    setState(() {
      animationController.forward(from: 0.0);

    });
    print('离开屏幕');
  }

  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, offsetDistance),
      child: RawGestureDetector(
        gestures: {MyVerticalDragGestureRecognizer: getRecognizer()},
        child: widget.child
      ),
    );
  }
}

class MyVerticalDragGestureRecognizer extends VerticalDragGestureRecognizer {
  MyVerticalDragGestureRecognizer({Object debugOwner})
      : super(debugOwner: debugOwner);
}
