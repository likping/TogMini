import './Audio.dart';
abstract class FileStore{
  Future<String >songSource(String link);
  Future<Map<String,dynamic>>search(String keyword,{String provider,int page=0});
}