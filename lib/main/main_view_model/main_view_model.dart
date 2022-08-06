import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/main.dart';

import '../../base/base_view_model.dart';

class MainViewModel extends BaseViewModel {
  bool isFirstTry = true;
  double sliderValue = 0.0;
  double volumeSliderValue = 1;

  void setSliderValue(double value) {
    sliderValue = value;
    notifyListeners();
  }

  Future<void> setVolumeSliderValue(double value) async {
    await audioPlayer.setVolume(value);
    volumeSliderValue = value;
    notifyListeners();
  }
}

final mainViewModelProvider = ChangeNotifierProvider.autoDispose<MainViewModel>(
  (ref) => MainViewModel(),
);
