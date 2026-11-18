import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'models/spell.dart';
import 'screens/login_screen.dart';
import 'services/notification_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();
  Hive.registerAdapter(SpellAdapter());
  await Hive.openBox<Spell>('favorite_spells');
  await NotificationService().init();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: LoginScreen(),
    ),
  );
}
