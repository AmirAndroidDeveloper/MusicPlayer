import 'dart:async';

import 'package:audio_service/audio_service.dart';

import 'package:just_audio/just_audio.dart';
import 'package:music_app/main.dart';

class MyAudioHandler extends BaseAudioHandler {

  final _playlist = ConcatenatingAudioSource(children: []);

  MyAudioHandler() {
    _loadEmptyPlaylist();
    _notifyAudioHandlerAboutPlaybackEvents();
    _listenForDurationChanges();
  }



  Future<void> _loadEmptyPlaylist() async {
    try {

      await audioPlayer.setAudioSource(_playlist);
    } catch (e) {

    }
  }


  @override
  Future<void> play() async {

    playbackState.add(
        playbackState.value.copyWith(

          playing: true,

          systemActions: const {
            MediaAction.seek,
            MediaAction.seekForward,
            MediaAction.seekBackward,
          },

          androidCompactActionIndices: const [0, 1, 3],
          controls: [MediaControl.rewind ,MediaControl.stop,MediaControl.pause,MediaControl.fastForward,],

        ));

    await audioPlayer.play();
    return super.play();
  }

  @override
  Future<void> pause() async {

    playbackState.add(playbackState.value.copyWith(

      //playing: false,

        controls: [MediaControl.rewind ,MediaControl.stop,MediaControl.play,MediaControl.fastForward,]
    ));
    await audioPlayer.pause();
    return super.pause();
  }

  @override
  Future<void> fastForward() async {
    int time = await audioPlayer.position.inMilliseconds;
    int finalTime = await audioPlayer.duration!.inMilliseconds;
    if (time + 15000 < finalTime) {
      audioPlayer.seek(Duration(milliseconds: time + 15000));
    }
    return super.fastForward();
  }

  @override
  Future<void> rewind() async {
    int time = await audioPlayer.position.inMilliseconds;
    if (time - 15000 > 0) {
      audioPlayer.seek(Duration(milliseconds: time - 15000));
    }
    return super.rewind();
  }

  Timer? _sleepTimer;
  Duration? _duration;

  activeSleepMode(Duration d){
    if (_sleepTimer?.isActive ?? false) _sleepTimer?.cancel();
    _sleepTimer = Timer(d, () {
      pause();
    });
  }

  @override
  Future customAction(

      String name, [
        Map<String, dynamic>? extras,
      ]) async {
    if (name == 'dispose') {
      await audioPlayer.dispose();
      super.stop();
    }else if (name == 'activeSleepMode') {

      if (_sleepTimer?.isActive ?? false) _sleepTimer?.cancel();
      _duration=extras!['duration'] as Duration;
      _sleepTimer = Timer(_duration!, () async {
        _duration=null;
        pause();
      });
    }else if (name == 'cancelTimer') {
      if (_sleepTimer?.isActive ?? false) _sleepTimer?.cancel();
    }else if (name == 'getTimer') {
      print('get timer');
      if (_sleepTimer?.isActive ?? false) return _duration!.inMinutes; else return 0;;

    }else if (name == 'cancelSleepMode') {
      if(_duration!=null){
        _duration=null;
        _sleepTimer?.cancel();
      }

    }
  }
  @override
  Future<void> stop() async {
    playbackState.add(playbackState.value.copyWith(
      playing: false,

    ));

    await audioPlayer.stop();
    return super.stop();
  }


  @override
  Future<void> seek(Duration position) {
    audioPlayer.seek(position);
    return super.seek(position);
  }
  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    _playlist.clear();
    final audioSource = mediaItems.map(_createAudioSource);
    _playlist.addAll(audioSource.toList());
    final newQueue = queue.value..addAll(mediaItems);
    queue.add(newQueue);
  }
  UriAudioSource _createAudioSource(MediaItem mediaItem) {
    return AudioSource.uri(
      Uri.parse(mediaItem.extras!['url']),
      tag: mediaItem,
    );
  }

  void _notifyAudioHandlerAboutPlaybackEvents() {
    audioPlayer.playbackEventStream.listen((PlaybackEvent event) {
      print('_notifyAudioHandlerAboutPlaybackEvents $event');
      final playing = audioPlayer.playing;
      playbackState.add(playbackState.value.copyWith(
        controls: [
          MediaControl.rewind,
          MediaControl.stop,
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.fastForward,
        ],

        systemActions: const {
          MediaAction.seek,MediaAction.seekForward,MediaAction.pause,MediaAction.fastForward,MediaAction.playPause
        },
        androidCompactActionIndices: const [0, 1, 3],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[audioPlayer.processingState]!,
        playing: playing,
        updatePosition: audioPlayer.position,
        bufferedPosition: audioPlayer.bufferedPosition,
        speed: audioPlayer.speed,
        queueIndex: event.currentIndex,
      ));
    });
  }
  void _listenForDurationChanges() {
    audioPlayer.durationStream.listen((duration) {
      final index = audioPlayer.currentIndex;
      final newQueue = queue.value;
      if (index == null || newQueue.isEmpty) return;
      final oldMediaItem = newQueue[index];
      final newMediaItem = oldMediaItem.copyWith(duration: duration);
      newQueue[index] = newMediaItem;
      queue.add(newQueue);
      mediaItem.add(newMediaItem);
    });
  }

}
