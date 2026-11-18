import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/spell.dart';
import '../services/api_service.dart';
import '../utils/show_top_snackbar.dart';
import 'character_screen.dart';
import 'favorite_spells_screen.dart';
import 'login_screen.dart';

class SpellsScreen extends StatefulWidget {
  const SpellsScreen({super.key});

  @override
  State<SpellsScreen> createState() => _SpellsScreenState();
}

class _SpellsScreenState extends State<SpellsScreen> {
  List<Spell> spells = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchSpells();
  }

  Future<void> fetchSpells() async {
    try {
      final result = await ApiService.getSpells();
      if (!mounted) return;
      setState(() {
        spells = result;
        isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        errorMessage = error.toString();
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loginData', false);
    if (!mounted) return;

    showTopSnackBar(
      context,
      title: 'Success!',
      message: 'Logged out Successfully',
      backgroundColor: Colors.green,
    );
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  void _toggleFavorite(Box<Spell> box, Spell spell) {
    if (box.containsKey(spell.index)) {
      box.delete(spell.index);
      showTopSnackBar(
        context,
        title: 'Remove!',
        message: '${spell.spell} removed from fav list!',
        backgroundColor: Colors.red,
      );
    } else {
      box.put(spell.index, spell);
      showTopSnackBar(
        context,
        title: 'Add!',
        message: '${spell.spell} successfully added to fav list!',
        backgroundColor: Colors.green,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final favoriteBox = Hive.box<Spell>('favorite_spells');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Spells Gallery'),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: errorMessage != null
                      ? Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Gagal memuat spell: $errorMessage',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                      errorMessage = null;
                                    });
                                    fetchSpells();
                                  },
                                  child: const Text('Coba lagi'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ValueListenableBuilder<Box<Spell>>(
                          valueListenable: favoriteBox.listenable(),
                          builder: (context, box, child) {
                            return ListView.builder(
                              itemCount: spells.length,
                              itemBuilder: (context, index) {
                                final spell = spells[index];
                                final isFavorite =
                                    box.containsKey(spell.index);

                                return Card(
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  child: ListTile(
                                    leading: const Icon(Icons.book),
                                    title: Text(
                                      spell.spell,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(spell.use),
                                    trailing: IconButton(
                                      icon: Icon(
                                        Icons.favorite,
                                        color: isFavorite
                                            ? Colors.red
                                            : Colors.black87,
                                      ),
                                      onPressed: () =>
                                          _toggleFavorite(box, spell),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CharacterScreen(),
                          ),
                        );
                      },
                      child: const Text('Characters'),
                    ),
                  ),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const FavoriteSpellsScreen(),
            ),
          );
        },
        backgroundColor: Colors.white,
        child: const Icon(Icons.favorite, color: Colors.red),
      ),
    );
  }
}
