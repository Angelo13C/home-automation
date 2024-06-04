import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mjpeg/flutter_mjpeg.dart';
import 'package:home_automation/pages/bottom_navigation_bar.dart';
import 'package:home_automation/pages/home/device/inspect/inspector.dart';

import 'package:window_manager/window_manager.dart';

class CameraWidget extends HookWidget {
  final String ipAddress;
  final InspectorParameters inspectorParameters;

  const CameraWidget(this.inspectorParameters, this.ipAddress, {super.key});

  @override
  Widget build(BuildContext context) {
    final isRunning = useState(true);
    final isFullScreen = useState(false);
    final mjpegPreprocessor = CustomPreprocessor();
    return Scaffold(
      bottomNavigationBar: isFullScreen.value
          ? null
          : const CustomBottomNavigationBar(
              showBackButton: true,
            ),
      appBar: isFullScreen.value ? null : inspectorParameters.appBar,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Center(
              child: Stack(
                alignment: AlignmentDirectional.bottomEnd,
                children: [
                  Mjpeg(
                    isLive: isRunning.value,
                    fit: BoxFit.fill,
                    width: isFullScreen.value ? 1440 : null,
                    height: isFullScreen.value ? 1080 : null,
                    error: (context, error, stack) {
                      return Text(
                        error.toString(),
                        style: const TextStyle(
                            color: Colors.red, fontWeight: FontWeight.bold),
                      );
                    },
                    stream: 'http://$ipAddress:81/stream',
                    preprocessor: mjpegPreprocessor,
                  ),
                  Visibility(
                    visible: isFullScreen.value,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        shape: BoxShape.rectangle,
                        border: Border.symmetric(
                            vertical:
                                BorderSide(width: 75, color: Colors.black26),
                            horizontal:
                                BorderSide(width: 50, color: Colors.black26)),
                      ),
                    ),
                  ),
                  Visibility(
                    visible: isFullScreen.value,
                    child: TextButton(
                      style: ButtonStyle(
                        foregroundColor:
                            WidgetStateProperty.all<Color>(Colors.white),
                      ),
                      onPressed: () {
                        isFullScreen.value = !isFullScreen.value;
                        WindowManager.instance
                            .setFullScreen(isFullScreen.value);
                      },
                      child:
                          const Icon(Icons.fullscreen_exit_outlined, size: 50),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Visibility(
            visible: !isFullScreen.value,
            child: const SizedBox(
              height: 30,
            ),
          ),
          Visibility(
            visible: !isFullScreen.value,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    FilePicker.platform.saveFile(
                        dialogTitle: 'Save the captured image',
                        fileName: 'image.jpg',
                        type: FileType.custom,
                        allowedExtensions: ["jpg"]).then((filePath) {
                      if (filePath != null) {
                        final saveFile = File(filePath);
                        saveFile.writeAsBytes(mjpegPreprocessor.savedFrame);
                      }
                    });
                  },
                  child: const Icon(
                    Icons.photo_camera,
                    size: 50,
                  ),
                ),
                const SizedBox(
                  width: 30,
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () => isRunning.value = !isRunning.value,
                  child: Icon(isRunning.value ? Icons.pause : Icons.play_arrow,
                      size: 50),
                ),
                const SizedBox(
                  width: 30,
                ),
                TextButton(
                  style: ButtonStyle(
                    foregroundColor:
                        WidgetStateProperty.all<Color>(Colors.black),
                  ),
                  onPressed: () {
                    isFullScreen.value = !isFullScreen.value;
                    WindowManager.instance.setFullScreen(isFullScreen.value);
                  },
                  child: const Icon(Icons.fullscreen, size: 50),
                ),
              ],
            ),
          ),
          Visibility(
            visible: !isFullScreen.value,
            child: const SizedBox(
              height: 30,
            ),
          ),
        ],
      ),
    );
  }
}

class CustomPreprocessor implements MjpegPreprocessor {
  List<int> savedFrame;

  CustomPreprocessor() : savedFrame = [];

  @override
  List<int>? process(List<int> frame) {
    savedFrame = frame;

    return frame;
  }
}
