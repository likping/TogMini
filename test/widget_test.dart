import 'package:flutter_test/flutter_test.dart';
import "dart:io";
import "dart:convert";

void main() {
  test("测试网络请求", () async {
    //
    final HttpClient httpClient = HttpClient();
    final protocal = "http";
    final host = "112.124.19.202:8081";
    final audioInfoPath = "/api/song_source";
    final searchPath = "/api/search";
    final hotFile = "/api/hot_list";
    final platform = "qq";
    var path = "$hotFile/${platform}";
    HttpClientRequest request = await httpClient.getUrl(Uri.http(host, path));
    HttpClientResponse response = await request.close();
    var responseBody = await response.transform(Utf8Decoder()).join();
    var json = jsonDecode(responseBody);
    expect(json["status"], "ok");
    var list = (json["data"] as Map<String, dynamic>);
    expect(list, isNotEmpty);
    expect(list["songs"], isNotEmpty);
    //测试搜索
    request = await httpClient.getUrl(Uri.http(
        host, searchPath, {"provider": "qq", "keyword": '天空之城', "page": "1"}));
    response = await request.close();
    responseBody = await response.transform(Utf8Decoder()).join();
    json = jsonDecode(responseBody);
    expect(json["searchSuccess"], true);
    list = (json["data"] as Map<String, dynamic>);
    expect(list, isNotEmpty);
    expect(list["songs"], isNotEmpty);
    //测试音频接收
    path = "$audioInfoPath/qq/0017CNzV2j064M";
    request = await httpClient.getUrl(Uri.http(host, path));
    response = await request.close();
    responseBody = await response.transform(Utf8Decoder()).join();

    json = jsonDecode(responseBody);
    expect(json["status"], "ok");
    list = (json["data"] as Map<String, dynamic>);
    expect(list, isNotEmpty);
    expect(list["songSource"], isNotEmpty);
  });
}
