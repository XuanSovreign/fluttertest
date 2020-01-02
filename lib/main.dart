import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'flutter i come',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);


  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageStat = 0;
  var list = [];
  var contentText = "";
  var json = "";
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    pageStat = 0;
    _getListData();
  }

  _getListData() {
    for (int i = 0; i < 100; i++) {
      list.add("item $i");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      resizeToAvoidBottomPadding: false,
      body: Center(
        child: Column(
          children: <Widget>[
            Expanded(child: _contentView(),),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                GestureDetector(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    child:
                    Text(
                      "首页"
                      ,
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w200,
                          color: pageStat == 0 ? Colors.blue : null),
                    ),
                  ),
                  onTap: () {
                    _switchPage(0);
                  },
                )
                ,
                GestureDetector(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "发现"
                        ,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                            color: pageStat == 1 ? Colors.blue : null),
                      )
                  ),
                  onTap: () {
                    _switchPage(1);
                    _getHttpDataStr();
                  },
                )
                ,

                GestureDetector(
                  child: Container(
                      padding: EdgeInsets.all(10),
                      child: Text(
                        "我的"
                        ,
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w200,
                            color: pageStat == 2 ? Colors.blue : null
                        ),
                      )
                  ),
                  onTap: () {
                    _switchPage(2);
                  },
                )
              ],
            )
          ],
        ),
      ),

    );
  }

  _switchPage(int i) {
    setState(() {
      pageStat = i;
    });
  }

  Widget _contentView() {
    Widget content;
    switch (pageStat) {
      case 0:
        content = ListView.builder(
          shrinkWrap: true,
          itemCount: list.length,
          itemBuilder: (BuildContext context, int position) {
            return Column(
              children: <Widget>[
                Text(list[position]),
                Divider(),
              ],
            );
          },
        );
        break;
      case 1:
        content = Column(
          children: <Widget>[
            Text('data:$json')
          ],
        );
        break;
      case 2:
        content = Column(
            children: <Widget>[
              Text("threepage"),
              Text(contentText),
              TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "请输入文字",
                ),
              ),
              RaisedButton(
                child: Text("done"),
                onPressed: () {
                  setState(() {
                    contentText = _controller.text;
                  });
                },
              ),
              FlatButton(
                onPressed: () {
                  _pushNextPage();
                },
                child: Text("跳转"),
              )

            ]
        );
        break;
    }
    return content;
  }

  _getHttpDataStr() async {
    var httpClient = new HttpClient();
    String url = "http://192.168.30.160:8090/convert/weather?selector=1";
    var result = "";
    try {
      var request = await httpClient.getUrl(Uri.parse(url));
      var response = await request.close();
      if (response.statusCode == HttpStatus.ok) {
        result = await response.transform(utf8.decoder).join();
//      var data = jsonDecode(json);
      }
    } catch (exception) {
      result = "error";
    }
    setState(() {
      json = result;
    });
  }

  void _pushNextPage() {
    Navigator.of(context).push(
        new MaterialPageRoute(builder: (BuildContext context) {
          return Scaffold(
            appBar: AppBar(
              title: Text("NEW PAGE"),
            ),
            body: Text("WELCOM TO NEW PAGE"),
          );
        })
    );
  }
}
