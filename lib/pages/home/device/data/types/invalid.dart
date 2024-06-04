import 'package:flutter/material.dart';
import 'package:home_automation/pages/bottom_navigation_bar.dart';
import 'package:home_automation/pages/home/device/data/type.dart';
import 'package:home_automation/pages/home/device/inspect/inspector.dart';
import 'package:json_annotation/json_annotation.dart';

part 'invalid.g.dart';

@JsonSerializable()
class InvalidDeviceType extends DeviceType {
  InvalidDeviceType();

  @override
  String identifier() {
    return "INVALID";
  }

  @override
  Icon icon() => const Icon(Icons.error);

  @override
  Widget inspect(InspectorParameters parameters) {
    return const Scaffold(
      bottomNavigationBar: CustomBottomNavigationBar(
        showBackButton: true,
      ),
      body: Center(
        child: Text(
          "INVALID",
          style: TextStyle(
              fontSize: 50, fontWeight: FontWeight.bold, color: Colors.red),
        ),
      ),
    );
  }

  factory InvalidDeviceType.fromJson(Map<String, dynamic> json) =>
      _$InvalidDeviceTypeFromJson(json);

  Map<String, dynamic> toJson() => _$InvalidDeviceTypeToJson(this);
}
