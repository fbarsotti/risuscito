part of 'songs_bloc.dart';

@immutable
abstract class SongsEvent {}

class GetLocalizedSongs extends SongsEvent {
  final String languageCode;
  final bool? forceReload;

  GetLocalizedSongs({
    required this.languageCode,
    this.forceReload,
  });
}
