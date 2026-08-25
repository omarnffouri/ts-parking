import 'package:dartz/dartz.dart';

import '../../core/errors/exceptions.dart';
import '../../core/errors/failures.dart';
import '../../domain/entities/notification_entity.dart';
import '../../domain/params/notification_params.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';
import '../models/paginated_response.dart';

class NotificationRepositoryImpl implements INotificationRepository {
  final NotificationRemoteDataSource dataSource;

  NotificationRepositoryImpl({required this.dataSource});

  Future<Either<Failure, T>> _safe<T>(Future<T> Function() action) async {
    try {
      final result = await action();
      return Right(result);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } on ValidationException catch (e) {
      return Left(ValidationFailure(e.message));
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(e.message));
    } catch (_) {
      return const Left(UnexpectedFailure('An unexpected error occurred'));
    }
  }

  @override
  Future<Either<Failure, PaginatedResponse<NotificationEntity>>>
  getNotifications(NotificationFilterParams params) =>
      _safe(() => dataSource.getNotifications(params));

  @override
  Future<Either<Failure, void>> markAsRead(int id) =>
      _safe(() => dataSource.markAsRead(id));

  @override
  Future<Either<Failure, void>> markAllAsRead() =>
      _safe(() => dataSource.markAllAsRead());

  @override
  Future<Either<Failure, int>> getUnreadCount() =>
      _safe(() => dataSource.getUnreadCount());
}
