import 'package:home_automation/pages/home/device/data/type.dart';
import 'package:home_automation/pages/home/device/data/types/invalid.dart';
import 'package:json_annotation/json_annotation.dart';

import 'types/camera.dart';

part 'device.g.dart';

@JsonSerializable()
class Device {
  final String name;
  @DeviceTypeConverter()
  final DeviceType type;
  String roomName;

  Device({required this.name, required this.type, required this.roomName});

  factory Device.fromJson(Map<String, dynamic> json) => _$DeviceFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceToJson(this);
}

class DeviceTypeConverter
    implements JsonConverter<DeviceType, Map<String, dynamic>> {
  const DeviceTypeConverter();

  @override
  DeviceType fromJson(Map<String, dynamic> json) {
    switch (json.keys.first) {
      case "Camera":
        {
          return Camera.fromJson(json['Camera']);
        }
    }

    return InvalidDeviceType();
  }

  @override
  Map<String, dynamic> toJson(DeviceType deviceType) =>
      {deviceType.identifier(): deviceType};
}
