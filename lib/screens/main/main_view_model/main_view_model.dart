import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/base/base_view_model.dart';
import 'package:music_app/main.dart';
import 'package:on_audio_query/on_audio_query.dart';

class MainViewModel extends BaseViewModel {
  bool isFirstTry = true;
  double sliderValue = 0.0;
  double volumeSliderValue = 1;
  List<SongModel> deviceSongs = [];

  void setSliderValue(double value) {
    sliderValue = value;
    notifyListeners();
  }
  Future<void> getSongList() async {
    List<SongModel> something = await OnAudioQuery().querySongs();
    deviceSongs = something;
    notifyListeners();
  }
  Future<void> setVolumeSliderValue(double value) async {
    await audioPlayer.setVolume(value);
    volumeSliderValue = value;
    notifyListeners();
  }


}

final mainViewModelProvider = ChangeNotifierProvider<MainViewModel>(
  (ref) => MainViewModel(),
);
