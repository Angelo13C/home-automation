import 'dart:convert';
import 'dart:io';

import 'package:home_automation/pages/home/room/data/room.dart';
import 'package:path_provider/path_provider.dart';

class RoomStorage {
  static const filePath = "rooms.json";

  Future<List<Room>> getCreatedRooms() async {
    final file = await _localFile;
    Iterable roomsIter = json.decode(await file.readAsString());
    List<Room> rooms =
        List<Room>.from(roomsIter.map((model) => Room.fromJson(model)));

    return rooms;
  }

  Future<File> saveRooms(List<Room> rooms) async {
    final file = await _localFile;
    final roomsAsJson = json.encode(rooms);
    return file.writeAsString(roomsAsJson);
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
