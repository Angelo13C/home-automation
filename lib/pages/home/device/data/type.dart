import 'package:flutter/material.dart';

abstract class DeviceType {
  DeviceType();

  String identifier();

  Icon icon();
}
