part of 'songs_bloc.dart';

@immutable
abstract class SongsState {}

class SongsInitial extends SongsState {}

class SongsLoading extends SongsState {}

class SongsLoaded extends SongsState {
  final List<SongDomainModel> songs;

  SongsLoaded({
    required this.songs,
  });
}

class SongsFailure extends SongsState {
  final Failure failure;

  SongsFailure({
    required this.failure,
  });
}
