part of 'songs_bloc.dart';

@immutable
abstract class SongsEvent {}

class GetLocalizedSongs extends SongsEvent {
  final String languageCode;

  GetLocalizedSongs({
    required this.languageCode,
  });
}
