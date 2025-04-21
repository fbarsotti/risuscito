import 'package:dartz/dartz.dart';
import 'package:risuscito/core/infrastructure/error/types/failures.dart';
import 'package:risuscito/feature/lists/domain/model/list_domain_model.dart';

mixin ListsRepository {
  Future<Either<Failure, List<ListDomainModel>>> getAllLists(
    String languageCode,
  );
}
