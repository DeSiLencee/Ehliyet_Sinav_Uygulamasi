import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayarlar'),
        centerTitle: true,
      ),
      body: Consumer<SettingsProvider>(
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