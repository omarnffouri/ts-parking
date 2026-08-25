import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ts_parking/app/core/errors/failures.dart';
import 'package:ts_parking/app/data/models/paginated_response.dart';
import 'package:ts_parking/app/domain/entities/create_subscription_response_entity.dart';
import 'package:ts_parking/app/domain/entities/invoice_entity.dart';
import 'package:ts_parking/app/domain/entities/subscription_entity.dart';
import 'package:ts_parking/app/domain/params/create_subscription_params.dart';
import 'package:ts_parking/app/domain/params/pay_invoice_params.dart';
import 'package:ts_parking/app/domain/usecases/create_subscriptions_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_invoice_by_id_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_invoices_usecase.dart';
import 'package:ts_parking/app/domain/usecases/get_subscriptions_usecase.dart';
import 'package:ts_parking/app/domain/usecases/pay_invoice_usecase.dart';

import '../../../helpers/mocks.mocks.dart';

void main() {
  // ---------------------------------------------------------------------------
  // GetSubscriptionsUsecase
  // ---------------------------------------------------------------------------
  group('GetSubscriptionsUsecase', () {
    late MockSubscriptionRepository mockRepo;
    late GetSubscriptionsUsecase usecase;

    setUp(() {
      mockRepo = MockSubscriptionRepository();
      usecase = GetSubscriptionsUsecase(mockRepo);
    });

    test(
      'delegates to repository.getSubscriptions and returns result',
      () async {
        final expected = PaginatedResponse<SubscriptionEntity>(
          data: const [
            SubscriptionEntity(
              id: 1,
              subscriptionRef: 'SUB-001',
              slotId: 10,
              planId: 5,
              vehicleId: 3,
              billingCycle: 'monthly',
              totalAmount: 500.0,
              status: 'active',
              autoRenew: true,
            ),
          ],
          meta: const PaginationMeta(
            total: 1,
            page: 1,
            limit: 6,
            totalPages: 1,
            hasMore: false,
          ),
        );
        when(
          mockRepo.getSubscriptions(page: 1, limit: 6),
        ).thenAnswer((_) async => Right(expected));

        final result = await usecase.execute(page: 1, limit: 6);

        expect(result, Right(expected));
        verify(mockRepo.getSubscriptions(page: 1, limit: 6)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test('returns failure from repository', () async {
      const failure = ServerFailure('subscriptions fetch failed');
      when(
        mockRepo.getSubscriptions(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        ),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute();

      expect(result, const Left(failure));
      verify(
        mockRepo.getSubscriptions(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
        ),
      ).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // CreateSubscriptionsUsecase
  // ---------------------------------------------------------------------------
  group('CreateSubscriptionsUsecase', () {
    late MockSubscriptionRepository mockRepo;
    late CreateSubscriptionsUsecase usecase;

    setUp(() {
      mockRepo = MockSubscriptionRepository();
      usecase = CreateSubscriptionsUsecase(mockRepo);
    });

    test(
      'delegates to repository.createSubscriptions and returns result',
      () async {
        final expected = CreateSubscriptionResponseEntity(
          subscriptions: const [
            SubscriptionEntity(
              id: 1,
              subscriptionRef: 'SUB-NEW',
              slotId: 10,
              planId: 5,
              vehicleId: 3,
              billingCycle: 'monthly',
              totalAmount: 500.0,
              status: 'pending',
              autoRenew: true,
            ),
          ],
          invoice: InvoiceEntity(
            id: 100,
            invoiceNumber: 'INV-100',
            invoiceType: 'subscription',
            status: 'pending',
            subtotal: 500.0,
            discountAmount: 0,
            tax: 75.0,
            total: 575.0,
            issuedAt: DateTime(2024, 6, 1),
          ),
        );
        const params = CreateSubscriptionParams(
          slots: [
            SlotSubscriptionParam(
              slotId: 10,
              autoRenew: true,
              startDate: '2024-06-01',
              duration: 1,
              vehicleId: 3,
              planId: 5,
            ),
          ],
        );
        when(
          mockRepo.createSubscriptions(params),
        ).thenAnswer((_) async => Right(expected));

        final result = await usecase.execute(params);

        expect(result, Right(expected));
        verify(mockRepo.createSubscriptions(params)).called(1);
        verifyNoMoreInteractions(mockRepo);
      },
    );

    test('returns failure from repository', () async {
      const failure = ServerFailure('create subscription failed');
      const params = CreateSubscriptionParams(slots: []);
      when(
        mockRepo.createSubscriptions(params),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute(params);

      expect(result, const Left(failure));
      verify(mockRepo.createSubscriptions(params)).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // PayInvoiceUsecase
  // ---------------------------------------------------------------------------
  group('PayInvoiceUsecase', () {
    late MockSubscriptionRepository mockRepo;
    late PayInvoiceUsecase usecase;

    setUp(() {
      mockRepo = MockSubscriptionRepository();
      usecase = PayInvoiceUsecase(mockRepo);
    });

    test('delegates to repository.payInvoice and returns result', () async {
      final expected = InvoiceEntity(
        id: 100,
        invoiceNumber: 'INV-100',
        invoiceType: 'subscription',
        status: 'paid',
        subtotal: 500.0,
        discountAmount: 0,
        tax: 75.0,
        total: 575.0,
        issuedAt: DateTime(2024, 6, 1),
        paidAt: DateTime(2024, 6, 2),
      );
      const params = PayInvoiceParams(
        invoiceId: 100,
        paymentMethod: PayInvoiceParams.methodCard,
        paymentToken: 'tok_pay_123',
      );
      when(
        mockRepo.payInvoice(params),
      ).thenAnswer((_) async => Right(expected));

      final result = await usecase.execute(params);

      expect(result, Right(expected));
      verify(mockRepo.payInvoice(params)).called(1);
      verifyNoMoreInteractions(mockRepo);
    });

    test('returns failure from repository', () async {
      const failure = ServerFailure('payment failed');
      const params = PayInvoiceParams(
        invoiceId: 100,
        paymentMethod: PayInvoiceParams.methodCard,
        paymentToken: 'tok_bad',
      );
      when(
        mockRepo.payInvoice(params),
      ).thenAnswer((_) async => const Left(failure));

      final result = await usecase.execute(params);

      expect(result, const Left(failure));
      verify(mockRepo.payInvoice(params)).called(1);
    });
  });

  // ---------------------------------------------------------------------------
  // GetInvoicesUsecase
  // ---------------------------------------------------------------------------
  group('GetInvoicesUsecase', () {
    late MockSubscriptionRepository mockRepo;
    late GetInvoicesUsecase usecase;

    setUp(() {
      mockRepo = MockSubscriptionRepository();
      usecase = GetInvoicesUsecase(mockRepo);
    });

    test('delegates to repository and returns result', () async {
      when(mockRepo.getInvoices(page: 1, limit: 10)).thenAnswer(
        (_) async => const Right(
          PaginatedResponse(data: [], meta: PaginationMeta.empty),
        ),
      );

      final result = await usecase.execute();
      expect(result.isRight(), isTrue);
      verify(mockRepo.getInvoices(page: 1, limit: 10)).called(1);
    });

    test('returns failure from repository', () async {
      when(
        mockRepo.getInvoices(page: 1, limit: 10),
      ).thenAnswer((_) async => const Left(ServerFailure('fail')));

      final result = await usecase.execute();
      expect(result, const Left(ServerFailure('fail')));
    });
  });

  // ---------------------------------------------------------------------------
  // GetInvoiceByIdUsecase
  // ---------------------------------------------------------------------------
  group('GetInvoiceByIdUsecase', () {
    late MockSubscriptionRepository mockRepo;
    late GetInvoiceByIdUsecase usecase;

    setUp(() {
      mockRepo = MockSubscriptionRepository();
      usecase = GetInvoiceByIdUsecase(mockRepo);
    });

    test('delegates to repository and returns invoice', () async {
      final invoice = InvoiceEntity(
        id: 57,
        invoiceNumber: 'INV-001',
        invoiceType: 'subscription',
        status: 'paid',
        subtotal: 300,
        discountAmount: 50,
        tax: 0,
        total: 250,
        issuedAt: DateTime(2026, 4, 3),
      );
      when(mockRepo.getInvoiceById(57)).thenAnswer((_) async => Right(invoice));

      final result = await usecase.execute(57);
      result.fold((_) => fail('expected Right'), (data) => expect(data.id, 57));
      verify(mockRepo.getInvoiceById(57)).called(1);
    });

    test('returns failure from repository', () async {
      when(
        mockRepo.getInvoiceById(99),
      ).thenAnswer((_) async => const Left(ServerFailure('not found')));

      final result = await usecase.execute(99);
      expect(result, const Left(ServerFailure('not found')));
    });
  });
}
