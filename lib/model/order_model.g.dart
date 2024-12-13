// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrderModelAdapter extends TypeAdapter<OrderModel> {
  @override
  final int typeId = 1;

  @override
  OrderModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrderModel(
      products: (fields[0] as List?)?.cast<ProductModel>(),
      phoneNumber: fields[1] as String?,
      emailAddress: fields[2] as String?,
      addressLine1: fields[3] as String?,
      addressLine2: fields[4] as String?,
      city: fields[5] as String?,
      state: fields[6] as String?,
      pincode: fields[7] as String?,
      country: fields[8] as String?,
      totalPrice: fields[9] as double?,
      status: fields[10] as String?,
      timeStamp: fields[11] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, OrderModel obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.products)
      ..writeByte(1)
      ..write(obj.phoneNumber)
      ..writeByte(2)
      ..write(obj.emailAddress)
      ..writeByte(3)
      ..write(obj.addressLine1)
      ..writeByte(4)
      ..write(obj.addressLine2)
      ..writeByte(5)
      ..write(obj.city)
      ..writeByte(6)
      ..write(obj.state)
      ..writeByte(7)
      ..write(obj.pincode)
      ..writeByte(8)
      ..write(obj.country)
      ..writeByte(9)
      ..write(obj.totalPrice)
      ..writeByte(10)
      ..write(obj.status)
      ..writeByte(11)
      ..write(obj.timeStamp);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
