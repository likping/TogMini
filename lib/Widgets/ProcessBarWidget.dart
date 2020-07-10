import 'package:flutter/material.dart';

class ProcessBarWidget extends StatefulWidget {
  State createState() {
    return ProcessBarState();
  }

  double processWidth;
  double processValue;
  double ContainerHeight;
  double GrandParentContainerHeight;
  String currentTime;
  String endTime;
  double position;
  ProcessBarWidget(
      {this.processWidth = 0,
      this.processValue = 0,
      this.GrandParentContainerHeight = 0,
      this.currentTime,
      this.endTime,
      this.ContainerHeight}){
    if(this.processWidth!=null&&this.processValue!=null){

        this.position= 2.5 - 30+this.processWidth * this.processValue;

    }else{
      this.position=2.5-30;
    }

  }
}

class ProcessBarState extends State<ProcessBarWidget> {

  Widget build(BuildContext context) {
    return new Container(
        width: 360,
        height: widget.ContainerHeight,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: (widget.GrandParentContainerHeight - 300) / 4 * 2 / 2,
              left: 2.5,
              child: SizedBox(
                height: 5.0,
                width: widget.processWidth,
                // 圆角矩形剪裁（`ClipRRect`）组件，使用圆角矩形剪辑其子项的组件。
                child: ClipRRect(
                  // 边界半径（`borderRadius`）属性，圆角的边界半径。
                  borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  child: LinearProgressIndicator(
                    value: widget.processValue,
                    backgroundColor: Color(0xDDDDDDE3),
                    valueColor: AlwaysStoppedAnimation<Color>(
                        Color.fromRGBO(245, 184, 0, 1)),
                  ),
                ),
              ),
            ),
            Positioned(
                top: (widget.GrandParentContainerHeight - 300) / 4 * 2 / 2 - 15,
                left:widget.position,
                child: new Container(
                    width: 60,
                    height: 50,
                    decoration: BoxDecoration(),
                    child: new Column(
                      children: <Widget>[
                        new Text(
                          "${widget.currentTime}/${widget.endTime}",
                          style: TextStyle(
                              fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                        new Container(
                          width: 10,
                          height: 10,
                          decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Color.fromRGBO(245, 184, 0, 1),
                                    blurRadius: 5)
                              ]),
                        )
                      ],
                    )))
          ],
        ));
  }
}
