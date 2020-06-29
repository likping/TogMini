import './Audio.dart';
import './FileStore.dart';
import './AudioApiClient.dart';
class AudioFileStore extends FileStore{
  final AudioApiClient apiClient;
  AudioFileStore({AudioApiClient apiClient}):this.apiClient=apiClient??AudioApiClient();
  Future<String> songSource(String link){
      return apiClient.getAudioFile(link);
  }
  Future<Map<String,dynamic>>search(String keyword,{String provider,int page=0})async {
    return apiClient.getSearchFile(keyword,provider: provider,page: page);

  }
  Future<List<Audio>>hot(String platform){
    return apiClient.getHotFile(platform);
  }
  Future<double>count(String keyword,{String provider,int page=0}){
    return apiClient.getSearcFileCount(keyword,provider: provider,page: page);
  }
}