// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'p_order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class POrderModelAdapter extends TypeAdapter<POrderModel> {
  @override
  final int typeId = 1;

  @override
  POrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return POrderModel(
      orderStatus: fields[0] as String,
      products: (fields[1] as List).cast<OrderModel>(),
    );
  }

  @override
  void write(BinaryWriter writer, POrderModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.orderStatus)
      ..writeByte(1)
      ..write(obj.products);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is POrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
