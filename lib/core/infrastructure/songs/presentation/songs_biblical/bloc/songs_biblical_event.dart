part of 'songs_biblical_bloc.dart';

@immutable
abstract class SongsBiblicalEvent {}

class GetLocalizedSongsBiblical extends SongsBiblicalEvent {
  final String languageCode;

  GetLocalizedSongsBiblical({
    required this.languageCode,
  });
}
