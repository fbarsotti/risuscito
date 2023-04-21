part of 'songs_biblical_bloc.dart';

@immutable
abstract class SongsBiblicalState {}

class SongsBiblicalInitial extends SongsBiblicalState {}

class SongsBiblicalLoading extends SongsBiblicalState {}

class SongsBiblicalLoaded extends SongsBiblicalState {
  final List<SongDomainModel> songs;

  SongsBiblicalLoaded({
    required this.songs,
  });
}

class SongsBiblicalFailure extends SongsBiblicalState {
  final Failure failure;

  SongsBiblicalFailure({
    required this.failure,
  });
}
