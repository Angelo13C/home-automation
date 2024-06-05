import 'package:flutter/material.dart';
import 'package:home_automation/pages/bottom_navigation_bar.dart';
import 'package:home_automation/pages/home/device/data/list.dart';
import 'package:home_automation/pages/home/device/page.dart';
import 'package:home_automation/pages/home/room/create/page.dart';
import 'package:home_automation/pages/home/room/data/list.dart';
import 'package:provider/provider.dart';

class ShowRoomsPage extends StatelessWidget {
  final RoomList roomList;

  const ShowRoomsPage(this.roomList, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF262626),
        title: const Text(
          "Your rooms",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      bottomNavigationBar: CustomBottomNavigationBar(
        showBackButton: false,
        addWidget: () => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => CreateRoomPage(roomList),
          ),
        ),
      ),
      body: const RoomListDisplay(),
    );
  }
}

class RoomListDisplay extends StatelessWidget {
  const RoomListDisplay({super.key});

  @override
  Widget build(BuildContext context) {
    final roomsData = context.watch<RoomList>();
    return FutureBuilder(
      future: roomsData.loadFromFile(),
      builder: (context, snapshot) => switch (snapshot.connectionState) {
        ConnectionState.done => GridView.builder(
            primary: false,
            padding: const EdgeInsets.all(20),
            itemCount: snapshot.data?.length ?? 0,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                mainAxisSpacing: 30,
                crossAxisSpacing: 30,
                crossAxisCount: 2,
                mainAxisExtent: 150),
            itemBuilder: (context, index) {
              final currentRoom = snapshot.data![index];
              return InkWell(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChangeNotifierProvider<DeviceList>(
                        create: (context) => DeviceList(),
                        builder: (context, child) => ShowDevicesPage(
                          room: currentRoom,
                          renameRoom: (newName) =>
                              roomsData.rename(currentRoom, newName),
                          canRenameRoom: (newName) => !roomsData.rooms
                              .any((room) => room.name == newName),
                          deleteRoom: () => roomsData.remove(currentRoom),
                        ),
                      ),
                    ),
                  );
                },
                focusColor: const Color(0xFF332173),
                splashColor: const Color(0xFF2B1A66),
                hoverColor: const Color(0xFF382285),
                highlightColor: const Color(0xFF251854),
                child: Ink(
                  decoration: const BoxDecoration(
                    color: Color(0xFF492DAD),
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(
                          switch (currentRoom.name.toLowerCase()) {
                            "kitchen" => Icons.restaurant,
                            "living room" => Icons.chair,
                            "bedroom" => Icons.bed,
                            "office" => Icons.print,
                            String() => Icons.home,
                          },
                          color: Colors.white,
                          size: 40,
                        ),
                        const SizedBox(height: 20),
                        Text(
                          currentRoom.name,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 40,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        _ => Container()
      },
    );
  }
}
