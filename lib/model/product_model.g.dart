// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 0;

  @override
  ProductModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ProductModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      description: fields[2] as String?,
      price: fields[3] as double?,
      category: fields[4] as String?,
      sizes: (fields[5] as List?)?.cast<String>(),
      images: (fields[6] as List?)?.cast<String>(),
      isAvailable: fields[7] as bool,
      rating: fields[8] as double?,
      stock: fields[9] as int?,
      colors: (fields[10] as List?)?.cast<String>(),
      uId: fields[11] as String?,
      selectedColor: fields[12] as String?,
      selectedSize: fields[13] as String?,
      quantity: fields[14] as int?,
      discount: fields[15] as double?,
      tags: (fields[16] as List?)?.cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer
      ..writeByte(17)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.price)
      ..writeByte(4)
      ..write(obj.category)
      ..writeByte(5)
      ..write(obj.sizes)
      ..writeByte(6)
      ..write(obj.images)
      ..writeByte(7)
      ..write(obj.isAvailable)
      ..writeByte(8)
      ..write(obj.rating)
      ..writeByte(9)
      ..write(obj.stock)
      ..writeByte(10)
      ..write(obj.colors)
      ..writeByte(11)
      ..write(obj.uId)
      ..writeByte(12)
      ..write(obj.selectedColor)
      ..writeByte(13)
      ..write(obj.selectedSize)
      ..writeByte(14)
      ..write(obj.quantity)
      ..writeByte(15)
      ..write(obj.discount)
      ..writeByte(16)
      ..write(obj.tags);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ProductModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
