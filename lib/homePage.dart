import 'package:flutter/material.dart';
import 'package:simple_notification/notifications_service.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          spacing: 50,
          children: [
            ElevatedButton(
                onPressed: () {
                  NotiService().showNotification(
                    title: "Testing",
                    body: "This is a body"
                  );
                },
                child: const Text('Send Notifications')),
            ElevatedButton(onPressed: () {
              NotiService().showNotification(
                title: "Schedule",
                body: "This is a schedule messages"
              );
            }, child: Text('Schedule Notifications'))
          ],
        ),
      )
    );
  }
}
