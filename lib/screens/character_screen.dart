import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/character.dart';
import '../services/api_service.dart';
import '../utils/show_top_snackbar.dart';
import 'character_detail_screen.dart';
import 'login_screen.dart';
import 'spells_screen.dart';

class CharacterScreen extends StatefulWidget {
  const CharacterScreen({super.key});

  @override
  State<CharacterScreen> createState() => _CharacterScreenState();
}

class _CharacterScreenState extends State<CharacterScreen> {
  List<Character> characters = [];
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    fetchCharacters();
  }

  Future<void> fetchCharacters() async {
    try {
      final result = await ApiService.getCharacters();
      if (!mounted) return;
      setState(() {
        characters = result;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Harry Potter Characters'),
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
                                  'Gagal memuat karakter: $errorMessage',
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 12),
                                ElevatedButton(
                                  onPressed: () {
                                    setState(() {
                                      isLoading = true;
                                      errorMessage = null;
                                    });
                                    fetchCharacters();
                                  },
                                  child: const Text('Coba lagi'),
                                ),
                              ],
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: characters.length,
                          itemBuilder: (context, index) {
                            final character = characters[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              child: ListTile(
                                leading: SizedBox(
                                  width: 52,
                                  height: 56,
                                  child: Image.network(
                                    character.image,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.person, size: 40);
                                    },
                                  ),
                                ),
                                title: Text(
                                  character.fullName,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(character.interpretedBy),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          CharacterDetailScreen(
                                        character: character,
                                      ),
                                    ),
                                  );
                                },
                              ),
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
                            builder: (context) => const SpellsScreen(),
                          ),
                        );
                      },
                      child: const Text('Spells'),
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
