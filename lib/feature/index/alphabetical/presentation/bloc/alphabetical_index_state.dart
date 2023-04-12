part of 'alphabetical_index_bloc.dart';

@immutable
abstract class AlphabeticalIndexState {}

class AlphabeticalIndexInitial extends AlphabeticalIndexState {}

class AlphabeticalIndexLoading extends AlphabeticalIndexState {}

class AlphabeticalIndexLoaded extends AlphabeticalIndexState {
  final List<SongDomainModel> songs;

  AlphabeticalIndexLoaded({
    required this.songs,
  });
}

class AlphabeticalIndexFailure extends AlphabeticalIndexState {
  final Failure failure;

  AlphabeticalIndexFailure({
    required this.failure,
  });
}
