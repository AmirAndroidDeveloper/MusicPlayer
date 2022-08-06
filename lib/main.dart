import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import 'package:music_app/screens/main/main_page.dart';
import 'package:music_app/screens/play_list/play_list_page.dart';
import 'package:music_app/theme.dart';
import 'package:music_app/utils/app_constant/rout.dart';
import 'package:music_app/utils/audio_handler.dart';

 late AudioHandler audioHandler;
late AudioPlayer audioPlayer;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  audioPlayer = AudioPlayer();
  audioHandler = await AudioService.init(
    builder: () => MyAudioHandler(),
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.example.music_app',
      androidNotificationChannelName: 'MusicPlayer',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music Player',
      theme: lightThemeData(context),
      darkTheme: lightThemeData(context),
      initialRoute: '/',
      routes: AppRout.routes,
      debugShowCheckedModeBanner: false,

      home: const PlayListPage(),
    );
  }
}


