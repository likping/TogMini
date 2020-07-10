// 本地音乐文件类
class Audio {
    var originalId;
    var dbid;
    String name;
    String link;
    var alias;
    var mvLink;
    var artists;//[{...}]
    var album;
    bool hasCopyright;
    num fee;
    String platform;

    get songSourceLink {
      return "${this.platform}/${this.originalId}";
    }
    Map<String ,dynamic>toMap(){
      var map=<String,dynamic>{
      "originalId":this.originalId,
      "name":this.name,
      "link":this.link,
      "alias":this.alias,
      "mvLink":this.mvLink,
      "platform":this.platform
      };
      if(this.dbid!=null){
        map['id']=this.dbid;
      }
      return map;
    }
    static Audio fromMap(Map<String,dynamic> map)=>
        Audio(originalId: map["originalId"],name: map["name"],link:map["link"],alias:map["alias"],mvLink: map["mvLink"],platform: map["platform"],dbid: map["id"]);
    Audio({this.originalId,this.name,this.platform,this.album,this.artists,this.fee,this.hasCopyright,this.link,this.mvLink,this.dbid,this.alias});
    Audio.fromJson(Map<String,dynamic>json){
        originalId=json["originalId"];
        name=json["name"];
        link=json["link"];
        alias=json["alias"];
        mvLink=json["mvLink"];
        artists=json["artists"];
        album=json["album"];
        hasCopyright=json["hasCopyright"];
        platform=json["platform"];
    }
    Map<String, dynamic> toJson() {
      final Map<String, dynamic> json = new Map<String, dynamic>();
      json["originalId"]=originalId;
      json["name"]=name;
      json["link"]=link;
      json["alias"]=alias;
      json["mvLink"]=mvLink;
      json["artists"]=artists;
      json["album"]=album;
      json["hasCopyright"]=hasCopyright;
      json["platform"]=platform;
      return json;
    }

}