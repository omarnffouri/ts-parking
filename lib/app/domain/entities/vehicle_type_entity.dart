import 'package:equatable/equatable.dart';

class VehicleTypeEntity extends Equatable {
  final int id;
  final String name;
  final double price;

  const VehicleTypeEntity({
    required this.id,
    required this.name,
    required this.price,
  });

  @override
  List<Object?> get props => [id, name, price];
}
