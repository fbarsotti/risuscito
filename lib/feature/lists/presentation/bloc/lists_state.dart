part of 'lists_bloc.dart';

@immutable
abstract class ListsState {}

class ListsInitial extends ListsState {}

class ListsLoading extends ListsState {}

class ListsLoaded extends ListsState {
  final List<ListDomainModel> lists;

  ListsLoaded({
    required this.lists,
  });
}

class ListsInfoLoaded extends ListsState {
  final ListDomainModel list;

  ListsInfoLoaded({
    required this.list,
  });
}

class ListsFailure extends ListsState {
  final Failure failure;

  ListsFailure({
    required this.failure,
  });
}

class ListsCreated extends ListsState {
  final ListDomainModel list;

  ListsCreated({
    required this.list,
  });
}
