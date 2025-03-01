import 'package:flutter/material.dart';
import 'package:simple_notification/notifications_service.dart';

import 'homePage.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  //init notification
  NotiService().initNotification();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}
