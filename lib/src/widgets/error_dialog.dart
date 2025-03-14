import 'package:flutter/material.dart';

Future<bool?> errorDialog({
  required BuildContext context,
  required String? errorTitle,
  required String? errorDescription,
  required String? errorSolution,
  required bool? isWarning,
  Function(bool? isConfirmed)? doConfirming,
  bool? isConfirmationDialog,
}) {
  return showDialog(
    barrierColor: const Color(0x00ffffff),
    context: context,
    builder: (ctx) {
      return Dialog(
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: isWarning == true
                  ? Colors.greenAccent
                  : Theme.of(context).colorScheme.error,
              width: 0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        backgroundColor: Colors.white,
        child: SizedBox(
          width: 500,
          height: 190,
          child: ErrorContent(
            errorTitle: errorTitle,
            errorDescription: errorDescription,
            errorSolution: errorSolution,
            isConfirmationDialog: isConfirmationDialog,
            isWarning: isWarning,
          ),
        ),
      );
    },
  ).then(
    (value) {
      if (doConfirming != null) {
        doConfirming(value);
      }
      return true;
    },
  );
}

class ErrorContent extends StatefulWidget {
  final String? errorTitle;
  final String? errorDescription;
  final String? errorSolution;
  final bool? isConfirmationDialog;
  final bool? isMobile;
  final bool? isWarning;
  const ErrorContent({
    required this.errorTitle,
    required this.errorDescription,
    required this.errorSolution,
    required this.isWarning,
    this.isConfirmationDialog,
    this.isMobile,
    super.key,
  });

  @override
  State<ErrorContent> createState() => _ErrorContentState();
}

class _ErrorContentState extends State<ErrorContent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    size: 26,
                    color: widget.isWarning == true
                        ? Colors.greenAccent
                        : Colors.red[700],
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                widget.errorTitle ?? "Terjadi Kesalahan",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: widget.isWarning == true
                        ? Colors.greenAccent
                        : Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 2),
              Text(
                widget.errorDescription ?? "",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: widget.isWarning == true
                        ? Colors.greenAccent
                        : Theme.of(context).colorScheme.error),
              ),
              const SizedBox(height: 2),
              Text(
                widget.errorSolution ?? "",
                style: TextStyle(
                    // fontWeight: FontWeight.bold,
                    color: widget.isWarning == true
                        ? Colors.greenAccent
                        : Theme.of(context).colorScheme.error),
              ),
              const Spacer(),
              const SizedBox(height: 10),
              widget.isConfirmationDialog == true
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          // width: double.infinity,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.amber[800],
                              ),
                            ),
                            child: const Text("No"),
                          ),
                        ),
                        const SizedBox(width: 10),
                        SizedBox(
                          // width: double.infinity,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.green[600],
                              ),
                            ),
                            child: const Text("Yes"),
                          ),
                        ),
                        const SizedBox(width: 20),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          // width: double.infinity,
                          height: 30,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            style: ButtonStyle(
                              backgroundColor: WidgetStateProperty.all(
                                Colors.amber[800],
                              ),
                            ),
                            child: const Text("Close"),
                          ),
                        ),
                      ],
                    ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        Align(
          alignment: const Alignment(1.02, -1.1),
          child: IconButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close),
          ),
        ),
      ],
    );
  }
}
