import 'package:flutter/material.dart';
import 'package:home_automation/pages/home/home.dart';
import 'package:window_manager/window_manager.dart';

void main() async {
  initializeWindow();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Home automation",
      theme: ThemeData(scaffoldBackgroundColor: Colors.white),
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<void> initializeWindow() async {
  WidgetsFlutterBinding.ensureInitialized();
  await windowManager.ensureInitialized();

  const windowOptions = WindowOptions(
    size: Size(800, 600),
    minimumSize: Size(550, 400),
    center: true,
    skipTaskbar: false,
    title: "Home automation",
    titleBarStyle: TitleBarStyle.normal,
  );
  return windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });
}
