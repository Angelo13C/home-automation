import 'package:flutter/material.dart';
import 'package:home_automation/pages/bottom_navigation_bar.dart';
import 'package:home_automation/pages/home/room/data/list.dart';
import 'package:home_automation/pages/home/room/data/room.dart';

import 'dart:core';

class CreateRoomPage extends StatefulWidget {
  final RoomList roomList;

  const CreateRoomPage(this.roomList, {super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
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
          "Add a new room",
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
                  hintText: 'Name of the room',
                ),
                onChanged: (String newValue) => name = newValue,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter some text';
                  }
                  return null;
                },
              ),
            ),
            const SizedBox(
              height: 30,
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  widget.roomList.add(Room(name));

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
}
