part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesEvent {}

class GetLocalizedFavourites extends FavouritesEvent {
  final String languageCode;

  GetLocalizedFavourites({
    required this.languageCode,
  });
}

class SaveFavourite extends FavouritesEvent {
  final String languageCode;
  final String songId;

  SaveFavourite({
    required this.languageCode,
    required this.songId,
  });
}

class RemoveFavourite extends FavouritesEvent {
  final String songId;

  RemoveFavourite({
    required this.songId,
  });
}
