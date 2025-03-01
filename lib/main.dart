import 'package:flutter/material.dart';
import 'package:simple_notification/notifications_service.dart';
import 'dart:io' show Platform; // Import Platform

import 'homePage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  //init notification service
  final notiService = NotiService();
  await notiService.initNotification();

  // Request notification permissions
  if (Platform.isAndroid || Platform.isIOS) { // Request only on mobile platforms
    await notiService.requestPermissions();
  }

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
