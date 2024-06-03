// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Device _$DeviceFromJson(Map<String, dynamic> json) => Device(
      name: json['name'] as String,
      type: const DeviceTypeConverter()
          .fromJson(json['type'] as Map<String, dynamic>),
      roomName: json['roomName'] as String,
    );

Map<String, dynamic> _$DeviceToJson(Device instance) => <String, dynamic>{
      'name': instance.name,
      'type': const DeviceTypeConverter().toJson(instance.type),
      'roomName': instance.roomName,
    };
