import 'package:flutter/material.dart';

confirmationDialog(
    BuildContext context, String confirmation, String description,
    {required Function(bool isConfirmed) handleConfirmation,
    bool? isCloseOnly,
    bool? isMobile}) {
  return isMobile == true
      ? showModalBottomSheet(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(10.0)),
          ),
          isDismissible: true,
          isScrollControlled: true,
          context: context,
          builder: (ctx) {
            return SizedBox(
              height: 325,
              child: ConfirmationDialogContent(
                isCloseOnly: isCloseOnly,
                confirmation: confirmation,
                description: description,
                isMobile: true,
              ),
            );
          },
        ).then((value) {
          if (value == true) {
            handleConfirmation(true);
          } else {
            handleConfirmation(false);
          }
        })
      : showDialog(
          // barrierColor: const Color(0x00ffffff),
          context: context,
          builder: (ctx) {
            return Dialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                side: BorderSide(
                    color: Theme.of(context).primaryColor, width: 0.5),
                borderRadius: BorderRadius.circular(5),
              ),
              // backgroundColor: Colors.lightBlue[200],
              child: SizedBox(
                width: 500,
                height: 175,
                child: ConfirmationDialogContent(
                  isCloseOnly: isCloseOnly,
                  confirmation: confirmation,
                  description: description,
                  isMobile: false,
                ),
              ),
            );
          },
        ).then((value) {
          if (value == true) {
            handleConfirmation(true);
          } else {
            handleConfirmation(false);
          }
        });
}

class ConfirmationDialogContent extends StatelessWidget {
  const ConfirmationDialogContent({
    required this.confirmation,
    required this.description,
    required this.isMobile,
    this.isCloseOnly,
    super.key,
  });

  final String confirmation;
  final String description;
  final bool isMobile;
  final bool? isCloseOnly;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 5, 10, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 26,
                    color: Colors.red[700],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    confirmation,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Theme.of(context).primaryColor),
                  ),
                ],
              ),
              const SizedBox(height: 5),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  // fontWeight: FontWeight.bold,
                  fontSize: 15,
                  // color: ApplicationInfo.secondColor,
                ),
              ),
              const SizedBox(height: 15),
              isCloseOnly == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          // width: double.infinity,
                          height: 32,
                          width: 85,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                            child: const Text("Close"),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          // width: double.infinity,
                          height: 32,
                          width: 85,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor:
                                  WidgetStateProperty.all(Colors.red[400]),
                            ),
                            child: const Text("No"),
                          ),
                        ),
                        const SizedBox(width: 15),
                        SizedBox(
                          // width: double.infinity,
                          height: 32,
                          width: 85,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Theme.of(context).primaryColor,
                              ),
                            ),
                            child: const Text("Yes"),
                          ),
                        ),
                        const SizedBox(width: 10),
                      ],
                    ),
            ],
          ),
        ),
        Align(
          alignment: isMobile
              ? const Alignment(1.05, -1.08)
              : const Alignment(1.02, -1.12),
          child: const CloseButton(
            color: Colors.black38,
          ),
        ),
      ],
    );
  }
}
