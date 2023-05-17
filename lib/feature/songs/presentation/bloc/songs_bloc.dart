import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import '../../domain/model/paged_songs_domain_model.dart';
import '../../domain/repository/songs_repository.dart';

part 'songs_event.dart';
part 'songs_state.dart';

class SongsBloc extends Bloc<SongsEvent, SongsState> {
  final SongsRepository songsRepository;

  SongsBloc({
    required this.songsRepository,
  }) : super(SongsInitial()) {
    on<GetLocalizedSongs>((event, emit) async {
      emit(SongsLoading());
      final result = await songsRepository.getLocalizedSongs(
        event.languageCode,
      );

      result.fold(
        (failure) => emit(SongsFailure(failure: failure)),
        (songs) => emit(SongsLoaded(songs: songs)),
      );
    });
  }
}
