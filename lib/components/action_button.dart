import 'package:flutter/material.dart';

class ActionButton extends StatelessWidget {
  final IconData? iconData;
  final Color color;
  final String label;
  final String? badgeText;
  final void Function()? onPressed;
  const ActionButton({
    super.key,
    this.iconData,
    this.badgeText,
    required this.onPressed,
    this.color = Colors.black,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraint) {
        Widget button;
        if (constraint.maxWidth >= 100) {
          button = SizedBox(
            height: 28,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: color,
                elevation: 1,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              onPressed: onPressed,
              icon: iconData == null
                  ? null
                  : Icon(iconData, size: 14, color: color),
              label: Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.black87),
              ),
            ),
          );
        } else {
          button = SizedBox(
            width: 45,
            height: 45,
            child: IconButton(
              onPressed: onPressed,
              style: IconButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: color,
                elevation: 1,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(3),
                ),
                side: BorderSide(color: Colors.grey.shade400),
              ),
              tooltip: label,
              icon: Icon(iconData, size: 18, color: color),
            ),
          );
        }
        if (badgeText == null) {
          return button;
        }
        return Badge(
          backgroundColor: Colors.blue.shade300,
          label: Text(badgeText!),
          alignment: .topRight,
          child: button,
        );
      },
    );
  }
}
