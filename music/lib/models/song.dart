import 'package:audioplayers/audioplayers.dart';

class SongModelo {
  static final List<String> files = [
    'assets/music/Arcangel_Como_Tiene_Que_Ser.mp3',
    'assets/music/Arcangel_Mi_Voz_Mi_Estilo_Mi_Flow.mp3',
    'assets/music/Daddy_Yankee_Perros_Salvajes.mp3',
    'assets/music/Farruko_Besas_Tan_Bien.mp3',
    'assets/music/J._Balvin_La_Venganza.mp3',
    'assets/music/Arcangel_Como_Tiene_Que_Ser.mp3',
    'assets/music/Arcangel_Mi_Voz_Mi_Estilo_Mi_Flow.mp3',
    'assets/music/Daddy_Yankee_Perros_Salvajes.mp3',
    'assets/music/Farruko_Besas_Tan_Bien.mp3',
    'assets/music/J._Balvin_La_Venganza.mp3',
  ];

  static List<Song> getSongs() {
    final List<Song> songs = [];
    int index = 0;
    for (String file in files) {
      songs.add(Song(
          file.split('/').last.split('.m').first.replaceAll('_', ' '),
          file,
          index));
      index++;
    }

    return songs;
  }
}

class Song {
  final String _nameSong;
  final String _urlSong;
  final int index;

  static final player = AudioPlayer();

  Song(this._nameSong, this._urlSong, this.index);

  String get nameSong => _nameSong;

  String get urlSong => _urlSong;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Song &&
          runtimeType == other.runtimeType &&
          _nameSong == other._nameSong &&
          _urlSong == other._urlSong &&
          index == other.index;

  @override
  int get hashCode => _nameSong.hashCode ^ _urlSong.hashCode ^ index.hashCode;
}
