import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final bool showBackButton;

  final void Function()? addWidget;

  const CustomBottomNavigationBar(
      {required this.showBackButton, this.addWidget, super.key});

  @override
  Widget build(BuildContext context) {
    const double iconSize = 60;
    return SizedBox(
      height: 80,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: showBackButton,
            child: BackButton(
              style: ButtonStyle(iconSize: WidgetStateProperty.all(iconSize)),
            ),
          ),
          Visibility(
            visible: addWidget != null && showBackButton,
            child: const SizedBox(width: 50),
          ),
          Visibility(
            visible: addWidget != null,
            child: Tooltip(
              message: "Create new",
              child: IconButton(
                onPressed: addWidget,
                icon: const Icon(
                  Icons.add,
                  size: iconSize,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
