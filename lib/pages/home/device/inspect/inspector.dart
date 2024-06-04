import 'package:flutter/material.dart';
import 'package:home_automation/pages/home/device/data/device.dart';

class DeviceInspectorPage extends StatefulWidget {
  final Device device;

  const DeviceInspectorPage(this.device, {super.key});

  @override
  State<DeviceInspectorPage> createState() => _DeviceInspectorPageState();
}

class _DeviceInspectorPageState extends State<DeviceInspectorPage> {
  @override
  Widget build(BuildContext context) {
    final deviceName = widget.device.name;
    return Scaffold(
      body: Builder(
        builder: (context) => widget.device.type.inspect(
          InspectorParameters(
            appBar: AppBar(
              backgroundColor: const Color(0xFF262626),
              title: Text(
                deviceName,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold),
              ),
              automaticallyImplyLeading: false,
            ),
          ),
        ),
      ),
    );
  }
}

class InspectorParameters {
  AppBar appBar;

  InspectorParameters({required this.appBar});
}
