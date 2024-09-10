import 'dart:developer';
import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

// Initialize FlutterLocalNotificationsPlugin
final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> initializeService() async {
  final service = FlutterBackgroundService();

  // Create notification channel before starting the service
  await createNotificationChannel();

  // Initialize notifications
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings();
  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsDarwin,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  // Configure the background service
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
      notificationChannelId: 'my_foreground', // Ensuring consistency
      initialNotificationTitle: 'Background Service',
      initialNotificationContent: 'Initializing...',
      foregroundServiceNotificationId: 888,
    ),
    iosConfiguration: IosConfiguration(
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );

  // Start the service
  service.startService();
}

// Create notification channel (required for Android 8.0 and higher)
Future<void> createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'my_foreground', // id must be consistent with the channel used in notifications
    'Background Service Channel', // Name of the channel
    description: 'This channel is used for background service notifications',
    importance: Importance.high, // Importance must be high for foreground services
  );

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  await Firebase.initializeApp();

  // Show a notification when the service starts
  await showNotification("Background Service Started", "The service is now running in the background", 888);

  if (service is AndroidServiceInstance) {
    service.on('setAsForeground').listen((event) {
      service.setAsForegroundService();
    });

    service.on('stopService').listen((event) {
      service.stopSelf();
    });
  }

  // Periodically update the notification every second
  Timer.periodic(const Duration(minutes: 1), (timer) async {
    if (service is AndroidServiceInstance) {
      log('Checking Firestore for high fill_percent values');

      // Query Firestore for documents with fill_percent over 75
      final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('bin_data')
          .where('fill_percent', isGreaterThan: 75)
          .get();

      for (var doc in querySnapshot.docs) {
        final fillPercent = doc['fill_percent'];
        final binId = doc['bin_id'];
        
        // Send a notification for each document found
        await showNotification(
          'High Fill Percentage Detected',
          'Bin $binId has a fill percentage of $fillPercent%',
          888,
        );
      }
    }
  });
}

// Function to show notification with consistent notificationId
Future<void> showNotification(String title, String body, int notificationId) async {
  const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
  'my_foreground', // Notification channel ID
  'Background Service',
  channelDescription: 'This channel is used for background service notifications',
  importance: Importance.low, // Lower importance level
  priority: Priority.low, // Lower priority
  showWhen: false, // Do not show the timestamp
  ongoing: true, // Keeps the notification persistent
  autoCancel: false, // Prevents the notification from being dismissed by user
);

  const NotificationDetails platformChannelSpecifics =
      NotificationDetails(android: androidPlatformChannelSpecifics);

  // Show the notification using the provided notificationId
  await flutterLocalNotificationsPlugin.show(
    notificationId, // ID to ensure the same notification is updated
    title,
    body,
    platformChannelSpecifics,
  );
}

// iOS background task handler
@pragma('vm:entry-point')
bool onIosBackground(ServiceInstance service) {
  WidgetsFlutterBinding.ensureInitialized();
  DartPluginRegistrant.ensureInitialized();
  return true;
}
