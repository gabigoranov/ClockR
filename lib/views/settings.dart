import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/theme_controller.dart';
import 'package:tempus/l10n/app_localizations.dart';
import '../services/locale_service.dart';


class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final LocaleService localeService = Get.find<LocaleService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(AppLocalizations.of(context).settings),
        ),
        centerTitle: true,
        elevation: 0.4,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildLanguageTile(context),
              const SizedBox(height: 10),
              _buildDarkModeTile(
                context,
              ),


            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageTile(context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.14),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0.1, 0.5),
          )
        ]
            : [],
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: Colors.grey[700]!, width: 1)
            : null,
        borderRadius: BorderRadius.circular(12),
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
          onTap: () {}, // Empty onTap to maintain click ability
          child: ExpansionTile(
            title: Text(AppLocalizations.of(context).languageText,
                style: Get.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                )),
            leading: Icon(Icons.language, color: Get.theme.colorScheme.primary),
            initiallyExpanded: true,
            tilePadding: EdgeInsets.symmetric(horizontal: 16, vertical: 4), // Remove default padding
            childrenPadding: EdgeInsets.zero, // Remove default padding
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4),
                child: Column(
                  children: localeService.languages.entries.map((entry) {
                    final isSelected = localeService.language == entry.key;
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
                              offset: const Offset(0, 0.1),
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
                          groupValue: localeService.language,
                          onChanged: (value) async {
                            await localeService.changeLanguage(value!);
                          },
                          activeColor: Get.theme.colorScheme.primary,
                          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        onTap: () async {
                          await localeService.changeLanguage(entry.key);
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

  Widget _buildDarkModeTile(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Get.theme.scaffoldBackgroundColor,
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.14),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(0.1, 0.5),
          )
        ]
            : [],
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: Colors.grey[700]!, width: 1)
            : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Theme(
        data: Get.theme.copyWith(
          dividerColor: Colors.transparent,
          splashFactory: NoSplash.splashFactory,
        ),
        child: ListTile(
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          leading: Icon(
            ThemeController.to.isDarkMode ? Icons.dark_mode : Icons.light_mode,
            color: Get.theme.colorScheme.primary,
          ),
          title: Text(
            AppLocalizations.of(context).darkMode,
            style: Get.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          trailing: Transform.scale(
            scale: 0.8,
            child: CupertinoSwitch(
              value: ThemeController.to.isDarkMode,
              onChanged: (value) {
                setState(() {
                  ThemeController.to.isDarkMode ? ThemeController.to.setTheme("light") : ThemeController.to.setTheme("dark");
                });
              },
              activeTrackColor: Get.theme.colorScheme.primary,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          onTap: () {
            setState(() {
              ThemeController.to.isDarkMode ? ThemeController.to.setTheme("light") : ThemeController.to.setTheme("dark");
            });
          },
        ),
      ),
    );
  }

}

