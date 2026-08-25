import 'package:equatable/equatable.dart';

class YardEntity extends Equatable {
  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final int capacityTotal;
  final int availableSlots;
  final String status;
  final String? imageUrl;

  const YardEntity({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.capacityTotal,
    required this.availableSlots,
    required this.status,
    this.imageUrl,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    address,
    latitude,
    longitude,
    capacityTotal,
    availableSlots,
    status,
    imageUrl,
  ];
}
