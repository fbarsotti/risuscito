import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/feature/history/domain/repository/history_repository.dart';
import 'package:risuscito/feature/songs/domain/model/song_domain_model.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  final HistoryRepository historyRepository;

  HistoryBloc({
    required this.historyRepository,
  }) : super(HistoryInitial()) {
    on<GetLocalizedHistory>((event, emit) async {
      emit(HistoryLoading());
      final result = await historyRepository.getHistory(event.languageCode);
      result.fold(
        (failure) => emit(
          HistoryFailure(failure: failure),
        ),
        (songs) => emit(
          HistoryLoaded(songs: songs),
        ),
      );
    });
    on<SaveInHistory>((event, emit) async {
      final result = await historyRepository.saveInHistory(
        event.languageCode,
        event.songId,
      );

      result.fold(
        (failure) => emit(
          HistoryFailure(failure: failure),
        ),
        (songs) => emit(
          HistoryLoaded(songs: songs),
        ),
      );
    });
    on<RemoveFromHistory>((event, emit) async {
      if (event.reload) emit(HistoryLoading());
      final result = await historyRepository.removeFromHistory(
        event.songId,
      );
      if (event.reload) {
        final result = await historyRepository.getHistory(event.languageCode!);
        result.fold(
          (failure) => null,
          (songs) => emit(
            HistoryLoaded(songs: songs),
          ),
        );
      }
      result.fold(
        (failure) => emit(HistoryFailure(failure: failure)),
        (success) {},
      );
    });
    on<DeleteHistory>((event, emit) async {
      emit(HistoryLoading());
      final result = await historyRepository.deleteHistory();
      result.fold(
        (failure) => emit(HistoryFailure(failure: failure)),
        (success) => emit(HistoryLoaded(songs: [])),
      );
    });
  }
}
