import 'package:flutter/material.dart';
import 'package:home_automation/pages/bottom_navigation_bar.dart';
import 'package:home_automation/pages/home/device/create/page.dart';
import 'package:home_automation/pages/home/device/data/device.dart';
import 'package:home_automation/pages/home/device/inspect/inspector.dart';
import 'package:home_automation/pages/home/device/data/list.dart';
import 'package:home_automation/pages/home/room/data/room.dart';
import 'package:provider/provider.dart';

class ShowDevicesPage extends StatelessWidget {
  final Room room;
  final Function(String) renameRoom;
  final bool Function(String) canRenameRoom;
  final Function() deleteRoom;
  final myController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  ShowDevicesPage(
      {required this.room,
      required this.renameRoom,
      required this.canRenameRoom,
      required this.deleteRoom,
      super.key});

  @override
  Widget build(BuildContext context) {
    final deviceList = context.watch<DeviceList>();
    return Scaffold(
      appBar: AppBar(
        title: Text(
          room.name,
        ),
        titleTextStyle: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),
        automaticallyImplyLeading: false,
        flexibleSpace: Container(
          color: const Color(0xFF262626),
          alignment: Alignment.centerRight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Rename the room"),
                        titleTextStyle: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 20),
                        actionsOverflowButtonSpacing: 20,
                        actions: [
                          Tooltip(
                            message: "Cancel",
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                          Tooltip(
                            message: "Apply",
                            child: ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  final newRoomName = myController.text;
                                  deviceList.renameRoom(room.name, newRoomName);
                                  renameRoom(newRoomName);
                                  Navigator.of(context).pop();
                                }
                              },
                              child: const Icon(Icons.check),
                            ),
                          ),
                        ],
                        content: Form(
                            key: _formKey,
                            child: TextFormField(
                              controller: myController,
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                hintText: 'Name of the room',
                              ),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter some text';
                                }
                                if (!canRenameRoom(value)) {
                                  return 'A room with this name already exists!';
                                }
                                return null;
                              },
                            )),
                      );
                    }),
                child: const Icon(
                  Icons.edit,
                  color: Colors.white,
                ),
              ),
              TextButton(
                onPressed: () => showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: const Text("Delete the room"),
                        titleTextStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.red,
                          fontSize: 20,
                        ),
                        actionsOverflowButtonSpacing: 20,
                        actions: [
                          Tooltip(
                            message: "Cancel",
                            child: ElevatedButton(
                              onPressed: () => Navigator.of(context).pop(),
                              child: const Icon(Icons.arrow_back),
                            ),
                          ),
                          Tooltip(
                            message: "Delete",
                            child: ElevatedButton(
                              onPressed: () {
                                deviceList.removeAllDevicesInRoom(room.name);
                                deleteRoom();
                                Navigator.of(context).pop();
                                Navigator.of(context).pop();
                              },
                              child: const Icon(Icons.delete),
                            ),
                          ),
                        ],
                        content: const Text(
                          "All the devices in this room will also be deleted!",
                          style: TextStyle(color: Colors.red),
                        ),
                      );
                    }),
                child: const Icon(
                  Icons.delete,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        showBackButton: true,
        addWidget: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) =>
                CreateDevicePage(roomName: room.name, deviceList: deviceList),
          ),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(0),
        child: DeviceListDisplay(roomName: room.name),
      ),
    );
  }
}

class DeviceListDisplay extends StatelessWidget {
  final String roomName;

  const DeviceListDisplay({required this.roomName, super.key});

  @override
  Widget build(BuildContext context) {
    final devicesData = context.watch<DeviceList>();
    return FutureBuilder(
      future: devicesData.loadFromFile(roomName).then((loadedDevices) =>
          List<Device>.from(
              loadedDevices.where((device) => device.roomName == roomName))),
      builder: (context, snapshot) => switch (snapshot.connectionState) {
        ConnectionState.done => ListView.separated(
            itemCount: snapshot.data?.length ?? 0,
            separatorBuilder: (_, __) =>
                Container(height: 2, color: Colors.grey[300]),
            itemBuilder: (context, index) {
              return ListTile(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: TextButton(
                        style: ButtonStyle(
                          foregroundColor:
                              WidgetStateProperty.all<Color>(Colors.black),
                        ),
                        onPressed: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) =>
                                DeviceInspectorPage(snapshot.data![index]),
                          ),
                        ),
                        child: Row(
                          children: [
                            snapshot.data![index].type.icon(),
                            const SizedBox(width: 20),
                            Text(
                              snapshot.data![index].name,
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    ),
                    TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.black),
                      ),
                      onPressed: () =>
                          devicesData.remove(snapshot.data![index]),
                      child: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            },
          ),
        _ => Container()
      },
    );
  }
}
