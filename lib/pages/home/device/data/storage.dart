import 'dart:convert';
import 'dart:io';

import 'package:home_automation/pages/home/device/data/device.dart';
import 'package:path_provider/path_provider.dart';

class DeviceStorage {
  static const filePath = "devices.json";

  Future<List<Device>> getCreatedDevices(final String roomName) async {
    final file = await _localFile;
    Iterable devicesIter = json.decode(await file.readAsString());
    List<Device> devices =
        List<Device>.from(devicesIter.map((model) => Device.fromJson(model)));

    return devices;
  }

  Future<File> saveDevices(List<Device> devices) async {
    final file = await _localFile;
    final devicesAsJson = json.encode(devices);
    return file.writeAsString(devicesAsJson);
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/$filePath');
  }
}
