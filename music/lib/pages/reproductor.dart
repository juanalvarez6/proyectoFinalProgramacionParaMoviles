import 'dart:async';
import 'package:flutter/material.dart';
import 'package:music/models/song.dart';
import 'package:music/pages/favorites.dart';
import 'package:music/pages/home_page.dart';

// ignore: must_be_immutable
class Reproductor extends StatefulWidget {
  Reproductor(
      {super.key, required this.song, required this.songs, required this.view});

  List<Song> songs;
  Song song;
  int view;

  @override
  State<Reproductor> createState() => _ReproductorState();
}

class _ReproductorState extends State<Reproductor> {
  Duration? duration;
  Duration? position;
  late List<StreamSubscription> streams;
  double volume = 1;

  @override
  void initState() {
    super.initState();

    Song.player.getDuration().then((it) => setState(() => duration = it));
    Song.player.getCurrentPosition().then(
          (it) => setState(() => position = it),
        );

    streams = <StreamSubscription>[
      Song.player.onDurationChanged
          .listen((it) => setState(() => duration = it)),
      Song.player.onPositionChanged
          .listen((it) => setState(() => position = it)),
    ];
  }

  @override
  void dispose() {
    super.dispose();
    for (var it in streams) {
      it.cancel();
    }
  }

  @override
  void setState(VoidCallback fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: MyHomePageState.theme ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: createIconButton(Icons.chevron_left, 32, () {
            if (widget.view == 1) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()));
            } else if (widget.view == 2) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Favorites(
                            song: widget.song,
                          )));
            }
            setState(() {
              MyHomePageState.song = widget.song;
            });
          }),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                children: [
                  Image(
                      height: 300,
                      image: NetworkImage(
                          MyHomePageState.images[widget.song.index])),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.song.nameSong,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Card(
                child: Column(
                  children: [
                    Slider(
                      value: position!.inSeconds.toDouble(),
                      max: duration!.inSeconds.toDouble(),
                      onChanged: (double seconds) {
                        setState(() {
                          Song.player.seek(Duration(seconds: seconds.toInt()));
                        });
                      },
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${(position!.inMinutes % 60)}:${(position!.inSeconds % 60)}     ',
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        createIconButton(Icons.volume_down, 20, () {
                          setState(() {
                            if (volume != 0) {
                              volume -= 0.1;
                              Song.player.setVolume(volume);
                            }
                          });
                        }),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            createIconButton(Icons.skip_previous, 32, () {
                              setState(() {
                                if (widget.song == widget.songs[0]) {
                                  widget.song =
                                      widget.songs[widget.songs.length - 1];
                                  MyHomePageState.playAudioFromUrl(
                                      Song.player, widget.song.urlSong);
                                  MyHomePageState.playing = true;
                                } else {
                                  widget.song =
                                      widget.songs[widget.song.index - 1];
                                  MyHomePageState.playAudioFromUrl(
                                      Song.player, widget.song.urlSong);
                                  MyHomePageState.playing = true;
                                }
                              });
                            }),
                            createIconButton(
                                MyHomePageState.playing == false
                                    ? Icons.play_arrow
                                    : Icons.pause,
                                32, () {
                              setState(() {
                                if (MyHomePageState.playing == false) {
                                  MyHomePageState.playAudioFromUrl(
                                      Song.player, widget.song.urlSong);
                                  MyHomePageState.playing = true;
                                } else {
                                  Song.player.pause();
                                  MyHomePageState.playing = false;
                                }
                              });
                            }),
                            createIconButton(Icons.skip_next, 32, () {
                              setState(() {
                                if (widget.song ==
                                    widget.songs[widget.songs.length - 1]) {
                                  widget.song = widget.songs[0];
                                  MyHomePageState.playAudioFromUrl(
                                      Song.player, widget.song.urlSong);
                                  MyHomePageState.playing = true;
                                } else {
                                  int indexSong =
                                      widget.songs.indexOf(widget.song);
                                  widget.song = widget.songs[indexSong + 1];
                                  MyHomePageState.playAudioFromUrl(
                                      Song.player, widget.song.urlSong);
                                  MyHomePageState.playing = true;
                                }
                              });
                            })
                          ],
                        ),
                        createIconButton(Icons.volume_up, 20, () {
                          setState(() {
                            if (volume < 1) {
                              volume += 0.1;
                              Song.player.setVolume(volume);
                            }
                          });
                        })
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
