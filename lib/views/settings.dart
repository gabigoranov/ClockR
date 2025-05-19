import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tempus/l10n/app_localizations.dart';
import '../services/locale_service.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).settings),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildLanguageTile(context),
            const SizedBox(height: 24),
            // Add more settings tiles here
          ],
        ),
      ),
    );
  }
  Widget _buildLanguageTile(context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Get.theme.copyWith(
          dividerColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory, // Disables all ripple effects
        ),
        child: InkWell(
          splashColor: Colors.transparent, // No splash effect
          highlightColor: Colors.transparent, // No highlight effect
          hoverColor: Colors.transparent, // No hover effect
          onTap: () {}, // Empty onTap to maintain clickability
          child: ExpansionTile(
            title: Text(AppLocalizations.of(context).languageText,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
            leading: Icon(Icons.language, color: Get.theme.colorScheme.primary),
            initiallyExpanded: true,
            tilePadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4), // Remove default padding
            childrenPadding: EdgeInsets.zero, // Remove default padding
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Column(
                  children: LocaleService.instance.languages.entries.map((entry) {
                    final isSelected = LocaleService.instance.language == entry.key;
                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Get.theme.colorScheme.primary.withValues(alpha: 0.1)
                            : Get.theme.scaffoldBackgroundColor,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          if (!isSelected)
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.03),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                        title: Text(
                          entry.value,
                          style: Get.textTheme.bodyLarge?.copyWith(
                            fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            color: isSelected
                                ? Get.theme.colorScheme.primary
                                : Get.theme.colorScheme.onSurface,
                          ),
                        ),
                        trailing: Radio<String>(
                          value: entry.key,
                          groupValue: LocaleService.instance.language,
                          onChanged: (value) async {
                            await LocaleService.instance.changeLanguage(value!);
                          },
                          activeColor: Get.theme.colorScheme.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () async {
                          await LocaleService.instance.changeLanguage(entry.key);
                        },
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}