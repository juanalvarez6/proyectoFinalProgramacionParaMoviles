import 'package:flutter/material.dart';
import 'package:music/pages/home_page.dart';
import 'package:music/pages/reproductor.dart';
import 'package:music/models/song.dart';
import 'package:music/models/favorites.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class Favorites extends StatefulWidget {
  Favorites({super.key, required this.song});

  Song song;

  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  Song? get song => null;

  @override
  Widget build(BuildContext context) {
    var songs = context.watch<FavoriteModels>().items;
    return Theme(
      data: MyHomePageState.theme ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: const Text(
            'Favoritos',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        body: Consumer<FavoriteModels>(
            builder: (context, value, child) => value.items.isNotEmpty
                ? Column(children: [
                    Expanded(
                      child: ListView.builder(
                          itemCount: value.items.length,
                          padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  TextButton(
                                    child: Text(
                                      value.items[index].nameSong,
                                      style: !MyHomePageState.theme
                                          ? const TextStyle(color: Colors.black)
                                          : const TextStyle(
                                              color: Colors.white),
                                    ),
                                    onPressed: () {
                                      setState(() {
                                        MyHomePageState.playing = true;
                                        widget.song = value.items[index];
                                      });
                                      MyHomePageState.playAudioFromUrl(
                                          Song.player,
                                          value.items[index].urlSong);
                                    },
                                  ),
                                  createIconButton(
                                    Icons.remove_circle,
                                    28,
                                    () {
                                      context
                                          .read<FavoriteModels>()
                                          .remove(value.items[index]);
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                          content: Text(
                                              'Cancion eliminada de favoritos'),
                                          duration: Duration(seconds: 1),
                                        ),
                                      );
                                    },
                                  )
                                ],
                              ),
                            );
                          }),
                    ),
                    Container(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              child: Text(
                                widget.song.nameSong,
                                style: !MyHomePageState.theme
                                    ? const TextStyle(color: Colors.black)
                                    : const TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => Reproductor(
                                              song: widget.song,
                                              songs: songs,
                                              view: 2,
                                            )));
                              },
                            ),
                            Row(
                              children: [
                                createIconButton(
                                  !MyHomePageState.playing
                                      ? Icons.play_arrow
                                      : Icons.pause,
                                  32,
                                  () {
                                    if (MyHomePageState.playing == false) {
                                      setState(() {
                                        MyHomePageState.playing = true;
                                      });
                                      MyHomePageState.playAudioFromUrl(
                                          Song.player, widget.song.urlSong);
                                    } else {
                                      setState(() {
                                        MyHomePageState.playing = false;
                                      });
                                      Song.player.pause();
                                    }
                                  },
                                ),
                                createIconButton(Icons.skip_next, 32, () {
                                  setState(() {
                                    if (widget.song ==
                                        value.items[value.items.length - 1]) {
                                      widget.song = value.items[0];
                                      MyHomePageState.playAudioFromUrl(
                                          Song.player, widget.song.urlSong);
                                    } else {
                                      int indexSong =
                                          value.items.indexOf(widget.song);
                                      widget.song = value.items[indexSong + 1];
                                      MyHomePageState.playAudioFromUrl(
                                          Song.player, widget.song.urlSong);
                                    }
                                  });
                                }),
                              ],
                            ),
                          ],
                        )),
                  ])
                : const Center(
                    child: Text('No hay canciones agregadas a favoritos'))),
        bottomNavigationBar: BottomNavigationBar(
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.music_note),
              label: 'Mi música',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.favorite),
              label: 'Favoritos',
            ),
          ],
          currentIndex: 1,
          onTap: (index) {
            if (index == 0) {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const MyHomePage()));
              setState(() {
                MyHomePageState.song = song!;
              });
            }
          },
        ),
      ),
    );
  }
}
