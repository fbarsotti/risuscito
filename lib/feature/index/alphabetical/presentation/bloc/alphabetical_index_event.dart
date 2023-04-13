part of 'alphabetical_index_bloc.dart';

@immutable
abstract class AlphabeticalIndexEvent {}

class GetAlphabeticalIndexedSongs extends AlphabeticalIndexEvent {
  final String languageCode;

  GetAlphabeticalIndexedSongs({
    required this.languageCode,
  });
}
