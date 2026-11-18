import 'package:flutter/material.dart';

import '../models/character.dart';

class CharacterDetailScreen extends StatelessWidget {
  const CharacterDetailScreen({super.key, required this.character});

  final Character character;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(character.fullName)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  character.image,
                  width: double.infinity,
                  height: 300,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      height: 300,
                      child: Center(child: Icon(Icons.person, size: 100)),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            _detailRow('Full Name', character.fullName),
            _detailRow('Nickname', character.nickname),
            _detailRow('Hogwarts House', character.hogwartsHouse),
            _detailRow('Interpreted By', character.interpretedBy),
            _detailRow('Birthdate', character.birthdate),
            _detailRow('Children', character.children.join(', ')),
            _detailRow('Index', character.index.toString()),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(
              '$label:',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }
}
