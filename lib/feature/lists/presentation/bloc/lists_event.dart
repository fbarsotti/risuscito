part of 'lists_bloc.dart';

@immutable
abstract class ListsEvent {}

class ListsGetAllListsEvent extends ListsEvent {
  final String languageCode;

  ListsGetAllListsEvent({required this.languageCode});
}

class ListsCreateListEvent extends ListsEvent {
  final String name;
  final String description;
  final String languageCode;

  ListsCreateListEvent({
    required this.name,
    required this.description,
    required this.languageCode,
  });
}

class ListsAddSongToListEvent extends ListsEvent {
  final String listId;
  final String songId;
  final String languageCode;

  ListsAddSongToListEvent({
    required this.listId,
    required this.songId,
    required this.languageCode,
  });
}
