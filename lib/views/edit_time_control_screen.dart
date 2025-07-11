import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tempus/controllers/countdown_timer_controller.dart';
import 'package:tempus/controllers/time_control_controller.dart';
import '../components/are_you_sure_dialog.dart';
import '../l10n/app_localizations.dart';
import '../models/time_control.dart';

class EditTimeControlScreen extends StatefulWidget {
  final TimeControl model;
  const EditTimeControlScreen({super.key, required this.model});

  @override
  State<EditTimeControlScreen> createState() => _EditTimeControlScreenState();
}

class _EditTimeControlScreenState extends State<EditTimeControlScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  late int _minutes;
  late int _seconds;
  late int _increment;

  @override
  void initState() {
    super.initState();
    // Initialize with existing values from the model
    _nameController.text = widget.model.name;
    _minutes = widget.model.seconds ~/ 60;
    _seconds = widget.model.seconds % 60;
    _increment = widget.model.increment;
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      // Update the existing model directly
      widget.model.name = _nameController.text.trim();
      widget.model.seconds = (_minutes * 60) + _seconds;
      widget.model.increment = _increment;

      if (TimeControlController.presetExists(widget.model.name) &&
          widget.model.name != widget.model.name) {
        final bool? result = await showAreYouSureDialog(
          context: context,
          title: AppLocalizations.of(context).error,
          content: AppLocalizations.of(context).presetExistsError,
          confirmText: AppLocalizations.of(context).confirm,
          cancelText: AppLocalizations.of(context).cancel,
          confirmColor: Theme.of(context).colorScheme.secondary,
        );

        if (result != true) return;
      }

      if(TimeControlController.activeTimeControl.value.name == TimeControlController.selectedTimeControl.value.name) {
        CountdownTimerController.to.initialize(widget.model.seconds, widget.model.increment);
      }
      await TimeControlController.updatePreset(widget.model);

      Get.back();
    }
  }

  Future<void> _deleteTimeControl() async {
    final bool? result = await showAreYouSureDialog(
      context: context,
      title: AppLocalizations.of(context).deleteTimeControlTitle,
      content: AppLocalizations.of(context).deleteTimeControlConfirmation,
      confirmText: AppLocalizations.of(context).delete,
      cancelText: AppLocalizations.of(context).cancel,
      confirmColor: Theme.of(context).colorScheme.error,
    );

    if (result == true) {
      await TimeControlController.removePreset(widget.model.name);
      Get.back();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.editTimeControlTitle),
        actions: [
          IconButton(
            icon: Icon(Icons.delete, color: Colors.white54),
            onPressed: _deleteTimeControl,
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 0, 6, 0),
            child: IconButton(
              icon: const Icon(Icons.check),
              onPressed: _submit,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name Field
              Text(
                l10n.timeControlNameLabel.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _nameController,
                style: theme.textTheme.bodyLarge,
                decoration: InputDecoration(
                  hintText: l10n.timeControlNameHint,
                  filled: true,
                  fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: colorScheme.outline.withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: colorScheme.secondary,
                      width: 2,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 16,
                  ),
                  prefixIcon: Icon(
                    Icons.timer_outlined,
                    color: colorScheme.onSurface.withValues(alpha: 0.6),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.timeControlNameError;
                  } else if (value.trim().length > 20) {
                    return l10n.timeControlNameMaxLengthError;
                  } else if (value.trim().length < 3) {
                    return l10n.timeControlNameMinLengthError;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 28),

              // Base Time Section
              Text(
                l10n.baseTimeLabel.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _TimeDropdown(
                      value: _minutes,
                      items: List.generate(121, (index) => index),
                      labelBuilder: (value) => l10n.minutesSuffix(value),
                      onChanged: (value) => setState(() => _minutes = value!),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _TimeDropdown(
                      value: _seconds,
                      items: const [0, 15, 30, 45],
                      labelBuilder: (value) => l10n.secondsSuffix(value),
                      onChanged: (value) => setState(() => _seconds = value!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // Increment Section
              Text(
                l10n.incrementLabel.toUpperCase(),
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.6),
                  letterSpacing: 1.2,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              _TimeDropdown(
                value: _increment,
                items: List.generate(61, (index) => index),
                labelBuilder: (value) => l10n.incrementSuffix(value),
                onChanged: (value) => setState(() => _increment = value!),
              ),
              const SizedBox(height: 32),

              // Preview Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: colorScheme.outline.withValues(alpha: 0.2),
                    width: 1,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.visibility_outlined,
                          size: 18,
                          color: colorScheme.onSurface.withValues(alpha: 0.6),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          l10n.previewLabel,
                          style: theme.textTheme.labelLarge?.copyWith(
                            color: colorScheme.onSurface.withValues(alpha: 0.6),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      TimeControl(
                        (_minutes * 60) + _seconds,
                        _increment,
                        _nameController.text.isNotEmpty
                            ? _nameController.text
                            : widget.model.name,
                      ).toString(),
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeDropdown<T> extends StatelessWidget {
  final T value;
  final List<T> items;
  final String Function(T) labelBuilder;
  final ValueChanged<T?> onChanged;

  const _TimeDropdown({
    required this.value,
    required this.items,
    required this.labelBuilder,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonFormField<T>(
        value: value,
        items: items.map((item) => DropdownMenuItem(
          value: item,
          child: Text(
            labelBuilder(item),
            style: theme.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
          ),
        )).toList(),
        onChanged: onChanged,
        decoration: InputDecoration(
          filled: true,
          fillColor: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: colorScheme.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: BorderSide(
              color: colorScheme.secondary,
              width: 2,
            ),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
        ),
        borderRadius: BorderRadius.circular(14),
        dropdownColor: colorScheme.surface,
        icon: Icon(
          Icons.arrow_drop_down,
          color: colorScheme.onSurface.withValues(alpha: 0.6),
        ),
        style: theme.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}