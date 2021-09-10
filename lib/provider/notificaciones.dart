import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../main.dart';

Future notificacion(int id, String titulo, String contenido) async {
  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
      'your channel id', 'your channel name', 'your channel description',
      importance: Importance.max, priority: Priority.high);
  var iOSPlatformChannelSpecifics = new IOSNotificationDetails();
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);
  await flip.show(id, titulo, contenido, platformChannelSpecifics,
      payload: titulo);
}

// ignore: missing_return
Future onSelectNotification(String payload) {}
