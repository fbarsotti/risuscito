part of 'history_bloc.dart';

@immutable
abstract class HistoryEvent {}

class GetLocalizedHistory extends HistoryEvent {
  final String languageCode;

  GetLocalizedHistory({
    required this.languageCode,
  });
}

class SaveInHistory extends HistoryEvent {
  final String languageCode;
  final String songId;

  SaveInHistory({
    required this.languageCode,
    required this.songId,
  });
}

class RemoveFromHistory extends HistoryEvent {
  final String songId;
  final bool reload;
  final String? languageCode;

  RemoveFromHistory({
    required this.songId,
    required this.reload,
    this.languageCode,
  });
}

class DeleteHistory extends HistoryEvent {}
