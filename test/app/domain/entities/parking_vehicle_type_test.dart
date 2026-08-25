import 'package:flutter_test/flutter_test.dart';
import 'package:ts_parking/app/core/enums/parking_vehicle_type.dart';

void main() {
  group('fromApiName', () {
    test('returns truck for truck', () {
      expect(
        ParkingVehicleTypeX.fromApiName('truck'),
        equals(ParkingVehicleType.truck),
      );
    });

    test('returns truck for Truck (case insensitive)', () {
      expect(
        ParkingVehicleTypeX.fromApiName('Truck'),
        equals(ParkingVehicleType.truck),
      );
    });

    test('returns truck for TRUCK', () {
      expect(
        ParkingVehicleTypeX.fromApiName('TRUCK'),
        equals(ParkingVehicleType.truck),
      );
    });

    test('returns truck for string containing truck', () {
      expect(
        ParkingVehicleTypeX.fromApiName('Big truck parking'),
        equals(ParkingVehicleType.truck),
      );
    });

    test('returns trailer for trailer', () {
      expect(
        ParkingVehicleTypeX.fromApiName('trailer'),
        equals(ParkingVehicleType.trailer),
      );
    });

    test('returns trailer for Trailer', () {
      expect(
        ParkingVehicleTypeX.fromApiName('Trailer'),
        equals(ParkingVehicleType.trailer),
      );
    });

    test('returns bobtail for bobtail', () {
      expect(
        ParkingVehicleTypeX.fromApiName('bobtail'),
        equals(ParkingVehicleType.bobtail),
      );
    });

    test('returns bobtail for Bobtail', () {
      expect(
        ParkingVehicleTypeX.fromApiName('Bobtail'),
        equals(ParkingVehicleType.bobtail),
      );
    });

    test('returns unknown for unknown type', () {
      expect(
        ParkingVehicleTypeX.fromApiName('sedan'),
        equals(ParkingVehicleType.unknown),
      );
    });

    test('returns unknown for empty string', () {
      expect(
        ParkingVehicleTypeX.fromApiName(''),
        equals(ParkingVehicleType.unknown),
      );
    });
  });

  group('apiId', () {
    test('truck has apiId 1', () {
      expect(ParkingVehicleType.truck.apiId, equals(1));
    });

    test('trailer has apiId 2', () {
      expect(ParkingVehicleType.trailer.apiId, equals(2));
    });

    test('bobtail has apiId 3', () {
      expect(ParkingVehicleType.bobtail.apiId, equals(3));
    });

    test('unknown has apiId 0', () {
      expect(ParkingVehicleType.unknown.apiId, equals(0));
    });
  });

  group('label', () {
    test('truck label is Truck', () {
      expect(ParkingVehicleType.truck.label, equals('Truck'));
    });

    test('trailer label is Trailer', () {
      expect(ParkingVehicleType.trailer.label, equals('Trailer'));
    });

    test('bobtail label is Bobtail', () {
      expect(ParkingVehicleType.bobtail.label, equals('Bobtail'));
    });

    test('unknown label is Vehicle', () {
      expect(ParkingVehicleType.unknown.label, equals('Vehicle'));
    });
  });

  group('code', () {
    test('truck code is T', () {
      expect(ParkingVehicleType.truck.code, equals('T'));
    });

    test('trailer code is R', () {
      expect(ParkingVehicleType.trailer.code, equals('R'));
    });

    test('bobtail code is B', () {
      expect(ParkingVehicleType.bobtail.code, equals('B'));
    });

    test('unknown code is ?', () {
      expect(ParkingVehicleType.unknown.code, equals('?'));
    });
  });
}
