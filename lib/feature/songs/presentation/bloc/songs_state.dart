part of 'songs_bloc.dart';

@immutable
abstract class SongsState {}

class SongsInitial extends SongsState {}

class SongsLoading extends SongsState {}

class SongsLoaded extends SongsState {
  final PagedSongsDomainModel songs;
  final bool forceReload;

  SongsLoaded({
    required this.songs,
    required this.forceReload,
  });
}

class SongsFailure extends SongsState {
  final Failure failure;

  SongsFailure({
    required this.failure,
  });
}
