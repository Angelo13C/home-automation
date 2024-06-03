import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:home_automation/pages/home/room/data/room.dart';
import 'package:home_automation/pages/home/room/data/storage.dart';

class RoomList with ChangeNotifier {
  late List<Room> _rooms;

  final storage = RoomStorage();

  RoomList(this._rooms);

  UnmodifiableListView<Room> get rooms => UnmodifiableListView(_rooms);

  Future<List<Room>> loadFromFile() async {
    final loadedRooms = await storage.getCreatedRooms();
    _rooms = loadedRooms;
    return loadedRooms;
  }

  void add(Room room) {
    _rooms.add(room);
    storage.saveRooms(_rooms).then((_) => notifyListeners());
  }

  void remove(Room room) {
    _rooms.remove(room);
    storage.saveRooms(_rooms).then((_) => notifyListeners());
  }

  void rename(Room room, String newName) {
    _rooms[_rooms.indexWhere((iteratedRoom) => iteratedRoom.name == room.name)]
        .name = newName;
    storage.saveRooms(_rooms).then((_) => notifyListeners());
  }
}
