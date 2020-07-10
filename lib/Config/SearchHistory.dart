Map<String ,dynamic>toMap_(SearchHistory t){
  var map=<String,dynamic>{
    "keyword":t.keyword,
  };
  if(t.id!=null){
    map['id']=t.id;
  }
  return map;
}

class SearchHistory {
  int id;
  String keyword;

  Map<String ,dynamic>toMap(){
    return toMap_(this);
  }
  static SearchHistory fromMap(Map<String,dynamic> map)=>
      SearchHistory(map["keyword"],id:map["id"]);

  SearchHistory(this.keyword, {this.id});
  String toString(){
    return " "+this.id.toString()+"  "+this.keyword;
  }
}


