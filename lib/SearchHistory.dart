Map<String ,dynamic>toMap_(SearchHistory t){
  var map=<String,dynamic>{
    "keyword":t.keyword,
    "time":t.time??DateTime.now().millisecondsSinceEpoch,
  };
  if(t.id!=null){
    map['id']=t.id;
  }
  return map;
}

class SearchHistory {
  int id;
  String keyword;
  int time;
  Map<String ,dynamic>toMap(){
    return toMap_(this);
  }
  static SearchHistory fromMap(Map<String,dynamic> map)=>
      SearchHistory(map["keyword"],id:map["id"],time: map["time"]);

  SearchHistory(this.keyword, {this.id, this.time});
  String toString(){
    return " "+this.id.toString()+"  "+this.keyword+" "+this.time.toString();
  }
}


