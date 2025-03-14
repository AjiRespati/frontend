import 'package:flutter/material.dart';
import 'gradient_elevated_button.dart';

class RemoveButton extends StatelessWidget {
  const RemoveButton({
    this.size,
    this.toolTip,
    required this.onPressed,
    super.key,
  });

  final double? size;
  final String? toolTip;
  final Function() onPressed;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: toolTip,
      child: SizedBox(
        height: size ?? 25,
        width: size ?? 25,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            shape: const CircleBorder(),
            backgroundColor: Colors.redAccent,
            padding: const EdgeInsets.all(0),
          ),
          onPressed: () {
            showDialog(
              context: context,
              builder: (context) => SizedBox(
                height: 100,
                child: AlertDialog(
                  backgroundColor: Colors.white,
                  title: const Text('Remove GV'),
                  content: Row(
                    children: [
                      Text(
                        toolTip ?? "",
                        style: const TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                  actions: [
                    SizedBox(
                      width: 100,
                      child: GradientElevatedButton(
                        gradient: LinearGradient(
                          colors: [
                            Colors.lightBlue.shade400,
                            Colors.blueAccent,
                          ],
                        ),
                        buttonHeight: 25,
                        onPressed: () {
                          Navigator.pop(context, false);
                        },
                        child: const Text(
                          'Cancel',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 100,
                      child: GradientElevatedButton(
                        gradient: LinearGradient(
                          colors: [
                            Colors.redAccent.shade100,
                            Colors.redAccent.shade700,
                          ],
                        ),
                        buttonHeight: 25,
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text(
                          'Remove',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ).then((value) {
              if (value == true) {
                onPressed();
              }
            });
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.remove,
                color: Colors.white,
                size: size == null ? 20 : size! * 0.6,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
