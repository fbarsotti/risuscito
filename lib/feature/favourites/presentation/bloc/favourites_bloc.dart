import 'package:bloc/bloc.dart';
import 'package:flutter/cupertino.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/feature/favourites/domain/repository/favourites_repository.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

part 'favourites_event.dart';
part 'favourites_state.dart';

class FavouritesBloc extends Bloc<FavouritesEvent, FavouritesState> {
  final FavouritesRepository favouritesRepository;

  FavouritesBloc({
    required this.favouritesRepository,
  }) : super(FavouritesInitial()) {
    on<GetLocalizedFavourites>((event, emit) async {
      emit(FavouritesLoading());
      final result =
          await favouritesRepository.getFavourites(event.languageCode);
      result.fold(
        (failure) => emit(FavouritesFailure(failure: failure)),
        (favSongs) => emit(FavouritesLoaded(songs: favSongs)),
      );
    });
    on<SaveFavourite>((event, emit) async {
      emit(FavouritesLoading());
      final result = await favouritesRepository.saveFavourite(
        event.languageCode,
        event.songId,
      );

      result.fold(
        (failure) => emit(FavouritesFailure(failure: failure)),
        (favSongs) => emit(FavouritesLoaded(songs: favSongs)),
      );
    });
  }
}
