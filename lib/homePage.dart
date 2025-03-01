import 'package:flutter/material.dart';
import 'package:simple_notification/notifications_service.dart';
import 'package:timezone/timezone.dart' as tz;

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TimeOfDay _selectedTime = TimeOfDay.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Notification Demo'),
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                  onPressed: () {
                    NotiService().showNotification(
                        title: "Instant Notification",
                        body: "This notification appears immediately"
                    );
                  },
                  child: const Text('Send Instant Notification')
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    NotiService().scheduleNotification(
                      title: "One Minute Reminder",
                      body: "This notification was scheduled 1 minute ago",
                      hour: tz.TZDateTime.now(tz.local).hour,
                      minute: tz.TZDateTime.now(tz.local).minute + 1,
                    );
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Notification scheduled for 1 minute from now")),
                    );
                  },
                  child: const Text('Schedule in 1 Minute')
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: _selectedTime,
                    );

                    if (picked != null) {
                      // Schedule notification at the picked time
                      NotiService().scheduleNotification(
                        title: "Custom Time Notification",
                        body: "This notification was scheduled for a specific time",
                        hour: picked.hour,
                        minute: picked.minute,
                      );

                      // Calculate and show when notification will appear
                      final now = tz.TZDateTime.now(tz.local);
                      var scheduledDate = tz.TZDateTime(
                        tz.local,
                        now.year,
                        now.month,
                        now.day,
                        picked.hour,
                        picked.minute,
                      );

                      // If the time is earlier today, schedule it for tomorrow
                      if (scheduledDate.isBefore(now)) {
                        scheduledDate = scheduledDate.add(const Duration(days: 1));
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(
                            "Notification scheduled for ${picked.format(context)}"
                        )),
                      );
                    }
                  },
                  child: const Text('Schedule at Custom Time')
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                  onPressed: () {
                    NotiService().cancelAllNoti();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("All notifications canceled")),
                    );
                  },
                  child: const Text('Cancel All Notifications')
              ),
            ],
          ),
        )
    );
  }
}