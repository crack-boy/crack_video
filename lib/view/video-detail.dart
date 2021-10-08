import 'package:crack_video/common/apps/AppFunc.dart';
import 'package:crack_video/common/apps/AppInterface.dart';
import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';
import 'package:toast/toast.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

import 'dart:convert';

class VideoDetail extends StatefulWidget {
  VideoDetail({Key key, this.videoItem, this.appName}) : super(key: key);
  final VideoItem videoItem;
  final String appName;
  @override
  State<StatefulWidget> createState()  => VideoDetailState(
      videoItem: videoItem,
    appName: appName,
  );
}

class VideoDetailState extends State{
  VideoDetailState({this.videoItem, this.appName });
  final VideoItem videoItem;
  final String appName;

  bool loadingVideo = false;

  IjkMediaController _controller = IjkMediaController();



  @override
  void initState() {
    super.initState();
    Wakelock.enable();
    initPlayer();
  }

  @override
  void dispose() {
    _controller.dispose();
    Wakelock.disable();
    ToastView.dismiss();
    super.dispose();
  }

  initPlayer() async {
    if(this.loadingVideo){
      return;
    }
    this.loadingVideo = true;

    Toast.show('获取视频播放地址...', context, duration: 100, gravity: Toast.BOTTOM);

    AppFunc appFunc = new AppFunc(this.appName);
    String videoUrl = await appFunc.getVideoUrl(this.videoItem);

    print(videoUrl);

    if(videoUrl.isEmpty){
      Toast.show('获取视频播放失败', context, duration: 100, gravity: Toast.BOTTOM);
      return;
    }

    this.loadingVideo = false;
    Toast.show('视频加载中...', context, duration: 100, gravity: Toast.BOTTOM);
    await _controller.setNetworkDataSource(videoUrl, autoPlay: true);
    ToastView.dismiss();
  }


  @override
  Widget build(BuildContext context) {

    final mediaQueryData = MediaQuery.of(context);

    final screenWidth = mediaQueryData.size.width;
    final screenHeight = mediaQueryData.size.height;

    return new Scaffold(
      appBar: null,
      body: GestureDetector(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            Container(
              width: screenWidth,
              height: screenHeight,
              color: Colors.black,
              child: Center(
                child:  IjkPlayer(
                  mediaController: _controller,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}