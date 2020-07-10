import "package:flutter/material.dart";

class BgWidget extends StatefulWidget {
  Function close;
  Widget child;
  BgWidget(this.close,{this.child});
  State createState() => _BgWidgetState();
}

class _BgWidgetState extends State<BgWidget> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Container(
      height: double.infinity,
      width: MediaQuery.of(context).size.width,
      padding: EdgeInsets.only(left:20),
      child: widget.child==null?_example():widget.child

    );
  }
  Widget _example(){
    return ListView(
      children: <Widget>[
        GestureDetector(
            onTap: widget.close,
            child: Padding(
                padding: const EdgeInsets.only(
                    top: kToolbarHeight *1.5//???
                ),
                child: Row(
                  children: <Widget>[
                    Padding(
//                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        padding: EdgeInsets.only(right: 5),
                        child: Icon(
                          Icons.close,
                          color: Colors.grey,
                          size: 30,
                        )),
                    Text("Close Menu",
                        style:
                        TextStyle(color: Colors.grey, fontSize: 14))
                  ],
                )
            )
        ),
        SizedBox(
          height: 25,
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            CircleAvatar(
              child: FlutterLogo(),
            ),
            SizedBox(
              width: 20,
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("ERIC WHO",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    )),
                Text("open dashboard",
                    style: TextStyle(
                      color: Colors.blueAccent,
                      fontSize: 12,
                    )),
              ],
            )
          ],
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          "services",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Sell your house",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Buy a home",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(
          height: 50,
        ),

        Text(
          "Custom",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Reviews",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Stories",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Agents",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(
          height: 50,
        ),
        Text(
          "about",
          style: TextStyle(color: Colors.white, fontSize: 12),
        ),

        SizedBox(
          height: 20,
        ),
        Text(
          "FAQ",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Company",
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ],
    );
  }
}
