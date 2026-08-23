import 'dart:convert';
import 'dart:io';

import 'package:backend/repositories/bottle_return_dispenser_handler.dart';
import 'package:backend/repositories/bottle_return_product_handler.dart';
import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:backend/repositories/bottle_return_session_handler.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:mocktail/mocktail.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

import '../routes/v1/bottle-returns/config.dart' as config_route;
import '../routes/v1/bottle-returns/coupons/redeem.dart' as redeem_route;
import '../routes/v1/bottle-returns/coupons/validate.dart' as coupon_route;
import '../routes/v1/bottle-returns/credits/apply.dart' as apply_route;
import '../routes/v1/bottle-returns/credits/balance.dart' as balance_route;
import '../routes/v1/bottle-returns/iot/dispense-stickers.dart'
    as dispense_route;
import '../routes/v1/bottle-returns/iot/scan-return.dart' as scan_route;
import '../routes/v1/bottle-returns/products.dart' as products_route;

class _MockRequestContext extends Mock implements RequestContext {}

class _MockRequest extends Mock implements Request {}

class _MockBottleReturnRepository extends Mock
    implements BottleReturnRepository {}

class _MockBottleReturnSessionHandler extends Mock
    implements BottleReturnSessionHandler {}

class _MockBottleReturnDispenserHandler extends Mock
    implements BottleReturnDispenserHandler {}

class _MockBottleReturnProductHandler extends Mock
    implements BottleReturnProductHandler {}

