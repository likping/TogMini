import 'package:flutter/material.dart';
import "package:shared_preferences/shared_preferences.dart";
import "package:tog/Config/Constant.dart";
import "package:permission_handler/permission_handler.dart";
import "package:flutter_webview_plugin/flutter_webview_plugin.dart";
import 'package:flutter/cupertino.dart';
import "dart:async";

class LoginPage extends StatefulWidget {
  State createState() {
    //创建状态类表
//    return _LoginPageState();
    return _LoginPageState();
  }
}

class _LoginPageState extends State<LoginPage> {
  //数据存储--账号和密码
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  var _accountController = TextEditingController();
  var _pwdController = TextEditingController();
  // 标题字体样式
  final _biggerFont =
      const TextStyle(fontSize: 15.0, fontWeight: FontWeight.w600);

  //  ：正文字体样式
  final _normalFont = const TextStyle(fontSize: 18.0);
  //按钮文字演示
  final _ButtonFont = const TextStyle(fontSize: 18.0, color: Colors.white);

  // 边框圆角
  final _borderRadius = BorderRadius.circular(6);

  // 是否隐藏密码
  bool _obscureText = true;

  // 账号
  String _accountText = "";

  // 密码
  String _pwdText = "";

  // 是否可以登录
  bool _isEnableLogin = false;

  void _checkUserInput() {
    if (_accountText != null &&
        _pwdText != null &&
        _accountText.isNotEmpty &&
        _pwdText.isNotEmpty) {
      if (!_isEnableLogin) {
        setState(() {
          _isEnableLogin = !_isEnableLogin;
        });
      }
      ;
    } else {
      if (_isEnableLogin) {
        setState(() {
          _isEnableLogin = !_isEnableLogin;
        });
      }
      ;
    }
    return;
  }

  //初始化
  void initState() {
    _prefs.then((prefs) {
      // 实验3
//      prefs.setString(Constant.account, "zyd");
//      prefs.setString(Constant.password, "lkp");

      _accountText = prefs.getString(Constant.account) ?? null;
      _accountController.text = _accountText;
      _pwdText = prefs.getString(Constant.password) ?? null;
      _pwdController.text = _pwdText;
      _checkUserInput();
    });
  }

  //申请权限
  Future<bool> _requestPermissions() async {
    Map<PermissionGroup, PermissionStatus> permissions =
        await PermissionHandler().requestPermissions([PermissionGroup.storage]);
    List<bool> results = permissions.values.toList().map((status) {
      return status == PermissionStatus.granted;
    }).toList();
    return !results.contains(false);
  }

  //控制登录按钮是否可用的方法体
  _getLoginButtonPressed() {
    if (!_isEnableLogin) return null;
    //
    return () async {
      //实验3
      final SharedPreferences prefs = await _prefs;

      prefs.setString(Constant.account, _accountText);
      prefs.setString(Constant.password, _pwdText);
      Navigator.of(context).pop();
      Navigator.pushNamed(context, "/MyHomePage");
//      showDialog(
//          context: this.context,
//          builder: (context){
//            return AlertDialog(
//              title:Text("登录提醒"),
//              content:Text("登录账户：$_accountText\n登录密码：$_pwdText"),
//              actions: <Widget>[
//                FlatButton(
//                    color:Colors.blue,
//                    child:Text(
//                      "确认",
//                      style: _ButtonFont,
//                    ),
//                    onPressed:() async{
//                      //申请状态
//                      await _requestPermissions();
//                      //Navigator控制页面栈
//                      Navigator.of(context).pop();
//                      Navigator.pushNamed(context,"/MyHomePage");
////                      Navigator.push(context,
////                            MaterialPageRoute(builder: (context)=>MyHomePage())
////                      )
//
//                    }
//
//                ),
//                FlatButton(
//                    color:Colors.blue,
//                    child:Text(
//                      "取消",
//                      style:_ButtonFont,
//                    ),
//                    onPressed:(){
//                      Navigator.of(context).pop();
//                    }
//                )
//              ],
//            );
//          }
//      );
    };
  }

  //建立顶层窗口
  Widget _buildTopWidget() {
    return Container(
      margin: EdgeInsets.only(top: 40), //间隔
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          //加载图片
          new Center(
            child: new Container(
              child: Image.asset("assets/images/ic_launcher.png"),
              width: 100,
              height: 100,
            ),
          ),
          new Center(
            child: Text(
              "欢迎使用TOG账户",
              style: _biggerFont,
            ),
          )
        ],
      ),
    );
  }

  //建立账户编辑窗口
  Widget _buildAccountEditTextField() {
    return Container(
        margin: EdgeInsets.only(top: 80),
        child: TextField(
            onChanged: (text) {
              _accountText = text;
              _checkUserInput();
            }, /////?
            controller: _accountController,
            style: _normalFont,
            decoration: InputDecoration(
                hintText: '请输入手机号/用户名/邮箱',
                filled: true,
                fillColor: Color.fromARGB(255, 240, 240, 240),
                contentPadding: EdgeInsets.only(left: 8),
                border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: _borderRadius))));
  }

  //密码输入窗口
  Widget _buildPwdEditTextField() {
    return Container(
      margin: EdgeInsets.only(top: 15),
      child: TextField(
        onChanged: (text) {
          _pwdText = text;
          _checkUserInput();
        },
        controller: _pwdController,
        style: _normalFont,
        obscureText: _obscureText,
        decoration: InputDecoration(
            hintText: "请输入登陆密码",
            filled: true,
            fillColor: Color.fromARGB(255, 240, 240, 240),
            contentPadding: EdgeInsets.only(left: 8),
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: _borderRadius,
            ),
            suffixIcon: IconButton(
              onPressed: () => setState(() => _obscureText = !_obscureText),
              icon: Image.asset(
                _obscureText
                    ? "assets/images/hide.png"
                    : "assets/images/open.png",
                width: 20,
                height: 20,
              ),
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
            )),
      ),
    );
  }

  //建立登陆按钮
  Widget _buildLoginButton() {
    return Container(
        margin: EdgeInsets.only(top: 30),
        //媒体查询得到某物的宽度
        width: MediaQuery.of(context).size.width,
        height: 45,
        child: RaisedButton(
          child: Text("登 录", style: _normalFont),
          color: Colors.blue,
          disabledColor: Colors.black12,
          textColor: Colors.white,
          disabledTextColor: Colors.black12,
          shape: RoundedRectangleBorder(
            borderRadius: _borderRadius,
          ),
          onPressed: _getLoginButtonPressed(),
        ));
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: Text("Tog Mini" ,style: TextStyle(color: Colors.orangeAccent),),
            backgroundColor: Colors.white
        ),
        //套一层SingleChildScrollView防止Flutter底部溢出
        body: new SingleChildScrollView(
            child: Container(
                margin: EdgeInsets.only(left: 25, right: 25),
                child: Column(
                  children: <Widget>[
                    Column(children: <Widget>[
                      _buildTopWidget(),
                      _buildAccountEditTextField(),
                      _buildPwdEditTextField(),
                      _buildLoginButton(),
                    ]),
                  ],
                ))));
  }
}
