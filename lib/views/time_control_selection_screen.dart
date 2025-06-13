import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tempus/components/time_control_component.dart';
import 'package:tempus/views/settings.dart';

import '../controllers/timer_controller.dart';
import '../l10n/app_localizations.dart';
import 'add_time_control_screen.dart';

class TimeControlSelectionScreen extends StatelessWidget {
  const TimeControlSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final String selectedName = TimerController.currentTimeControl.value.name;

    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(AppLocalizations.of(context).timeControls),
        ),
      ),
      body: Column(
        children: [
          _buildActionBar(context),
          _buildCustomTimeControlsSection(context, selectedName),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
              child: Obx(() => ListView.builder(
                  itemCount: TimerController.timeControlPresets.length,
                  itemBuilder: (context, index) {
                    return TimeControlComponent(
                      model: TimerController.timeControlPresets[index],
                      isSelected: TimerController.timeControlPresets[index].name == selectedName,
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomTimeControlsSection(BuildContext context, String selectedName) {
    return Container(
      height: 200,
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: Theme.of(context).brightness == Brightness.light
            ? [
          BoxShadow(
            color: Theme.of(context).colorScheme.shadow.withValues(alpha: 0.14),
            spreadRadius: 0,
            blurRadius: 6,
            offset: const Offset(1, 5),
          )
        ]
            : [],
        border: Theme.of(context).brightness == Brightness.dark
            ? Border.all(color: Colors.grey[700]!, width: 1)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              AppLocalizations.of(context).customControls,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Center(
                child: TimerController.customTimeControls().isEmpty
                    ? Text(
                        AppLocalizations.of(context).noCustomControls,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      )
                    :
                ListView.builder(
                  itemCount: TimerController.customTimeControls().length,
                  itemBuilder: (context, index) {
                    return TimeControlComponent(
                      model: TimerController.customTimeControls()[index],
                      isSelected: TimerController.customTimeControls()[index].name == selectedName,
                    );
                  },
                )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondaryContainer,
        borderRadius: BorderRadius.circular(12), // Rounded corners
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildActionTile(
              context: context,
              icon: Icons.add_circle_outline,
              label: AppLocalizations.of(context).newTimeControl,
              onTap: () => Get.to(() => const AddTimeControlScreen(), transition: Transition.fade),
            ),
            _buildDivider(),
            _buildActionTile(
              context: context,
              icon: Icons.edit_note,
              label: AppLocalizations.of(context).edit,
              onTap: () => Get.toNamed('/edit-time-controls'),
            ),
            _buildDivider(),
            _buildActionTile(
              context: context,
              icon: Icons.settings_outlined,
              label: AppLocalizations.of(context).settings,
              onTap: () => Get.to(() => const SettingsPage(), transition: Transition.fade),
            ),
          ],
        ),
      ),
    );
  }
  Widget _buildActionTile({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    // Animation controllers would be better managed with StatefulWidget,
    // but for simplicity we're using GestureDetector with implicit animations
    return Expanded(
      child: GestureDetector(
        onTapDown: (_) => onTap(),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 1.0, end: 1.0), // Default scale
          duration: const Duration(milliseconds: 150),
          builder: (context, scale, child) {
            return Transform.scale(
              scale: scale,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onTap,
                  borderRadius: BorderRadius.circular(8),
                  splashColor: Colors.blue.withValues(alpha: 0.2),
                  highlightColor: Colors.blue.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          icon,
                          size: 28,
                          color: Colors.white ,
                        ),
                        const SizedBox(height: 6),
                        Text(
                          label,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
          child: null, // Placeholder, actual child is in builder
        ),
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      width: 1,
      height: 40,
      color: Colors.blue.shade100,
    );
  }
}