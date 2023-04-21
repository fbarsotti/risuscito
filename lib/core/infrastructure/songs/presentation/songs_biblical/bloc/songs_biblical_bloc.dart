import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/core/infrastructure/songs/domain/model/song_domain_model.dart';
import 'package:risuscito/core/infrastructure/songs/domain/repository/songs_repository.dart';

part 'songs_biblical_event.dart';
part 'songs_biblical_state.dart';

class SongsBiblicalBloc extends Bloc<SongsBiblicalEvent, SongsBiblicalState> {
  final SongsRepository songsRepository;

  SongsBiblicalBloc({
    required this.songsRepository,
  }) : super(SongsBiblicalInitial()) {
    on<GetLocalizedSongsBiblical>((event, emit) async {
      emit(SongsBiblicalLoading());
      final result = await songsRepository.getLocalizedSongsBiblical(
        event.languageCode,
      );

      result.fold(
        (failure) => emit(SongsBiblicalFailure(failure: failure)),
        (songs) => emit(SongsBiblicalLoaded(songs: songs)),
      );
    });
  }
}
