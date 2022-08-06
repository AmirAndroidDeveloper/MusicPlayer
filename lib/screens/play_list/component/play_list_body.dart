import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:music_app/main.dart';
import 'package:music_app/screens/main/main_page.dart';
import 'package:music_app/screens/main/main_view_model/main_view_model.dart';
import 'package:music_app/utils/app_constant/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayListBody extends ConsumerStatefulWidget {
  const PlayListBody({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return PlayState();
  }
}

final OnAudioQuery _audioQuery = OnAudioQuery();

class PlayState extends ConsumerState<PlayListBody> {
  @override
  void initState() {
    super.initState();
    OnAudioQuery();
    requestStoragePermission();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    final viewModel = ref.watch(mainViewModelProvider);

    return SingleChildScrollView(
        child: Column(
      children: [
        Container(
          margin: EdgeInsets.only(top: _height * .02, right: 20, left: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                Icons.arrow_back_ios,
                color: white,
                size: 20,
              ),
              Container(
                margin: const EdgeInsets.only(left: 30),
                child: Text(
                  "Playlist",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: white),
                ),
              ),
              Row(
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 15),
                    child: Icon(
                      Icons.search,
                      size: 20,
                      color: white,
                    ),
                  ),
                  Icon(
                    Icons.more_vert,
                    size: 20,
                    color: white,
                  ),
                ],
              )
            ],
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: 50),
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: viewModel.deviceSongs.length,
            itemBuilder: (context, index) {
              SongModel song = viewModel.deviceSongs[index];
              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/audioPlayer",
                    arguments: AudioPlayerArguments(index),
                  );
                },
                child: Container(
                  margin: const EdgeInsets.only(top: 15, right: 30, left: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: const Color(0xFF7a7e87)),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Container(
                          margin: const EdgeInsets.only(
                              left: 10, right: 15, top: 10, bottom: 10),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: QueryArtworkWidget(
                              keepOldArtwork: true,
                              id: viewModel.deviceSongs.isNotEmpty ? song.id : 0,
                              type: ArtworkType.AUDIO,
                            ),
                          )),
                      Container(
                          width: 130,
                          margin: const EdgeInsets.only(right: 20),
                          child: Column(
                            children: [
                              Text(
                                song.title,
                                overflow: TextOverflow.ellipsis,
                              ),
                              Text(song.artist ?? "",
                                  overflow: TextOverflow.ellipsis),
                            ],
                          )),
                      Container(
                        width: 45,
                        height: 45,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFFf7117d),
                        ),
                        child: Container(
                          margin: const EdgeInsets.all(5),
                          child: Icon(
                              audioHandler.queue.value.isNotEmpty?
                            audioHandler.queue.value[0].id==song.id.toString()?
                            Icons.play_arrow: Icons.pause: Icons.play_arrow,
                            size: 25,
                            color: white,
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: Icon(
                          CupertinoIcons.heart_solid,
                          size: 20,
                          color: white,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 20),
                          alignment: Alignment.topRight,
                          child: Icon(
                            Icons.more_vert,
                            color: white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    ));
  }

  void requestStoragePermission() async {
    if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      } else {
        final viewModel = ref.watch(mainViewModelProvider);
        viewModel.getSongList();

      }
    }
  }

  void getDeviceSongs() async {
    final viewModel = ref.watch(mainViewModelProvider);

    viewModel.getSongList();
  }
}
