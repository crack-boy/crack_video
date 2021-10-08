import 'package:crack_video/common/apps/AppConfig.dart';
import 'package:crack_video/common/apps/AppFunc.dart';
import 'package:flutter/material.dart';
import 'package:crack_video/common/apps/AppInterface.dart';
import 'package:crack_video/view/video-detail.dart';

class VideoList extends StatefulWidget{
  VideoList({Key key, this.appName, this.listTitle, this.categoryItem}) : super(key: key);
  final String appName;
  final String listTitle;
  CategoryItem categoryItem;
  @override
  State<StatefulWidget> createState()  => VideoListState(appName: this.appName, listTitle: this.listTitle, categoryItem: this.categoryItem);

}
class VideoListState extends State {
  VideoListState({ this.appName, this.listTitle, CategoryItem categoryItem});
  final String appName;
  final String listTitle;
  CategoryItem categoryItem;
  List videoList = [AppConfig.loadingTag];
  bool isLoading = false;
  bool hasMore = true;
  int page = 0;


  @override
  void initState() {
    super.initState();
    this._loadingData();
  }
  _loadingData() async {
    if (isLoading) {
      return;
    }
    AppFunc appFunc = new AppFunc(this.appName);
    try{
      this.isLoading = true;
      var list = await appFunc.getVideoList(page: this.page, categoryItem: this.categoryItem);
      setState(() {
        this.videoList.insertAll(this.videoList.length - 1, list);
        this.page ++;
        if(list.length > 0){
          this.hasMore = true;
        }else{
          this.hasMore = false;
        }
        this.isLoading = false;
      });
    }catch(e) {
      print(e);
      this.isLoading = false;
    }

  }
  @override
  Widget build(BuildContext context) {

    return new Scaffold(
        appBar: new AppBar(
          title: Text(this.listTitle),
        ),
        body: new Center(
            child: new ListView.separated(
              itemBuilder: (BuildContext context, int index) {
                //如果到了表尾
                if(videoList[index] == AppConfig.loadingTag){
                  if(hasMore){
                    //获取数据
                    this._loadingData();
                    //加载时显示loading
                    return Container(
                      padding: const EdgeInsets.all(16.0),
                      alignment: Alignment.center,
                      child: SizedBox(
                          width: 24.0,
                          height: 24.0,
                          child: CircularProgressIndicator(strokeWidth: 2.0)
                      ),
                    );
                  }else{
                    return Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(16.0),
                        child: Text("没有更多了", style: TextStyle(color: Colors.grey),)
                    );
                  }
                }
                return ListTile(
                  title: Text(this.videoList[index].title),
                  onTap: (){
                    setState(() {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context)=> new VideoDetail(
                                videoItem: this.videoList[index],
                                appName: this.appName,
                              )
                          )
                      ).then((value) => this.setState(() {}));
                    });
                  },
                );
              },
              itemCount: videoList.length,
              separatorBuilder: (BuildContext context, int index) => new Divider(),

            )
        )
    );
  }

}