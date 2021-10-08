import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:crack_video/view/video-list.dart';
import 'package:crack_video/view/video-category.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import 'common/apps/AppConfig.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Crack Video',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Crack Video'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  void initState() {
    super.initState();
    this.startHttpServer();
  }

  startHttpServer() async {
    Directory tempDir = await getTemporaryDirectory();
    HttpServer.bind(InternetAddress.anyIPv4, AppConfig.HttpPort, shared: true).then((server) {
    print("run http server...");
      server.listen((HttpRequest request) {
        File file = File(tempDir.path + request.uri.path);
        print(file.existsSync());
        request.response..add(file.readAsBytesSync())..close();
      });
    });
  }

  static const AppList = [{'title': '首页推荐小视频', 'appName': 'Caoliu1', 'hasCate': false}];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: new ListView.separated(
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: new Text(AppList[index]['title']),
            leading: new Icon(
              Icons.insert_drive_file,
              color: Colors.black,
            ),
            onTap: (){
              if(AppList[index]['hasCate']){
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=> new VideoList(appName: AppList[index]['appName'], listTitle: AppList[index]['title'],)
                    )
                );
              }else{
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context)=> new VideoList(appName: AppList[index]['appName'], listTitle: AppList[index]['title'],)
                    )
                );
              }

            },
          );
        },
        itemCount: AppList.length,
        separatorBuilder: (BuildContext context, int index) => new Divider(),

      ),
    );
  }
}
