import 'package:flutter/material.dart';
import 'package:home_automation/pages/home/room/data/list.dart';
import 'package:home_automation/pages/home/room/page.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RoomList>(
      create: (context) => RoomList([]),
      builder: (context, child) => ShowRoomsPage(context.watch<RoomList>()),
    );
  }
}
