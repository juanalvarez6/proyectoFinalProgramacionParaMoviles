import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:music/models/song.dart';
import 'package:music/models/favorites.dart';
import 'package:music/pages/reproductor.dart';
import 'package:music/pages/favorites.dart';
import 'package:provider/provider.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  static List<Song> songs = SongModelo.getSongs();
  static bool theme = false;

  static Song song = SongModelo.getSongs()[0];
  static final List<String> images = [];
  static bool playing = false;
  int pressBoton = 0;

  @override
  void initState() {
    super.initState();

    for (var element in songs) {
      var url =
          Uri.parse('https://pokeapi.co/api/v2/pokemon/${element.index + 1}');
      http.get(url).then((response) {
        if (response.statusCode == 200) {
          var json = jsonDecode(response.body);

          images.add(json['sprites']['other']['home']['front_default']);

          setState(() {});
        }
      });
    }
  }

  static Future<void> playAudioFromUrl(AudioPlayer player, String url) async {
    await player.play(UrlSource(url));
  }

  @override
  Widget build(BuildContext context) {
    final favoritesList = context.watch<FavoriteModels>();
    return Theme(
      data: theme ? ThemeData.dark() : ThemeData.light(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Mi música',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  theme = !theme;
                });
              },
              icon: theme
                  ? const Icon(Icons.light_mode)
                  : const Icon(Icons.dark_mode),
            )
          ],
        ),
        drawer: Drawer(
          child: ListView(
            children: [
              const DrawerHeader(
                child: Text('Music'),
              ),
              ListTile(
                leading: const Icon(Icons.home),
                title: const Text('Inicio'),
                onTap: () {},
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: const Text('Configuración'),
                onTap: () {},
              ),
            ],
          ),
        ),
        body: Column(children: <Widget>[
          Expanded(
            child: ListView.builder(
                itemCount: songs.length,
                itemBuilder: (context, index) {
                  return Container(
                    margin: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    padding: const EdgeInsets.only(bottom: 5),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                width: 1.0,
                                color:
                                    !theme ? Colors.black54 : Colors.white38))),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          child: Row(
                            children: [
                              Image(
                                  width: 40,
                                  height: 40,
                                  image: NetworkImage(images[index])),
                              Text(
                                songs[index].nameSong,
                                style: !theme
                                    ? const TextStyle(color: Colors.black)
                                    : const TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                          onPressed: () {
                            if (playing == false || song != songs[index]) {
                              setState(() {
                                song = songs[index];
                                playing = true;
                                playAudioFromUrl(Song.player, song.urlSong);
                              });
                            }
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Reproductor(
                                          song: song,
                                          songs: songs,
                                          view: 1,
                                        )));
                          },
                        ),
                        AnimatedFavoriteButton(
                          isFavorite:
                              favoritesList.items.contains(songs[index]),
                          onTap: () {
                            setState(() {
                              !favoritesList.items.contains(songs[index])
                                  ? favoritesList.add(songs[index])
                                  : favoritesList.remove(songs[index]);
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  favoritesList.items.contains(songs[index])
                                      ? 'Agregado a favoritos.'
                                      : 'Eliminado de favoritos.',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  );
                }),
          ),
          Container(
            decoration: BoxDecoration(
              border: Border(
                top: BorderSide(
                    width: 1.0,
                    color: !theme ? Colors.black54 : Colors.white38),
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  child: Text(
                    song.nameSong,
                    style: !theme
                        ? const TextStyle(color: Colors.black)
                        : const TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    if (playing == false && pressBoton == 0) {
                      setState(() {
                        playAudioFromUrl(Song.player, song.urlSong);
                        playing = true;
                      });
                    }
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Reproductor(
                                  song: song,
                                  songs: songs,
                                  view: 1,
                                )));
                  },
                ),
                Row(
                  children: [
                    createIconButton(
                        !playing ? Icons.play_arrow : Icons.pause, 32, () {
                      pressBoton++;
                      if (playing == false) {
                        setState(() {
                          playing = true;
                        });
                        playAudioFromUrl(Song.player, song.urlSong);
                      } else {
                        setState(() {
                          playing = false;
                        });
                        Song.player.pause();
                      }
                    }),
                    createIconButton(Icons.skip_next, 32, () {
                      setState(() {
                        if (song.index + 1 == songs.length) {
                          song = songs[0];
                          playAudioFromUrl(Song.player, song.urlSong);
                          playing = true;
                        } else {
                          song = songs[song.index + 1];
                          playAudioFromUrl(Song.player, song.urlSong);
                          playing = true;
                        }
                      });
                    }),
                  ],
                ),
              ],
            ),
          ),
        ]),
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
          currentIndex: 0,
          onTap: (index) {
            if (index == 1) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => Favorites(
                            song: song,
                          )));
            }
          },
        ),
      ),
    );
  }
}

class AnimatedFavoriteButton extends StatefulWidget {
  final bool isFavorite;
  final VoidCallback onTap;

  const AnimatedFavoriteButton({
    Key? key,
    required this.isFavorite,
    required this.onTap,
  }) : super(key: key);

  @override
  State<AnimatedFavoriteButton> createState() => _AnimatedFavoriteButtonState();
}

class _AnimatedFavoriteButtonState extends State<AnimatedFavoriteButton> {
  bool _showProgress = false;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              _showProgress = true;
            });

            widget.onTap();

            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                _showProgress = false;
              });
            });
          },
          icon: Icon(
            widget.isFavorite ? Icons.favorite : Icons.favorite_border,
            color: widget.isFavorite ? Colors.red : null,
          ),
        ),
        if (_showProgress)
          const Positioned(
            right: 0.0,
            top: 0.0,
            bottom: 0.0,
            left: 0.0,
            child: CircularProgressIndicator(),
          ),
      ],
    );
  }
}

Widget createIconButton(
    IconData icon, double iconSize, VoidCallback onPressed) {
  return IconButton(iconSize: iconSize, onPressed: onPressed, icon: Icon(icon));
}
