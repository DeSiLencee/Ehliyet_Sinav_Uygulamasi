import 'package:ehliyet_sinav_uyg/features/auth/login_screen.dart';
import 'package:ehliyet_sinav_uyg/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _auth = AuthService();
  bool _isLoading = false;

  Future<void> _deleteAccount() async {
    final bool confirmed = await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hesabı Sil'),
        content: const Text('Hesabınızı silmek istediğinizden emin misiniz? Bu işlem geri alınamaz.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Sil'),
          ),
        ],
      ),
    ) ?? false;

    if (confirmed) {
      setState(() {
        _isLoading = true;
      });
      try {
        await _auth.deleteAccount();
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginScreen()),
          (route) => false,
        );
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Hesap silinirken bir hata oluştu. Lütfen tekrar deneyin.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Consumer<SettingsProvider>(
              builder: (context, settingsProvider, child) {
                return ListView(
                  padding: const EdgeInsets.all(16.0),
                  children: [
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Genel Ayarlar',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            _buildSettingRow(
                              'Soruları Karıştır',
                              Switch(
                                value: settingsProvider.shuffleQuestions,
                                onChanged: (value) {
                                  settingsProvider.setShuffleQuestions(value);
                                },
                              ),
                            ),
                            
                            _buildSettingRow(
                              'Zamanlayıcıyı Etkinleştir',
                              Switch(
                                value: settingsProvider.timerEnabled,
                                onChanged: (value) {
                                  settingsProvider.setTimerEnabled(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Card(
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Tema Ayarları',
                              style: Theme.of(context).textTheme.headlineSmall,
                            ),
                            const SizedBox(height: 16),
                            _buildSettingRow(
                              'Tema',
                              DropdownButton<ThemeMode>(
                                value: settingsProvider.themeMode,
                                onChanged: (ThemeMode? newValue) {
                                  if (newValue != null) {
                                    settingsProvider.setThemeMode(newValue);
                                  }
                                },
                                items: const [
                                  DropdownMenuItem(
                                    value: ThemeMode.light,
                                    child: Text('Aydınlık'),
                                  ),
                                  DropdownMenuItem(
                                    value: ThemeMode.dark,
                                    child: Text('Karanlık'),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton.icon(
                      onPressed: _deleteAccount,
                      icon: const Icon(Icons.delete_forever),
                      label: const Text('Hesabımı Sil'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                );
              },
            ),
    );
  }

  Widget _buildSettingRow(String title, Widget control) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16),
          ),
          control,
        ],
      ),
    );
  }
}