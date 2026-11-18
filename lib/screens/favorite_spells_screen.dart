import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/spell.dart';
import '../services/notification_service.dart';

class FavoriteSpellsScreen extends StatelessWidget {
  const FavoriteSpellsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final favoriteBox = Hive.box<Spell>('favorite_spells');

    return Scaffold(
      appBar: AppBar(title: const Text('Favorite Spell')),
      body: ValueListenableBuilder<Box<Spell>>(
        valueListenable: favoriteBox.listenable(),
        builder: (context, box, child) {
          if (box.isEmpty) {
            return const Center(child: Text('Belum ada spell favorit'));
          }

          return ListView.builder(
            itemCount: box.length,
            itemBuilder: (context, index) {
              final spell = box.getAt(index);
              if (spell == null) return const SizedBox.shrink();

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                child: ListTile(
                  leading: const Icon(Icons.book),
                  title: Text(
                    spell.spell,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(spell.use),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final spellName = spell.spell;
                      await box.deleteAt(index);
                      await NotificationService().showInstantNotification(
                        title: 'Delete notification',
                        body: 'You deleted $spellName from your fav list!',
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
