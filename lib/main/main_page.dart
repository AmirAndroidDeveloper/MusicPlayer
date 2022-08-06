 import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/main/component/main_body.dart';

class MainPage extends ConsumerWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return  SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xFF1b2026),
        body: MainBody(),
      ),
    );
  }
}
