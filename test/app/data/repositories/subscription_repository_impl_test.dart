import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/errors/exceptions.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/datasources/subscription_remote_datasource.dart';
import 'package:ts_parking/app/data/models/create_subscription_response_model.dart';
import 'package:ts_parking/app/data/models/invoice_model.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';
import 'package:ts_parking/app/data/models/subscription_model.dart';
import 'package:ts_parking/app/data/repositories/subscription_repository_impl.dart';
import 'package:ts_parking/app/domain/params/create_subscription_params.dart';
import 'package:ts_parking/app/domain/params/pay_invoice_params.dart';

// ---------------------------------------------------------------------------
// Fake data source
// ---------------------------------------------------------------------------

class FakeSubscriptionRemoteDataSource implements SubscriptionRemoteDataSource {
  PaginatedResponse<SubscriptionModel>? getSubscriptionsResult;
  Exception? getSubscriptionsException;

  CreateSubscriptionResponseModel? createSubscriptionsResult;
  Exception? createSubscriptionsException;

  InvoiceModel? payInvoiceResult;
  Exception? payInvoiceException;

  PaginatedResponse<InvoiceModel>? getInvoicesResult;
  Exception? getInvoicesException;

  InvoiceModel? getInvoiceByIdResult;
  Exception? getInvoiceByIdException;

  Exception? deleteSubscriptionException;

  @override
  Future<PaginatedResponse<InvoiceModel>> getInvoices({
    int page = 1,
    int limit = 10,
  }) async {
    if (getInvoicesException != null) throw getInvoicesException!;
    return getInvoicesResult!;
  }

  @override
  Future<InvoiceModel> getInvoiceById(int id) async {
    if (getInvoiceByIdException != null) throw getInvoiceByIdException!;
    return getInvoiceByIdResult!;
  }

  @override
  Future<PaginatedResponse<SubscriptionModel>> getSubscriptions({
    int page = 1,
    int limit = 6,
  }) async {
    if (getSubscriptionsException != null) throw getSubscriptionsException!;
    return getSubscriptionsResult!;
  }

  @override
  Future<CreateSubscriptionResponseModel> createSubscriptions(
    CreateSubscriptionParams params,
  ) async {
    if (createSubscriptionsException != null) {
      throw createSubscriptionsException!;
    }
    return createSubscriptionsResult!;
  }

  @override
  Future<InvoiceModel> payInvoice(PayInvoiceParams params) async {
    if (payInvoiceException != null) throw payInvoiceException!;
    return payInvoiceResult!;
  }

  @override
  Future<void> deleteSubscription(int id) async {
    if (deleteSubscriptionException != null) throw deleteSubscriptionException!;
  }
}

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

SubscriptionModel _makeSubscription({int id = 1}) {
  return SubscriptionModel(
    id: id,
    subscriptionRef: 'SUB-$id',
    slotId: 10,
    planId: 1,
    vehicleId: 5,
    billingCycle: 'monthly',
    totalAmount: 100.0,
    status: 'active',
    autoRenew: true,
  );
}

PaginatedResponse<SubscriptionModel> _makePaginatedSubscriptions() {
  return PaginatedResponse<SubscriptionModel>(
    data: [_makeSubscription()],
    meta: const PaginationMeta(
      total: 1,
      page: 1,
      limit: 6,
      totalPages: 1,
      hasMore: false,
    ),
  );
}

CreateSubscriptionResponseModel _makeCreateResponse() {
  return CreateSubscriptionResponseModel(
    subscriptions: [_makeSubscription()],
    invoice: InvoiceModel(
      id: 1,
      invoiceNumber: 'INV-001',
      invoiceType: 'subscription',
      status: 'pending',
      subtotal: 100.0,
      discountAmount: 0.0,
      tax: 10.0,
      total: 110.0,
      issuedAt: DateTime(2026, 1, 1),
    ),
  );
}

InvoiceModel _makeInvoice() {
  return InvoiceModel(
    id: 1,
    invoiceNumber: 'INV-001',
    invoiceType: 'subscription',
    status: 'paid',
    subtotal: 100.0,
    discountAmount: 0.0,
    tax: 10.0,
    total: 110.0,
    issuedAt: DateTime(2026, 1, 1),
    paidAt: DateTime(2026, 1, 2),
  );
}

const _createParams = CreateSubscriptionParams(
  slots: [
    SlotSubscriptionParam(
      slotId: 10,
      autoRenew: true,
      startDate: '2026-01-01',
      duration: 1,
      vehicleId: 5,
      planId: 1,
    ),
  ],
);

const _payParams = PayInvoiceParams(
  invoiceId: 1,
  paymentMethod: PayInvoiceParams.methodCard,
  paymentToken: 'tok_test',
);

