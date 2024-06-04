import 'package:flutter/material.dart';
import 'package:home_automation/pages/home/device/data/type.dart';
import 'package:home_automation/pages/home/device/data/types/widgets/camera.dart';
import 'package:home_automation/pages/home/device/inspect/inspector.dart';
import 'package:json_annotation/json_annotation.dart';

part 'camera.g.dart';

@JsonSerializable()
class Camera extends DeviceType {
  final String ipAddress;

  static const identifierStr = "Camera";

  @override
  String identifier() {
    return identifierStr;
  }

  Camera(this.ipAddress) : super();

  @override
  Icon icon() => const Icon(Icons.videocam);

  @override
  Widget inspect(InspectorParameters parameters) {
    return CameraWidget(parameters, ipAddress);
  }

  factory Camera.fromJson(Map<String, dynamic> json) => _$CameraFromJson(json);

  Map<String, dynamic> toJson() => _$CameraToJson(this);
}
