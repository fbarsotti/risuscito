import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/feature/index/alphabetical/domain/repository/alphabetical_index_repository.dart';
import '../../domain/model/song_domain_model.dart';

part 'alphabetical_index_event.dart';
part 'alphabetical_index_state.dart';

class AlphabeticalIndexBloc
    extends Bloc<AlphabeticalIndexEvent, AlphabeticalIndexState> {
  final AlphabeticalIndexRepository alphabeticalIndexRepository;

  AlphabeticalIndexBloc({
    required this.alphabeticalIndexRepository,
  }) : super(AlphabeticalIndexInitial()) {
    on<GetAlphabeticalIndexedSongs>((event, emit) async {
      emit(AlphabeticalIndexLoading());
      final result =
          await alphabeticalIndexRepository.getAlphabeticalIndexedSongs(
        event.languageCode,
      );

      result.fold(
        (failure) => emit(AlphabeticalIndexFailure(failure: failure)),
        (songs) => emit(AlphabeticalIndexLoaded(songs: songs)),
      );
    });
  }
}