// ---------------------------------------------------------------------------
// Tests
// ---------------------------------------------------------------------------

void main() {
  late FakeSubscriptionRemoteDataSource fakeDataSource;
  late SubscriptionRepositoryImpl repository;

  setUp(() {
    fakeDataSource = FakeSubscriptionRemoteDataSource();
    repository = SubscriptionRepositoryImpl(dataSource: fakeDataSource);
  });

  group('getSubscriptions', () {
    test('returns paginated subscriptions on success', () async {
      final expected = _makePaginatedSubscriptions();
      fakeDataSource.getSubscriptionsResult = expected;

      final result = await repository.getSubscriptions();

      expect(result, equals(Right(expected)));
    });

    test('returns AuthFailure on AuthException', () async {
      fakeDataSource.getSubscriptionsException = const AuthException(
        'unauthorized',
      );

      final result = await repository.getSubscriptions();

      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns ValidationFailure on ValidationException', () async {
      fakeDataSource.getSubscriptionsException = const ValidationException(
        'invalid',
      );

      final result = await repository.getSubscriptions();

      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns ServerFailure on ServerException', () async {
      fakeDataSource.getSubscriptionsException = const ServerException('error');

      final result = await repository.getSubscriptions();

      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns NetworkFailure on NetworkException', () async {
      fakeDataSource.getSubscriptionsException = const NetworkException(
        'offline',
      );

      final result = await repository.getSubscriptions();

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns UnexpectedFailure on unknown exception', () async {
      fakeDataSource.getSubscriptionsException = Exception('boom');

      final result = await repository.getSubscriptions();

      result.fold(
        (f) => expect(f, isA<UnexpectedFailure>()),
        (_) => fail('expected Left'),
      );
    });
  });

  group('createSubscriptions', () {
    test('returns response on success', () async {
      final expected = _makeCreateResponse();
      fakeDataSource.createSubscriptionsResult = expected;

      final result = await repository.createSubscriptions(_createParams);

      expect(result, equals(Right(expected)));
    });

    test('returns AuthFailure on AuthException', () async {
      fakeDataSource.createSubscriptionsException = const AuthException(
        'auth error',
      );

      final result = await repository.createSubscriptions(_createParams);

      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns ValidationFailure on ValidationException', () async {
      fakeDataSource.createSubscriptionsException = const ValidationException(
        'bad data',
      );

      final result = await repository.createSubscriptions(_createParams);

      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns ServerFailure on ServerException', () async {
      fakeDataSource.createSubscriptionsException = const ServerException(
        'server error',
      );

      final result = await repository.createSubscriptions(_createParams);

      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns NetworkFailure on NetworkException', () async {
      fakeDataSource.createSubscriptionsException = const NetworkException(
        'timeout',
      );

      final result = await repository.createSubscriptions(_createParams);

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns UnexpectedFailure on unknown exception', () async {
      fakeDataSource.createSubscriptionsException = Exception('unexpected');

      final result = await repository.createSubscriptions(_createParams);

      result.fold(
        (f) => expect(f, isA<UnexpectedFailure>()),
        (_) => fail('expected Left'),
      );
    });
  });

  group('payInvoice', () {
    test('returns invoice on success', () async {
      final expected = _makeInvoice();
      fakeDataSource.payInvoiceResult = expected;

      final result = await repository.payInvoice(_payParams);

      expect(result, equals(Right(expected)));
    });

    test('returns AuthFailure on AuthException', () async {
      fakeDataSource.payInvoiceException = const AuthException('not authed');

      final result = await repository.payInvoice(_payParams);

      result.fold(
        (f) => expect(f, isA<AuthFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns ValidationFailure on ValidationException', () async {
      fakeDataSource.payInvoiceException = const ValidationException(
        'invalid token',
      );

      final result = await repository.payInvoice(_payParams);

      result.fold(
        (f) => expect(f, isA<ValidationFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns ServerFailure on ServerException', () async {
      fakeDataSource.payInvoiceException = const ServerException(
        'payment failed',
      );

      final result = await repository.payInvoice(_payParams);

      result.fold(
        (f) => expect(f, isA<ServerFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns NetworkFailure on NetworkException', () async {
      fakeDataSource.payInvoiceException = const NetworkException(
        'no connection',
      );

      final result = await repository.payInvoice(_payParams);

      result.fold(
        (f) => expect(f, isA<NetworkFailure>()),
        (_) => fail('expected Left'),
      );
    });

    test('returns UnexpectedFailure on unknown exception', () async {
      fakeDataSource.payInvoiceException = Exception('unexpected');

      final result = await repository.payInvoice(_payParams);

      result.fold(
        (f) => expect(f, isA<UnexpectedFailure>()),
        (_) => fail('expected Left'),
      );
    });
  });
}
