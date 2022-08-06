 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/screens/main/component/main_body.dart';

 class AudioPlayerArguments {
     final int index;

   AudioPlayerArguments(  this.index);
 }

class MainPage extends ConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final args =
    ModalRoute.of(context)!.settings.arguments as AudioPlayerArguments;
    return  SafeArea(
      child: Scaffold(
        backgroundColor: const Color(0xFF1b2026),
        body: MainBody(index: args.index),
      ),
    );
  }
}
