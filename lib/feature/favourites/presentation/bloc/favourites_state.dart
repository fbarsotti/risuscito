part of 'favourites_bloc.dart';

@immutable
abstract class FavouritesState {}

class FavouritesInitial extends FavouritesState {}

class FavouritesLoading extends FavouritesState {}

class FavouritesLoaded extends FavouritesState {
  final List<SongDomainModel> songs;

  FavouritesLoaded({
    required this.songs,
  });
}

class FavouritesFailure extends FavouritesState {
  final Failure failure;

  FavouritesFailure({
    required this.failure,
  });
}
