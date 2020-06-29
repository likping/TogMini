import "./Audio.dart";
import 'dart:convert';
import "dart:io";
import "./Player.dart";

class AudioApiClient {
  final HttpClient httpClient;
  final protocal = "http";
  final host = "112.124.19.202:8081";
  final audioInfoPath = "/api/song_source";
  final searchPath = "/api/search";
  final hotFile = "/api/hot_list";
  AudioApiClient({HttpClient httpClient})
      : this.httpClient = httpClient ?? HttpClient();

  Future<List<Audio>> getHotFile(String platform) async {
    var path = "$hotFile/${platform}";
    HttpClientRequest request = await httpClient.getUrl(Uri.http(host, path));

    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(Utf8Decoder()).join();
    var json = jsonDecode(responseBody);
    var list = (json["data"] as Map<String, dynamic>);
    var audiolist = (list["songs"] as List<dynamic>);
    return audiolist.map((f) => Audio.fromJson(f)).toList();
  }

  Future<String> getAudioFile(String link) async {
    var path = "$audioInfoPath/${link}";
    HttpClientRequest request = await httpClient.getUrl(Uri.http(
        host, path
    ));
    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(Utf8Decoder()).join();

    try {
      var json = jsonDecode(responseBody);
      if(json["status"]=="ok"){
        var list = (json["data"] as Map<String, dynamic>);
        var songSource = (list["songSource"]);
        return songSource;
      }else{

        return "warning";
      }
    }catch(e) {
      print(e.toString());
    };


  }

  Future<Map<String,dynamic>> getSearchFile(String keyword,
      {String provider, int page = 1}) async {
    HttpClientRequest request = await httpClient.getUrl(Uri.http(
        host,
        searchPath,
        {"provider": provider, "keyword": keyword, "page": "$page"}));
    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(Utf8Decoder()).join();
    var json = jsonDecode(responseBody);

    var list = (json["data"] as Map<String, dynamic>);
    var audiolist =(list["songs"] as List<dynamic>);
    var data=Map<String,dynamic>();
    var audios= audiolist.map((f) => Audio.fromJson(f)).toList();
    data["audios"]=audios;
    if(audios.length<6){
      data["totalCount"]=1;
    }else{
      data["totalCount"]=(list["totalCount"]/6).toInt();
    }
    return  data;
  }


  Future<double>getSearcFileCount(String keyword,
      {String provider, int page = 1})async{
    HttpClientRequest request = await httpClient.getUrl(Uri.http(
        host,
        searchPath,
        {"provider": provider, "keyword": keyword, "page": "$page"}));
    print(request.uri);
    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(Utf8Decoder()).join();
    var json = jsonDecode(responseBody);
    var list = (json["data"] as Map<String, dynamic>);
    if(list["totalCount"]<=6){
      return 1;
    }
    return (list["totalCount"]/6).toInt();
  }
}
