import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

class PermissionRequestPage extends StatelessWidget {
  const PermissionRequestPage({super.key});
  static Route route() {
    return MaterialPageRoute<void>(
        builder: (_) => const PermissionRequestPage());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                  "You don't have permission to access to photo library, please grant permission in device settings."),
              ElevatedButton(
                onPressed: (_openSettings),
                child: const Text('Open setting'),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _openSettings() async {
    await openAppSettings();
  }
}
