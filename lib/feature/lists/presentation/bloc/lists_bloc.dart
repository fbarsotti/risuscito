import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/feature/lists/domain/model/list_domain_model.dart';
import 'package:risuscito/feature/lists/domain/repository/lists_repository.dart';

part 'lists_event.dart';
part 'lists_state.dart';

class ListsBloc extends Bloc<ListsEvent, ListsState> {
  final ListsRepository listsRepository;

  ListsBloc({
    required this.listsRepository,
  }) : super(ListsInitial()) {
    on<ListsAddSongToListEvent>(
      (event, emit) async {
        emit(ListsLoading());
        final result = await listsRepository.addSongToList(
          event.listId,
          event.songId,
          event.languageCode,
        );
        result.fold(
          (failure) => emit(ListsFailure(failure: failure)),
          (list) {
            emit(
              ListsInfoLoaded(
                list: list.where((list) => list.id == event.listId).first,
              ),
            );
            emit(ListsLoaded(lists: list));
          },
        );
      },
    );
    on<ListsGetAllListsEvent>(
      (event, emit) async {
        emit(ListsLoading());
        final result = await listsRepository.getAllLists(event.languageCode);
        result.fold(
          (failure) => emit(ListsFailure(failure: failure)),
          (lists) => emit(ListsLoaded(lists: lists)),
        );
      },
    );
    on<ListsCreateListEvent>(
      (event, emit) async {
        emit(ListsLoading());
        final result = await listsRepository.createList(
          event.name,
          event.description,
          event.languageCode,
        );
        result.fold(
          (failure) => emit(ListsFailure(failure: failure)),
          (lists) => emit(ListsLoaded(lists: lists)),
        );
      },
    );
  }
}
