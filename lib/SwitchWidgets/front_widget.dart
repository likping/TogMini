import 'package:flutter/material.dart';

class FrontWidget extends StatefulWidget {
  Function open;
  Widget child;
  State createState() => _FrontWidgetState();
  FrontWidget(this.open,{this.child});
}

class _FrontWidgetState extends State<FrontWidget>
    with TickerProviderStateMixin {
  TabController _tabController;
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(0)),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Padding(
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  GestureDetector(
                    onTap: widget.open,
                    child: Padding(
                      padding: EdgeInsets.only(left: 15, top: 10),
                      child: Icon(
                        Icons.menu,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Center(
                      child: Text("TogMini",
                          style: TextStyle(
                              color: Colors.orange, fontSize: 22)),
                    ),
                  ),
                  Padding(padding: const EdgeInsets.only(left: 15, top: 10)),
                  CircleAvatar(
                    backgroundColor: Colors.orange,
                    child:Icon(
                      Icons.search,
                      color: Colors.white,
                    )
                  )
                ],
              ),

            ],
          ),
        )
    );
  }
  Widget _example(){
    return SingleChildScrollView(
      child: Column(
        children: <Widget>[
          Padding(
            padding:
            EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                onTap: widget.open,
                child: Padding(
                  padding: EdgeInsets.only(left: 15, top: 10),
                  child: Icon(
                    Icons.menu,
                    color: Colors.grey,
                  ),
                ),
              ),
              Expanded(
                child: Center(
                  child: Text("TogMini",
                      style: TextStyle(
                          color: Colors.orange, fontSize: 22)),
                ),
              ),
              Padding(padding: const EdgeInsets.only(left: 15, top: 10)),
              CircleAvatar(
                  backgroundColor: Colors.orange,
                  child:Icon(
                    Icons.search,
                    color: Colors.white,
                  )
              )
            ],
          ),
          Padding(
              padding: EdgeInsets.only(top: 20, bottom: 20),
              child: Text(
                "Hell",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                    fontSize: 25),
              )),
          Container(
            color: Color(0xffeaf2f8),
            child: Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              child: Text(
                "a simple example",
                style: TextStyle(color: Color(0xff266ed5), fontSize: 12),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20),
            child: SizedBox(
              height: 40,
              child: TabBar(
                labelColor: Colors.grey,
                isScrollable: true,
                controller: _tabController,
                tabs: <Widget>[
                  Tab(
                    child: Text("myhouse"),
                  ),
                  Tab(
                    child: Text("marker"),
                  ),
                  Tab(
                    child: Text("tools"),
                  ),
                  Tab(
                    child: Text("neighbourhod"),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 500,
              child: TabBarView(
                controller: _tabController,
                children: <Widget>[
                  _buildContainer(),
                  _buildContainer(),
                  _buildContainer(),
                  _buildContainer(),
                ],
              ))
        ],
      ),
    );
  }
  Widget _buildContainer() {
    return Container(
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        child: Text(" "),
      ),
    );
  }
}