void main() {
  late _MockRequestContext context;
  late _MockRequest request;
  late _MockBottleReturnRepository repo;
  late _MockBottleReturnSessionHandler sessionHandler;
  late _MockBottleReturnDispenserHandler dispenserHandler;
  late _MockBottleReturnProductHandler productHandler;

  setUp(() {
    context = _MockRequestContext();
    request = _MockRequest();
    repo = _MockBottleReturnRepository();
    sessionHandler = _MockBottleReturnSessionHandler();
    dispenserHandler = _MockBottleReturnDispenserHandler();
    productHandler = _MockBottleReturnProductHandler();

    when(() => context.request).thenReturn(request);
    when(() => context.read<BottleReturnRepository>()).thenReturn(repo);
    when(() => context.read<BottleReturnSessionHandler>())
        .thenReturn(sessionHandler);
    when(() => context.read<BottleReturnDispenserHandler>())
        .thenReturn(dispenserHandler);
    when(() => context.read<BottleReturnProductHandler>())
        .thenReturn(productHandler);
  });

  group('Bottle Return Routes Tests', () {
    test('GET /v1/bottle-returns/config returns store config', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/bottle-returns/config?storeId=s-1'),
      );
      final config = BottleReturnConfig(
        storeId: 's-1',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      when(() => repo.getConfig('s-1')).thenAnswer((_) async => config);

      final response = await config_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
      final data = body['data'] as Map<String, dynamic>;
      final cfg = data['config'] as Map<String, dynamic>;
      expect(cfg['rewardAmountInRupees'], equals(10));
    });

    test('POST /v1/bottle-returns/config saves store config', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer(
        (_) async => {
          'storeId': 's-1',
          'isEnabled': true,
          'rewardAmountInRupees': 15,
        },
      );
      final config = BottleReturnConfig(
        storeId: 's-1',
        rewardAmountInRupees: 15,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      when(
        () => repo.saveConfig(
          storeId: 's-1',
          rewardAmountInRupees: 15,
        ),
      ).thenAnswer((_) async => config);

      final response = await config_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
      final data = body['data'] as Map<String, dynamic>;
      expect(
        (data['config'] as Map<String, dynamic>)['rewardAmountInRupees'],
        equals(15),
      );
    });

    test(
      'GET /v1/bottle-returns/credits/balance returns phone balance',
      () async {
        when(() => request.method).thenReturn(HttpMethod.get);
        when(() => request.uri).thenReturn(
          Uri.parse(
            'http://localhost/v1/bottle-returns/credits/balance?phone=9876543210&merchantId=m-1',
          ),
        );
        when(
          () => repo.getPhoneCreditBalance(
            merchantId: 'm-1',
            customerPhone: '9876543210',
          ),
        ).thenAnswer((_) async => 30);

        final response = await balance_route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.ok));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        final data = body['data'] as Map<String, dynamic>;
        expect(data['balance'], equals(30));
      },
    );

    test(
      'POST /v1/bottle-returns/credits/apply executes credit deduction',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => request.json()).thenAnswer(
          (_) async => {
            'merchantId': 'm-1',
            'customerPhone': '9876543210',
            'amount': 20,
            'storeId': 's-1',
          },
        );
        when(
          () => repo.applyCreditDeduction(
            merchantId: 'm-1',
            customerPhone: '9876543210',
            amount: 20,
            storeId: 's-1',
          ),
        ).thenAnswer((_) async => true);

        final response = await apply_route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.ok));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
      },
    );

    test('POST /v1/bottle-returns/coupons/validate validates physical coupon voucher without redeeming', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer(
        (_) async => {
          'merchantId': 'm-1',
          'code': 'BTL123456',
          'storeId': 's-1',
        },
      );
      final coupon = BottlePhysicalCoupon(
        id: 'c-1',
        code: 'BTL123456',
        merchantId: 'm-1',
        storeId: 's-1',
        amount: 20,
        createdAt: DateTime.now(),
      );
      when(
        () => repo.validatePhysicalCoupon(
          merchantId: 'm-1',
          code: 'BTL123456',
          storeId: 's-1',
        ),
      ).thenAnswer((_) async => coupon);

      final response = await coupon_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
      final data = body['data'] as Map<String, dynamic>;
      final cpn = data['coupon'] as Map<String, dynamic>;
      expect(cpn['code'], equals('BTL123456'));
    });

    test('POST /v1/bottle-returns/coupons/redeem marks physical coupon voucher as redeemed', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer(
        (_) async => {
          'merchantId': 'm-1',
          'code': 'BTL123456',
          'storeId': 's-1',
          'orderId': 'ord-123',
        },
      );
      when(
        () => repo.redeemPhysicalCoupon(
          merchantId: 'm-1',
          code: 'BTL123456',
          storeId: 's-1',
          orderId: 'ord-123',
        ),
      ).thenAnswer((_) async => true);

      final response = await redeem_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
    });

    test(
      'POST /v1/bottle-returns/iot/scan-return returns session result',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => request.json()).thenAnswer(
          (_) async => {
            'tokenStrings': ['TOK1', 'TOK2'],
            'storeId': 's-1',
            'merchantId': 'm-1',
          },
        );
        const sessionResult = BottleReturnSessionResult(
          totalBottlesReturned: 2,
          totalRewardAmount: 20,
          rewardMode: BottleRewardMode.digital,
          customerPhone: '9876543210',
          message: 'Success',
        );
        when(
          () => sessionHandler.processReturnBatch(
            tokenStrings: ['TOK1', 'TOK2'],
            storeId: 's-1',
            merchantId: 'm-1',
          ),
        ).thenAnswer((_) async => sessionResult);

        final response = await scan_route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.ok));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        final data = body['data'] as Map<String, dynamic>;
        final res = data['result'] as Map<String, dynamic>;
        expect(res['totalBottlesReturned'], equals(2));
      },
    );

    test(
      'POST /v1/bottle-returns/iot/dispense-stickers returns order and bottle tokens',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => request.json()).thenAnswer(
          (_) async => {
            'orderReference': 'ORD-999',
          },
        );

        final token = BottleQrToken(
          id: 'tok-1',
          token: 'BTL_TOK_123',
          orderId: 'ord-1',
          storeId: 's-1',
          merchantId: 'm-1',
          productId: 'p-1',
          createdAt: DateTime.now(),
        );

        final order = Order(
          id: 'ord-1',
          merchantId: 'm-1',
          storeId: 's-1',
          orderReference: 'ORD-999',
          billNo: 1,
          source: OrderSource.web,
          type: OrderType.takeaway,
          status: OrderStatus.completed,
          paymentStatus: PaymentStatus.completed,
          paymentMethod: PaymentMethod.upi,
          subtotal: 100,
          taxTotal: 0,
          grandTotal: 100,
          items: const [],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        when(() => dispenserHandler.getDispenserOrderPayload('ORD-999'))
            .thenAnswer(
              (_) async => DispenserOrderSuccess(
                order: order,
                bottleTokens: [token],
              ),
            );

        final response = await dispense_route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.ok));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isTrue);
        final data = body['data'] as Map<String, dynamic>;
        expect(data['orderReference'], equals('ORD-999'));
        expect(data['order'], isNotNull);
        final tokens = data['bottleTokens'] as List<dynamic>;
        expect(tokens.length, equals(1));
        expect(
          (tokens.first as Map<String, dynamic>)['token'],
          equals('BTL_TOK_123'),
        );
      },
    );

    test(
      'POST /v1/bottle-returns/iot/dispense-stickers rejects already completed orders',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => request.json()).thenAnswer(
          (_) async => {
            'orderReference': 'ORD-DONE',
          },
        );

        when(() => dispenserHandler.getDispenserOrderPayload('ORD-DONE'))
            .thenAnswer((_) async => const DispenserOrderAlreadyCompleted());

        final response = await dispense_route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.badRequest));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isFalse);
        expect(body['message'], contains('already been completed'));
      },
    );

    test(
      'POST /v1/bottle-returns/iot/dispense-stickers returns 404 if order not found',
      () async {
        when(() => request.method).thenReturn(HttpMethod.post);
        when(() => request.json()).thenAnswer(
          (_) async => {
            'orderReference': 'ORD-NONEXISTENT',
          },
        );

        when(() => dispenserHandler.getDispenserOrderPayload('ORD-NONEXISTENT'))
            .thenAnswer((_) async => const DispenserOrderNotFound());

        final response = await dispense_route.onRequest(context);
        expect(response.statusCode, equals(HttpStatus.notFound));
        final body = jsonDecode(await response.body()) as Map<String, dynamic>;
        expect(body['success'], isFalse);
      },
    );

    test('GET /v1/bottle-returns/products returns products list', () async {
      when(() => request.method).thenReturn(HttpMethod.get);
      when(() => request.uri).thenReturn(
        Uri.parse('http://localhost/v1/bottle-returns/products?storeId=s-1'),
      );
      when(() => productHandler.getProductsForStore('s-1')).thenAnswer(
        (_) async => [
          const ReturnableProductItem(
            productId: 'p-1',
            name: 'Kingfisher',
            sellingPrice: 180,
            isReturnable: true,
          ),
        ],
      );

      final response = await products_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
      final data = body['data'] as List<dynamic>;
      expect(data.length, equals(1));
    });

    test('POST /v1/bottle-returns/products updates product status', () async {
      when(() => request.method).thenReturn(HttpMethod.post);
      when(() => request.json()).thenAnswer(
        (_) async => {
          'storeId': 's-1',
          'productId': 'p-1',
          'isReturnable': true,
        },
      );
      when(
        () => productHandler.setProductReturnable(
          storeId: 's-1',
          productId: 'p-1',
          isReturnable: true,
        ),
      ).thenAnswer((_) async {});

      final response = await products_route.onRequest(context);
      expect(response.statusCode, equals(HttpStatus.ok));
      final body = jsonDecode(await response.body()) as Map<String, dynamic>;
      expect(body['success'], isTrue);
    });
  });
}
