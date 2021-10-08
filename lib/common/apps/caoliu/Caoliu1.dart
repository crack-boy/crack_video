import 'package:crack_video/common/apps/AppInterface.dart';
import 'dart:convert';
import 'package:encrypt/encrypt.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

import '../AppConfig.dart';


//草榴首页推荐小视频
class Caoliu1 implements AppInterface{

  final String HOST = "https://avapp.clapia.me";
  final String Token = 'eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiI3NDk4ODU0IiwiaXNzIjoiIiwiaWF0IjoxNjE3MjU1NzkyLCJuYmYiOjE2MTcyNTU3OTIsImV4cCI6MTc3NDkzNTc5Mn0.mRttTHpFpeemEyB-fsKVuJUNHQjGCpIsZjead4AYx2k';

  Caoliu1() {
    this.saveM3u8Key();

  }

  saveM3u8Key()async{
    var tempDir = await getTemporaryDirectory();
    var rootDir = Directory(tempDir.path + '/api/m3u8/enc/');
    try {
      bool exists = await rootDir.exists();
      if (!exists) {
        await rootDir.create(recursive: true);
      }
    } catch (e) {
      print(e);
    }
    File file = File(rootDir.path + "key");
    file.writeAsBytes(Base64Decoder().convert('x3GZk8tbgc6xSPSiBdSPBQ=='));
  }

  @override
  getCategoryList(int page) {
    // TODO: implement getCategoryList
    throw UnimplementedError();
  }


  @override
  VideoItem getVideoItem(Map<String, dynamic> json) {
    return VideoItem(json['videoId'].toString(), json['title'], json['videoUrl']);
  }

  @override
  Future<List<VideoItem>> getVideoList({CategoryItem categoryItem, int page}) async {
    String retText = await this.request('/api/video/brush/list', true);
    var retObj = json.decode(retText);
    return List.from(retObj['data']).map((e) => this.getVideoItem(e)).toList();
  }

  @override
  Future<String> getVideoUrl(VideoItem videoItem) async {
    String retText = await this.request("/api/m3u8/decode/brush?path=${videoItem.url}", false);
    Directory tempDir = await getTemporaryDirectory();
    String tempFile = '${tempDir.path}/temp.m3u8';
    File file = File(tempFile);
    file.writeAsString(retText);

    return 'http://127.0.0.1:${AppConfig.HttpPort}/temp.m3u8';
  }


  Future<String> request(String path, bool decrypt) async {
    HttpClient httpClient = new HttpClient();
    HttpClientRequest request = await httpClient.getUrl(Uri.parse(HOST + path));
    request.headers.add("content-type", "application/json;charset=utf-8");
    request.headers.add("authorization", Token);

    HttpClientResponse response = await request.close();
    String retText = await response.transform(utf8.decoder).join();
    //print(retText);
    httpClient.close();
    if(!decrypt){
      return retText;
    }
    return decryptData(retText);
  }

  //解密请求返回的数据
  String decryptData(String str){
    var retObj = json.decode(str);
    String aesKey = Token.substring(2, 18);
    var key = Key.fromUtf8(aesKey);
    var encrypter = Encrypter(AES(key, mode: AESMode.cbc));
    return encrypter.decrypt64(retObj['encData'], iv: IV.fromUtf8(aesKey));
  }

}