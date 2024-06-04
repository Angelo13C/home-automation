import 'package:flutter/material.dart';
import 'package:home_automation/pages/bottom_navigation_bar.dart';
import 'package:home_automation/pages/home/device/data/device.dart';
import 'package:home_automation/pages/home/device/data/type.dart';
import 'package:home_automation/pages/home/device/data/types/invalid.dart';
import 'package:home_automation/pages/home/device/data/list.dart';

import 'dart:core';

import '../data/types/camera.dart';

class CreateDevicePage extends StatefulWidget {
  final String roomName;
  final DeviceList deviceList;

  const CreateDevicePage(
      {required this.roomName, required this.deviceList, super.key});

  @override
  State<CreateDevicePage> createState() => _CreateDevicePageState();
}

class _CreateDevicePageState extends State<CreateDevicePage> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: const CustomBottomNavigationBar(
        showBackButton: true,
      ),
      appBar: AppBar(
        backgroundColor: const Color(0xFF262626),
        title: const Text(
          "Add a new device",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 16),
              child: TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Name of the device',
                ),
                onChanged: (String newValue) => name = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  if (widget.deviceList.devices
                      .any((device) => device.name == value)) {
                    return 'A device with this name already exists!';
                  }
                  return null;
                },
              ),
            ),
            Builder(
              builder: (context) {
                switch (type) {
                  case Camera.identifierStr:
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 16),
                      child: TextFormField(
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'IP address of the device',
                        ),
                        onChanged: (String newValue) => ipAddress = newValue,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter some text';
                          }
                          try {
                            Uri.parseIPv4Address(value);
                          } on Exception catch (e) {
                            return e.toString();
                          }

                          return null;
                        },
                      ),
                    );
                }

                return Container();
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 16),
              child: DropdownButton(
                  onChanged: (String? newValue) {
                    setState(() {
                      type = newValue!;
                    });
                  },
                  value: type,
                  items: dropdownItems),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  DeviceType deviceType = InvalidDeviceType();
                  switch (type) {
                    case Camera.identifierStr:
                      deviceType = Camera(ipAddress);
                  }
                  widget.deviceList.add(Device(
                      name: name, type: deviceType, roomName: widget.roomName));

                  Navigator.pop(context, true);
                }
              },
              child: const Icon(Icons.check, size: 50),
            ),
          ],
        ),
      ),
    );
  }

  String name = "";
  String type = Camera.identifierStr;

  String ipAddress = "";

  List<DropdownMenuItem<String>> get dropdownItems {
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(
          value: Camera.identifierStr, child: Text("Camera")),
      const DropdownMenuItem(value: "Thermostat", child: Text("Thermostat")),
    ];
    return menuItems;
  }
}
