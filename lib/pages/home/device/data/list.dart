import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:home_automation/pages/home/device/data/device.dart';
import 'package:home_automation/pages/home/device/data/storage.dart';

class DeviceList with ChangeNotifier {
  late List<Device> _devices = [];

  final storage = DeviceStorage();

  UnmodifiableListView<Device> get devices => UnmodifiableListView(_devices);

  Future<List<Device>> loadFromFile(final String roomName) async {
    final loadedDevices = await storage.getCreatedDevices(roomName);
    _devices = loadedDevices;
    return loadedDevices;
  }

  void add(Device device) {
    _devices.add(device);
    storage.saveDevices(_devices).then((_) => notifyListeners());
  }

  void remove(Device device) {
    _devices.remove(device);
    storage.saveDevices(_devices).then((_) => notifyListeners());
  }

  void removeAllDevicesInRoom(String roomName) {
    _devices.removeWhere((device) => device.roomName == roomName);

    storage.saveDevices(_devices).then((_) => notifyListeners());
  }

  void renameRoom(String oldRoomName, String newRoomName) {
    for (var i = 0; i < devices.length; i++) {
      if (devices[i].roomName == oldRoomName) {
        _devices[i].roomName = newRoomName;
      }
    }

    storage.saveDevices(_devices).then((_) => notifyListeners());
  }

  void moveRoomOfDevice(Device device, String newRoomName) {
    _devices[_devices
            .indexWhere((iteratedDevice) => iteratedDevice.name == device.name)]
        .roomName = newRoomName;

    storage.saveDevices(_devices).then((_) => notifyListeners());
  }
}
