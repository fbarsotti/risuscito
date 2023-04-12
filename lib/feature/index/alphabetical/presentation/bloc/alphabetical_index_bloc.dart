import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import '../../domain/model/song_domain_model.dart';

part 'alphabetical_index_event.dart';
part 'alphabetical_index_state.dart';

class AlphabeticalIndexBloc
    extends Bloc<AlphabeticalIndexEvent, AlphabeticalIndexState> {
  AlphabeticalIndexBloc() : super(AlphabeticalIndexInitial()) {
    on<GetAlphabeticalIndexedSongs>((event, emit) {
      emit(AlphabeticalIndexLoading());
      // TODO
    });
  }
}
