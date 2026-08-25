import 'package:equatable/equatable.dart';

class ZoneEntity extends Equatable {
  final String id;
  final String yardId;
  final String name;
  final String? description;
  final int capacity;
  final String status;
  final int slotsCount;

  const ZoneEntity({
    required this.id,
    this.yardId = '',
    required this.name,
    this.description,
    this.capacity = 0,
    this.status = '',
    this.slotsCount = 0,
  });

  @override
  List<Object?> get props => [
    id,
    yardId,
    name,
    description,
    capacity,
    status,
    slotsCount,
  ];
}
