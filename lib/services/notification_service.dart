import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  factory NotificationService() => _instance;

  NotificationService._();

  static final NotificationService _instance = NotificationService._();
  final FlutterLocalNotificationsPlugin notificationPlugin =
      FlutterLocalNotificationsPlugin();

  static const AndroidNotificationChannel _channel =
      AndroidNotificationChannel(
    'harry_potter_notifications',
    'Harry Potter Notifications',
    description: 'Notifikasi untuk aplikasi Harry Potter',
    importance: Importance.high,
  );

  Future<void> init() async {
    const initializationSettings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );
    await notificationPlugin.initialize(initializationSettings);

    final androidPlugin = notificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    await androidPlugin?.requestNotificationsPermission();
    await androidPlugin?.createNotificationChannel(_channel);
  }

  Future<void> showInstantNotification({
    required String title,
    required String body,
  }) async {
    const notificationDetails = NotificationDetails(
      android: AndroidNotificationDetails(
        'harry_potter_notifications',
        'Harry Potter Notifications',
        channelDescription: 'Notifikasi untuk aplikasi Harry Potter',
        importance: Importance.high,
        priority: Priority.high,
      ),
    );

    await notificationPlugin.show(0, title, body, notificationDetails);
  }
}
