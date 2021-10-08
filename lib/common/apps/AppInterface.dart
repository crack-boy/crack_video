abstract class AppInterface{
  getCategoryList(int page){}
  getVideoList({CategoryItem categoryItem, int page}){}
  getVideoItem(Map<String, dynamic> json){}
  getVideoUrl(VideoItem videoItem){}
}

class CategoryItem{
  final String cid;
  final String title;
  final String pid;

  CategoryItem(this.cid, this.title, this.pid);
}

class VideoItem{
  final String vid;
  final String title;
  final String url;

  VideoItem(this.vid, this.title, this.url);

}