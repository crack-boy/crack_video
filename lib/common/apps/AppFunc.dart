import 'package:crack_video/common/apps/AppInterface.dart';
import 'package:crack_video/common/apps/caoliu/Caoliu1.dart';

class AppFunc implements AppInterface{
  final String appName;
  AppFunc(this.appName);
  @override
  getCategoryList(int page) {
    // TODO: implement getCategoryList
    throw UnimplementedError();
  }

  @override
  VideoItem getVideoItem(Map<String, dynamic> json) {
    // TODO: implement getVideoItem
    throw UnimplementedError();
  }

  @override
  Future<List<VideoItem>> getVideoList({CategoryItem categoryItem, int page}) {
    print(this.appName);
    if(this.appName == 'Caoliu1'){
      var app = new Caoliu1();
      return app.getVideoList(categoryItem: categoryItem, page: page);
    }
    throw UnimplementedError();
  }

  @override
  Future<String> getVideoUrl(VideoItem videoItem) {
    if(this.appName == 'Caoliu1'){
      var app = new Caoliu1();
      return app.getVideoUrl(videoItem);
    }
    throw UnimplementedError();
  }

}