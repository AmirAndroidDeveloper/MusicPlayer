import 'dart:io';
import 'package:audio_service/audio_service.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:async';
import 'package:audioplayers/notifications.dart';
import 'package:music_app/components/slider_gradiunt.dart';
import 'package:music_app/main.dart';
import 'package:music_app/main/main_view_model/main_view_model.dart';
import 'package:music_app/utils/app_constant/colors.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:sleek_circular_slider/sleek_circular_slider.dart';

class MainBody extends ConsumerStatefulWidget {
  MainBody({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() {
    return MainState();
  }
}

class MainState extends ConsumerState<MainBody>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  LinearGradient gradient = LinearGradient(colors: <Color>[
    Color(0XFFFFEE25),
    Color(0XFFFEE820),
    Color(0XFFFDD60E),
    Color(0XFFFDCA03),
    Color(0XFFFDC700),
    Color(0XFFF08F34),
    Color(0XFFE86031),
    Color(0XFFE2312D),
  ]);

  PlayerState _playerState = PlayerState.STOPPED;
  PlayingRoute _playingRouteState = PlayingRoute.SPEAKERS;
  StreamSubscription? _durationSubscription;
  StreamSubscription? _positionSubscription;
  StreamSubscription? _playerCompleteSubscription;
  StreamSubscription? _playerErrorSubscription;
  StreamSubscription? _playerStateSubscription;
  StreamSubscription<PlayerControlCommand>? _playerControlCommandSubscription;
  Duration? _duration;
  Duration? _position;
  final OnAudioQuery _audioQuery = OnAudioQuery();
  List<SongModel> deviceSongs = [];

  late List<FileSystemEntity> _files;
  final List<FileSystemEntity> _songs = [];

  String get _positionText => _position?.toString().split('.').first ?? '';

  String get _durationText => _duration?.toString().split('.').first ?? '';

  @override
  void initState() {
    super.initState();
    OnAudioQuery();

    requestStoragePermission();

    _controller = AnimationController(
      duration: const Duration(milliseconds: 15000),
      vsync: this,
    );
    _initAudioPlayer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  getSongInfo() async {
    List<SongModel> something = await OnAudioQuery().querySongs();
    deviceSongs = something;
    print("testt ${deviceSongs[0].id}");
  }

  getSongs() {
    Directory dir = Directory('/storage/emulated/0/');
    String mp3Path = dir.toString();
    print(mp3Path);

    _files = dir.listSync(recursive: true, followLinks: false);
    for (FileSystemEntity entity in _files) {
      String path = entity.path;
      if (path.endsWith('.mp3')) _songs.add(entity);
    }
    print("testt ${_songs}");
    print("testt ${_songs[0].path}");
    print("tstLengh ${_songs.length}");
  }

  void requestStoragePermission() async {
     if (!kIsWeb) {
      bool permissionStatus = await _audioQuery.permissionsStatus();
      if (!permissionStatus) {
        await _audioQuery.permissionsRequest();
      } else {
        setState(() {
          getSongInfo();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    final viewModel = ref.watch(mainViewModelProvider);
    if (audioPlayer.playing) {
      _controller.repeat();
      if (_duration == null) {
        _controller.reset();
      }
    } else {
      _controller.stop();
    }
    if(audioPlayer.playing){
      audioHandler.playbackState.listen((PlaybackState state) {
        switch (state.processingState) {
          case AudioProcessingState.idle:
            null;
            break;
          case AudioProcessingState.loading:
            null;
            break;
          case AudioProcessingState.buffering:
            null;
            break;
          case AudioProcessingState.ready:
            null;
            break;
          case AudioProcessingState.completed:
            {
              audioPlayer.pause();
              audioHandler.pause();
              audioPlayer.seek(Duration(milliseconds: 0),);
              setState(() => _playerState = PlayerState.STOPPED);
            }
            ;
            break;
          case AudioProcessingState.error:
        }
      });
    }

    return Container(
      height: _height,
      // decoration: BoxDecoration(
      // gradient: LinearGradient(
      //   begin: Alignment.bottomCenter,
      //   end: Alignment.topCenter,
      //
      //   colors: [
      //     Colors.black.withOpacity(.3),
      //      white
      //    ],
      // ),
      // ),
      child: Stack(
        children: [
          Column(
            children: [
              Container(
                margin:
                    EdgeInsets.only(top: _height * .02, right: 20, left: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: white,
                    ),
                    Text(
                      audioPlayer.playing ? "Playing Now" : "Stopping Now",
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: white),
                    ),
                    Icon(
                      Icons.more_vert,
                      size: 20,
                      color: white,
                    ),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: _height * .080),
                child: SleekCircularSlider(
                    appearance: CircularSliderAppearance(
                        animationEnabled: true,
                        customWidths: CustomSliderWidths(progressBarWidth: 10),
                        size: 200),
                    min: 0,
                    max: _duration?.inMilliseconds.toDouble() ?? 1500,
                    initialValue: _position?.inMilliseconds.toDouble() ?? 0.0,
                    onChange: (value) {
                      setState(
                        () {
                          final duration = _duration;
                          if (duration == null) {
                            return;
                          }
                          final Position = value;
                          audioPlayer.seek(
                            Duration(
                              milliseconds: Position.round(),
                            ),
                          );
                          audioHandler.play();
                        },
                      );
                    },
                    innerWidget: (_double) {
                      return RotationTransition(
                          turns:
                              Tween(begin: 0.0, end: 1.0).animate(_controller),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Container(
                                margin: const EdgeInsets.all(25),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(100),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.purple.withOpacity(0.4),
                                        spreadRadius: 7,
                                        blurRadius: 7,
                                      ),
                                    ]),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(100),
                                  child: QueryArtworkWidget(
                                    keepOldArtwork: true,
                                    id:deviceSongs.isNotEmpty? deviceSongs[0].id:0,
                                    type: ArtworkType.AUDIO,
                                  ),
                                )),
                          ));
                    }),
              ),
              Container(
                margin: EdgeInsets.only(top: _height * .01),
                child:
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                  Container(
                      margin: const EdgeInsets.only(right: 140),
                      child: Text(
                        _position != null
                            ? '$_positionText '
                            : _duration != null
                                ? _durationText
                                : '',
                        style: Theme.of(context)
                            .textTheme
                            .headline5!
                            .copyWith(color: white),
                      )),
                  Text(
                      _position != null
                          ? '$_durationText'
                          : _duration != null
                              ? _durationText
                              : '',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: white)),
                ]),
              ),
              Container(
                margin: EdgeInsets.only(top: _height * .05),
                child: Text(
                  deviceSongs.isNotEmpty?
                  deviceSongs[0].title:"Unknown",
                  style: Theme.of(context)
                      .textTheme
                      .headline2!
                      .copyWith(color: white),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: _height * .01),
                child: Text(
                  deviceSongs.isNotEmpty?
                  deviceSongs[0].artist ?? "":"Unknown",
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: lightGrey2),
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 100, left: 100, top: _height * .05),
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Color(0xFF252d3a)),
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(CupertinoIcons.add,
                          size: 22, color: Color(0xFF7a7e87)),
                      Icon(
                        CupertinoIcons.music_note_list,
                        size: 22,
                        color: Color(0xFF7a7e87),
                      ),
                      Icon(
                        CupertinoIcons.heart_fill,
                        size: 22,
                        color: Color(0xFF7a7e87),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: _height * .08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      CupertinoIcons.repeat,
                      color: white,
                    ),
                    Container(
                        margin: EdgeInsets.only(left: 35),
                        child: Icon(
                          CupertinoIcons.arrowtriangle_left_fill,
                          color: white,
                        )),
                    GestureDetector(
                      onTap: () {
                        if (audioPlayer.playing) {
                          audioHandler.pause();
                        } else {
                          _playerState = PlayerState.PLAYING;
                          setState(() => _playerState = PlayerState.PLAYING);
                          final mediaItems = [
                            MediaItem(
                              id: "1",
                              title: "The best moment of the life",
                              album: ' ',
                              extras: {'url':deviceSongs.isNotEmpty? deviceSongs[0].uri:""},
                            )
                          ];
                          audioHandler.addQueueItems(mediaItems);
                          audioHandler.updateMediaItem(mediaItems.first);
                          audioHandler.play();
                        }
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            color: const Color(0xFFf7117d),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFFf7117d).withOpacity(0.4),
                                spreadRadius: 7,
                                blurRadius: 7,
                              ),
                            ]),
                        child: Icon(
                          audioPlayer.playing ? Icons.pause : Icons.play_arrow,
                          color: white,
                          size: 30,
                        ),
                      ),
                    ),
                    Container(
                        margin: const EdgeInsets.only(right: 45),
                        child: Icon(
                          CupertinoIcons.play_arrow_solid,
                          color: white,
                        )),
                    Icon(
                      CupertinoIcons.shuffle,
                      color: white,
                    ),
                  ],
                ),
              ),
              Container(
                margin:
                    EdgeInsets.only(right: 35, left: 35, top: _height * .05),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.volume_down,
                      color: white,
                    ),
                    Expanded(
                        child: SliderTheme(
                      data: SliderThemeData(
                        trackShape: GradientRectSliderTrackShape(
                            gradient: gradient, darkenInactive: false),
                      ),
                      child: Slider(
                        onChanged: (value) {
                          viewModel.setVolumeSliderValue(value);
                        },
                        value: viewModel.volumeSliderValue,
                        max: 1,
                        min: 0,
                        activeColor: Color(0XFFb93e7b),
                        thumbColor: Color(0XFFb93e7b),
                      ),
                    )),
                    Icon(
                      Icons.volume_up,
                      color: white,
                    ),
                  ],
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  void _initAudioPlayer() {
    if (audioHandler.playbackState.value.playing) {}
    _durationSubscription = audioPlayer.durationStream.listen((duration) {
      setState(() {
        _duration = duration;
      });
      print('dddd $duration');
    });
    _positionSubscription =
        audioPlayer.positionStream.listen((p) => setState(() {
              _position = p;
              // final viewModel = ref.watch(getAudioBookDetailViewModelProvider);
              // viewModel.podcastAudioListened(_position!);
            }));

    audioPlayer.playerStateStream.listen(
      (event) {
        // handleSleepTime(false);
        if (event.playing) {
          if (this.mounted) {
            setState(
              () {
                _playerState = PlayerState.PLAYING;
              },
            );
          }
        } else {
          if (this.mounted) {
            setState(
              () {
                _playerState = PlayerState.STOPPED;
              },
            );
          }
        }
      },
    );

    _playingRouteState = PlayingRoute.SPEAKERS;
  }
}
