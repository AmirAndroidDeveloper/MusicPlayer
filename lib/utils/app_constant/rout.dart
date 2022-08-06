
import 'package:flutter/cupertino.dart';
import 'package:music_app/screens/main/main_page.dart';
import 'package:music_app/screens/play_list/play_list_page.dart';

class AppRout {
  static final Map<String, WidgetBuilder> routes = {

    '/playList': (context) => const PlayListPage(),
    '/audioPlayer': (context) => const MainPage(),
  };
}
