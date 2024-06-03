import 'package:flutter/material.dart';
import 'package:home_automation/pages/home/device/inspect/inspector.dart';

abstract class DeviceType {
  DeviceType();

  String identifier();

  Icon icon();
  Widget inspect(InspectorParameters parameters);
}
