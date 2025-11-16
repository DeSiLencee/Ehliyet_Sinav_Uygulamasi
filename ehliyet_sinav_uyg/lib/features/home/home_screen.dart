import 'package:flutter/material.dart';

import '../../features/settings/settings_screen.dart'; // Will create this next
import '../month_list/month_list_screen.dart';
import '../test_list/test_list_screen.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // This map is used to link display names to Firebase keys
    const Map<String, String> categoryKeys = {
      'Trafik ve Çevre': 'trafik',
      'Motor ve Araç Tekniği': 'motor',
      'İlk Yardım': 'ilk_yardim',
      'Trafik Adabı': 'trafik_adabi',
    };

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ehliyet Sınavı Hazırlık'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Prominent Deneme Sınavı Button
            ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MonthListScreen()),
                );
              },
              icon: const Icon(Icons.assignment, size: 30),
              label: const Text('Deneme Sınavı', style: TextStyle(fontSize: 20)),
              style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
                minimumSize: WidgetStateProperty.all(const Size(double.infinity, 70)),
                backgroundColor: WidgetStateProperty.all(Theme.of(context).primaryColor),
                foregroundColor: WidgetStateProperty.all(Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            // Category Cards
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
                children: [
                  _buildCategoryCard(context, 'Trafik ve Çevre', Icons.traffic, categoryKeys['Trafik ve Çevre']!),
                  _buildCategoryCard(context, 'Motor ve Araç Tekniği', Icons.car_repair, categoryKeys['Motor ve Araç Tekniği']!),
                  _buildCategoryCard(context, 'İlk Yardım', Icons.medical_services, categoryKeys['İlk Yardım']!),
                  _buildCategoryCard(context, 'Trafik Adabı', Icons.directions_car, categoryKeys['Trafik Adabı']!),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            _buildQuickAccessButton(context, 'Ayarlar', Icons.settings, () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, String displayName, IconData icon, String categoryKey) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => TestListScreen(
                categoryKey: categoryKey,
                displayName: displayName,
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 16),
              Text(
                displayName,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildQuickAccessButton(BuildContext context, String title, IconData icon, VoidCallback onPressed) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(title),
      style: Theme.of(context).elevatedButtonTheme.style?.copyWith(
        minimumSize: WidgetStateProperty.all(Size(double.infinity, 50)), // Full width button
      ),
    );
  }
}