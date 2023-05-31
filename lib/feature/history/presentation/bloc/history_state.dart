part of 'history_bloc.dart';

@immutable
abstract class HistoryState {}

class HistoryInitial extends HistoryState {}

class HistoryLoading extends HistoryState {}

class HistoryLoaded extends HistoryState {
  final List<SongDomainModel> songs;

  HistoryLoaded({
    required this.songs,
  });
}

class HistoryFailure extends HistoryState {
  final Failure failure;

  HistoryFailure({
    required this.failure,
  });
}
