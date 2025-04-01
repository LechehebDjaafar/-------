import 'package:flutter/material.dart';
import '../utils/app_localizations.dart';

class SettingsScreen extends StatelessWidget {
  final String currentLanguage;
  final Function(String) onLanguageChanged;

  const SettingsScreen({
    super.key,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final translations = AppLocalizations(currentLanguage);

    return ListView(
      children: [
        const SizedBox(height: 16),
        _buildSection(
          title: translations.translate('language'),
          child: Card(
            child: Column(
              children: [
                RadioListTile(
                  title: const Text('العربية'),
                  value: 'ar',
                  groupValue: currentLanguage,
                  onChanged: (value) => onLanguageChanged(value!),
                ),
                RadioListTile(
                  title: const Text('Français'),
                  value: 'fr',
                  groupValue: currentLanguage,
                  onChanged: (value) => onLanguageChanged(value!),
                ),
              ],
            ),
          ),
        ),
        _buildSection(
          title: translations.translate('about'),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(translations.translate('projectInfo')),
                  subtitle:
                      const Text('نظام إدارة النفايات الذكي في ولاية الشلف'),
                ),
                ListTile(
                  leading: const Icon(Icons.numbers),
                  title: Text(translations.translate('version')),
                  subtitle: const Text('1.0.0'),
                ),
              ],
            ),
          ),
        ),
        _buildSection(
          title: translations.translate('support'),
          child: Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: Text(translations.translate('contactUs')),
                  subtitle: const Text('support@sela-plus.dz'),
                  onTap: () {
                    // تنفيذ عملية الاتصال
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey,
            ),
          ),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}
