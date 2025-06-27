import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tempus/components/time_control_component.dart';
import 'package:tempus/views/settings.dart';

import '../controllers/time_control_controller.dart';
import '../l10n/app_localizations.dart';
import '../models/time_control.dart';
import 'add_time_control_screen.dart';
import 'clock_screen.dart';
import 'edit_time_control_screen.dart';

class TimeControlSelectionScreen extends StatefulWidget {
  const TimeControlSelectionScreen({super.key});

  @override
  State<TimeControlSelectionScreen> createState() => _TimeControlSelectionScreenState();
}

class _TimeControlSelectionScreenState extends State<TimeControlSelectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerRight,
          child: Text(AppLocalizations.of(context).timeControls),
        ),
      ),
      body: Obx(() {
        String selectedName = TimeControlController.selectedTimeControl.value.name;
        String activeName = TimeControlController.activeTimeControl.value.name;

        debugPrint(selectedName);
        debugPrint(activeName);

        return Stack(
          children: [
            Column(
              children: [
                _buildActionBar(context),
                _buildCustomTimeControlsSection(context, selectedName),
                Expanded(
                  child: _buildTimeControlsSection(context, selectedName),
                ),
              ],
            ),
            Positioned(
              bottom: 16,
              left: 0,
              right: 0,
              child: _buildSelectTimeControlButton(
                context,
                selectedName != activeName,
              ),
            ),
          ],
        );

      }),
    );
  }

  Widget _buildTimeControlsSection(BuildContext context, String selectedName) {
    return Obx(() {
      final timeControls = TimeControlController.defaultTimeControls();

      final List<TimeControlComponent> cards = <TimeControlComponent>[
        for (int index = 0; index < timeControls.length; index += 1)
          TimeControlComponent(
            key: ValueKey(timeControls[index].name),
            model: timeControls[index],
            isSelected: timeControls[index].name == selectedName,
          ),
      ];

      Widget proxyDecorator(Widget child, int index, Animation<double> animation) {
        return AnimatedBuilder(
          animation: animation,
          builder: (BuildContext context, Widget? child) {
            final double animValue = Curves.easeInOut.transform(animation.value);
            final double scale = lerpDouble(1, 1.02, animValue)!;
            return Transform.scale(
              scale: scale,
              // Create a Card based on the color and the content of the dragged one
              // and set its elevation to the animated value.
              child: TimeControlComponent(
                key: ValueKey(timeControls[index].name),
                model: timeControls[index],
                isSelected: timeControls[index].name == selectedName,
              ),
            );
          },
          child: child,
        );
      }

      return Container(
        margin: const EdgeInsets.fromLTRB(0, 8, 0, 0),
        child: ReorderableListView(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          proxyDecorator: proxyDecorator,
          onReorder: (int oldIndex, int newIndex) async {
            if (oldIndex < newIndex) newIndex -= 1;
            debugPrint("Reordering from $oldIndex to $newIndex");
            await TimeControlController.reorderTimeControls(oldIndex, newIndex);
          },
          children: cards,
        ),
      );
    });
  }

  Widget _buildSelectTimeControlButton(BuildContext context, bool isNewSelection) {
    if(!isNewSelection) {
      // If the selected time control is already active, return an empty container
      return SizedBox.shrink();
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(30, 12, 30, 0),
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primaryContainer,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.symmetric(vertical: 20),
            ),
            onPressed: () {
              TimeControlController.activatePreset();
              Get.to(() => const ClockScreen(), transition: Transition.fade);
            },
            child: Text(AppLocalizations.of(context).select, style: TextStyle(fontSize: 22)),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomTimeControlsSection(BuildContext context, String selectedName) {

    return Obx(() {
      final customTimeControls = TimeControlController.customTimeControls();

      return Container(
        height: 240,
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
              offset: const Offset(0.1, 0.5),
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
                    child: customTimeControls.isEmpty
                        ? Text(
                      AppLocalizations.of(context).noCustomControls,
                      style: TextStyle(
                        fontSize: 14,
                      ),
                      textAlign: TextAlign.center,
                    )
                        :
                    ListView.builder(
                      itemCount: customTimeControls.length,
                      itemBuilder: (context, index) {
                        return TimeControlComponent(
                          model: customTimeControls[index],
                          isSelected: customTimeControls[index].name == selectedName,
                        );
                      },
                    )
                ),
              ),
            ],
          ),
        ),
      );
    });
  }

  Widget _buildActionBar(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primaryContainer,
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
              onTap: () => Get.to(() => const AddTimeControlScreen(), transition: Transition.leftToRight),
            ),
            _buildDivider(),
            _buildActionTile(
              context: context,
              icon: Icons.edit_note,
              label: AppLocalizations.of(context).edit,
              onTap: () {
                Get.to(() => EditTimeControlScreen(model: TimeControlController.selectedTimeControl.value,), transition: Transition.downToUp);
              },
            ),
            _buildDivider(),
            _buildActionTile(
              context: context,
              icon: Icons.settings_outlined,
              label: AppLocalizations.of(context).settings,
              onTap: () => Get.to(() => const SettingsPage(), transition: Transition.rightToLeft),
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