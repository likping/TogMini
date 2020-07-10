class PathUtils{
  static String basename(String path){
    return path.split("/storage/emulated/0/")[1];
  }
  static String basenameWithoutExtension(String path){
    return path.toLowerCase();
  }
  static String dirname(String path){
    var paths=path.split("/");
    var subPath=paths.sublist(0,paths.length-1);
    var dir=subPath.join("/");
    if(dir.length==0){
      return "/";
    }
    return dir;
  }
  static String join(String a,String b){
    List<String>path=[a,b];
    print(path);
    return path.join("/");
  }
}