import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/screens/play_list/component/play_list_body.dart';

class PlayListPage extends ConsumerWidget {
  const PlayListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const SafeArea(
        child: Scaffold(
          backgroundColor: const Color(0xFF1b2026),

          body: PlayListBody(),
    ));
  }
}
