import 'package:hive/hive.dart';

part 'spell.g.dart';

@HiveType(typeId: 0)
class Spell extends HiveObject {
  @HiveField(0)
  final int index;

  @HiveField(1)
  final String spell;

  @HiveField(2)
  final String use;

  Spell({required this.index, required this.spell, required this.use});

  factory Spell.fromJson(Map<String, dynamic> json) {
    return Spell(
      index: json['index'] ?? 0,
      spell: json['spell'] ?? '',
      use: json['use'] ?? '',
    );
  }
}
